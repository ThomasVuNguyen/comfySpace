import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:comfyssh_flutter/comfyScript/LED.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

import '../comfyScript/stepperMotor.dart';
import '../function.dart';
import '../main.dart';


class spaceTile extends StatefulWidget {
  const spaceTile({super.key, required this.spaceName});
  final String spaceName;

  @override
  State<spaceTile> createState() => _spaceTileState();
}

class _spaceTileState extends State<spaceTile> {
  late String spaceNameHolder; late String hostNameHolder; late String userNameHolder; late String passwordHolder;
  @override
  void initState(){
    super.initState();
    getSpaceInfo(widget.spaceName);

  }

  Future<void> getSpaceInfo(String spaceName) async{
    var spaceInfo = await hostInfoRenderer('comfySpace.db', widget.spaceName);
    print(spaceInfo.toString());
    hostNameHolder = spaceInfo['host'].toString();
    userNameHolder = spaceInfo['user'].toString();
    passwordHolder = spaceInfo['password'].toString();
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: const BoxDecoration(
              color: textcolor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),topRight: Radius.circular(0.0),bottomLeft: Radius.circular(8.0),bottomRight: Radius.circular(0.0),
              )
          ),
          height: 128, width: 106,
          child: IconButton(
              onPressed: () {
              },
              icon: Icon(Icons.add, size: 50,)
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width-40-106, height: 128,
          decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(
                color: Colors.blue,
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(10,10),
              )]
          ),
          child: ListTile(contentPadding: const EdgeInsets.only(top:0.0, bottom: 0.0),
              trailing: Container( width: 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Icon(Icons.arrow_forward_ios, color: textcolor,size: 25,),
                  ],
                ),
              ),
              onLongPress: () {
            //spaceNameHolder = '';
              showDialog(context: context, builder: (BuildContext context){
                return AlertDialog(
                  title: Text("Edit Space"),
                  content: Column(
                    children: [
                      TextField(
                          onChanged: (text1){
                            spaceNameHolder = text1;},
                          decoration: const InputDecoration(hintText: "space"), textInputAction: TextInputAction.next),
                      TextField(
                        onChanged: (hostname){
                          hostNameHolder = hostname;},
                        decoration: const InputDecoration(hintText: "hostname"), textInputAction: TextInputAction.next,),
                      TextField(
                        onChanged: (username){
                          userNameHolder = username;
                        }, decoration: const InputDecoration(hintText: "username"), textInputAction: TextInputAction.next,
                      ),
                      TextField(
                        onChanged: (password){
                          passwordHolder = password;
                        }, decoration: const InputDecoration(hintText: "password"), textInputAction: TextInputAction.next,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(onPressed: (){
                      updateAndroidMetaData('comfySpace.db');
                    }, child: const Text("METADATA")),
                    TextButton(onPressed: (){
                      deleteDB('comfySpace.db');
                    }, child: Text("Wipe")),
                    TextButton(onPressed: (){
                      deleteSpace('comfySpace.db', widget.spaceName);
                      Navigator.pop(context);
                      setState(() {});
                    }, child: Text("Delete")),
                    TextButton(onPressed: (){
                      editSpace('comfySpace.db', widget.spaceName, spaceNameHolder, hostNameHolder, userNameHolder, passwordHolder);
                      Navigator.pop(context);
                      setState(() {
                        print(widget.spaceName);
                        print(spaceNameHolder);
                      });
                    }, child: const Text("Rename")),
                  ],
                );
              });
              },
              onTap: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) => spacePage(spaceName: widget.spaceName, hostname: hostNameHolder, username: userNameHolder, password: passwordHolder)),);
                print("$userNameHolder@$hostNameHolder");
              },
              shape: const RoundedRectangleBorder(side: BorderSide(width: 2, color:textcolor) , borderRadius: BorderRadius.only(topLeft: Radius.circular(0.0),topRight: Radius.circular(8.0),bottomLeft: Radius.circular(0.0),bottomRight: Radius.circular(8.0),)),
              title: Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 23, bottom: 23),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.spaceName, style: GoogleFonts.poppins(color: textcolor, fontWeight: FontWeight.bold,  fontSize: 20)),
                    Text("${widget.spaceName} @ ${widget.spaceName}", style: GoogleFonts.poppins(color: textcolor, fontSize: 16)),
                  ],
                ),
              )
          ),

        )
      ],
    );
  }
}

class LedToggle extends StatefulWidget {
  const LedToggle({super.key, required this.name, required this.pin, required this.id, required this.hostname, required this.username, required this.password});
  final String name;
  final String pin;
  final int id;
  final String hostname; final String username; final String password;
  @override
  State<LedToggle> createState() => _LedToggleState();
}

class _LedToggleState extends State<LedToggle> {
  bool toggleState=false;
  late SSHClient client;
  @override
  void initState(){
    super.initState();
    initClient();
  }
  Future<void> initClient() async{
    client = SSHClient(
      await SSHSocket.connect(widget.hostname, 22),
      username: widget.username,
      onPasswordRequest: () => widget.password,
    );
    print("initClient username: ${client.username}");
  }
  @override
  Widget build(BuildContext context) {
        return Container(
          height: 100,
          color: Colors.red,
          child: GestureDetector(
            onLongPress: (){
              deleteButton('comfySpace.db', spaceLaunch, widget.name, widget.id);
              setState(() {
              });
            },
            child: FlutterSwitch(
              value: toggleState,
              width: 100, height: 80,
              activeColor: Colors.orange,
              activeIcon: Text("ON"), inactiveIcon: Text("OFF"), activeTextFontWeight: FontWeight.normal, inactiveTextFontWeight: FontWeight.normal,
              padding: 0,
              activeText: "yo", inactiveText: "nah",
              onToggle: (val) async {
                setState(() {toggleState = val;});
                var command = await client.run(toggleLED(widget.pin.toString(), toggleState));
                HapticFeedback.heavyImpact();
              },

            )
          ),
        );


  }
}

class StepperMotor extends StatefulWidget {
  const StepperMotor({super.key, required this.name, required this.id, required this.pin1, required this.pin2, required this.pin3, required this.pin4, required this.hostname, required this.username, required this.password});
  final String name; final int id; final String pin1; final String pin2; final String pin3; final String pin4;
  final String hostname; final String username; final String password;

  @override
  State<StepperMotor> createState() => _StepperMotorState();
}

class _StepperMotorState extends State<StepperMotor> {
  int rotationDirection = 1; //0 means counterclockwise, 1 means stop, 2 means clockwise
  final List<bool> _stepperState = <bool>[false, true, false];
  late SSHClient client;
  void initState(){
    super.initState();
    initClient();
  }
  Future<void> initClient() async{
    client = SSHClient(
      await SSHSocket.connect(widget.hostname, 22),
      username: widget.username,
      onPasswordRequest: () => widget.password,
    );
    print("initClient username: ${client.username}");
  }
  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
        children: const <Widget>[
          Icon(Icons.arrow_left),
          Icon(Icons.stop),
          Icon(Icons.arrow_right),
        ],
        direction: Axis.vertical,
        isSelected: _stepperState,
        onPressed: (int index){
          for (int i=0; i<_stepperState.length; i++){
            _stepperState[i] = i==index;
            if(i==index){
              stepperMotor(widget.pin1, widget.pin2, widget.pin3, widget.pin4, index.toString());
            }
          }
    },
    );
  }
}

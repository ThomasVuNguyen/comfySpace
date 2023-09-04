import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:comfyssh_flutter/comfyScript/HC_SR04.dart';
import 'package:comfyssh_flutter/comfyScript/LED.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:xterm/core.dart';
import 'package:xterm/ui.dart';
import '../comfyScript/stepperMotor.dart';
import '../function.dart';
import '../main.dart';
import '../state.dart';


class comfyAppBar extends StatefulWidget {
  const comfyAppBar({super.key, required this.title});
  final String title;

  @override
  State<comfyAppBar> createState() => _comfyAppBarState();
}

class _comfyAppBarState extends State<comfyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      shape: const Border(bottom: BorderSide(color: textcolor, width: 2)),
      toolbarHeight: 64,
      title: Row(
        children: <Widget>[
          const SizedBox(width: 0, height: 20, child: DecoratedBox(decoration: BoxDecoration(color: bgcolor)),),
          Text(widget.title, style: GoogleFonts.poppins(color: textcolor, fontWeight: FontWeight.bold, fontSize: 24),),
        ],
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: bgcolor),
      elevation: 0,
      backgroundColor: bgcolor,
    );
  }
}

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

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator();
  }
}

class LedToggle extends StatefulWidget {
  const LedToggle({super.key, required this.spaceName, required this.name, required this.pin, required this.id, required this.hostname, required this.username, required this.password, required this.terminal});
  final String name;
  final String pin;
  final int id;
  final String hostname; final String username; final String password; final String spaceName;
  final Terminal terminal;
  @override
  State<LedToggle> createState() => _LedToggleState();
}

class _LedToggleState extends State<LedToggle> {
  bool toggleState=false;
  bool SSHLoadingFinished = false;
  late SSHClient client;
  @override
  void initState(){
    super.initState();
    initClient();

  }
  @override
  void dispose(){
    super.dispose();
    client.close();
  }
  Future<void> initClient() async{
    client = SSHClient(
      await SSHSocket.connect(widget.hostname, 22),
      username: widget.username,
      onPasswordRequest: () => widget.password,
    );
    print("initClient username: ${client.username}");
    setState(() {SSHLoadingFinished = true;});

  }
  Future<void> closeClient() async{
    final shell = await client.shell();
    await shell.done;
    client.close();

  }
  @override
  Widget build(BuildContext context) {
    if(SSHLoadingFinished == true){
      return Padding(
        padding: EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          color: toggleState ? Colors.grey[900] : const Color.fromARGB(44, 164, 167, 189),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: Icon(Icons.add, color: toggleState? Colors.white :Colors.grey.shade700,),
              ),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(left: 25.0),
                        child: Text(
                          widget.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: toggleState? Colors.white :Colors.black,
                          ),
                        ),
                  )),
                  Transform.rotate(
                      angle: pi/2,
                    child: CupertinoSwitch(
                      activeColor: Colors.blue,
                      value: toggleState,
                      onChanged: (bool? value) async {
                        if (value == true){
                          widget.terminal.write('LED ${widget.pin} on \r\n');
                        }
                        else{
                          widget.terminal.write('LED ${widget.pin} off \r\n');
                        }

                        setState((){
                          toggleState = value!;
                          print(toggleState.toString());
                        });
                        HapticFeedback.vibrate();
                        var command = await client.run(toggleLED(widget.pin.toString(), toggleState));
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );}
    else{
      return const LoadingWidget();
    }
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
  bool SSHLoadingFinished = false;
  int rotationDirection = 1; //0 means counterclockwise, 1 means stop, 2 means clockwise
  final List<bool> _stepperState = <bool>[false, true, false];
  late SSHClient client;
  @override
  void initState(){
    super.initState();
    initClient();
  }
  @override
  void dispose(){
    closeClient();
    super.dispose();
  }
  Future<void> initClient() async{
    client = SSHClient(
      await SSHSocket.connect(widget.hostname, 22),
      username: widget.username,
      onPasswordRequest: () => widget.password,
    );
    print("initClient username: ${client.username}");
    setState(() {SSHLoadingFinished = true;});
  }
  Future<void> closeClient() async{
    final shell = await client.shell();
    await shell.done;
    client.close();

  }
  @override
  Widget build(BuildContext context) {
    if(SSHLoadingFinished == true){
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Expanded(child: Container(color: Colors.orange,),),
            ToggleButtons(
              borderRadius: BorderRadius.circular(32.0),
                direction: Axis.vertical,
                isSelected: _stepperState,
                onPressed: (int index) async{
                  for (int i=0; i<_stepperState.length; i++){
                    _stepperState[i] = i == index;
                    if(i==index){
                      index = index-1;
                      var stepperCommand = stepperMotor(widget.pin1, widget.pin2, widget.pin3, widget.pin4, index.toString());
                      var command = await client.run(stepperCommand);
                    }
                    setState(() {
                    });
                  }
            },
                children: <Widget>[
                  Container(child: Icon(Icons.arrow_left,),),
                  Container(child: Icon(Icons.stop)),
                  Container(child: Icon(Icons.arrow_right)),
                ],
            ),
          ],
        ),
      );}
    else{
      return const LoadingWidget();
    }
  }
}

class DistanceSensor extends StatefulWidget {
  const DistanceSensor({super.key, required this.spaceName, required this.name, required this.id, required this.hostname, required this.username, required this.password, required this.trig,required this.echo});
  final String spaceName; final String name; final int id;
  final String hostname; final String username; final String password;
  final String trig; final String echo;
  @override
  State<DistanceSensor> createState() => _DistanceSensorState();
}

class _DistanceSensorState extends State<DistanceSensor> {
  bool SSHLoadingFinished = false; late SSHClient client;
  late Timer timer; late String data;
  @override
  void initState(){
    timer = Timer.periodic(Duration(seconds:1), (timer) {
      updateData();
      setState(() {});
    });
    super.initState();
    initClient();
    //SSHLoadingFinished = true;
  }
  @override
  void dispose(){
    super.dispose();
    client.close();
    timer?.cancel();
  }
  Future<void> updateData() async{
    data = await readDistance(client, widget.trig, widget.echo);
  }
  Future<void> initClient() async{
    //terminal.write("Connecting... \r\n");
    client = SSHClient(
      await SSHSocket.connect(widget.hostname, port),
      username: widget.username,
      onPasswordRequest: () => widget.password
    );
    //terminal.write("Connected \r\n");
    /*final session = await client.shell(
      pty: SSHPtyConfig(
        width: terminal.viewWidth, height: terminal.viewWidth,
      )
    );
    terminal.buffer.clear(); terminal.buffer.setCursor(0, 0);
    terminal.onOutput = (data){
      session.write(utf8.encode(data) as Uint8List);
    };
    session.stdout
        .cast<List<int>>()
        .transform(Utf8Decoder())
        .listen(terminal.write);

    session.stderr
        .cast<List<int>>()
        .transform(Utf8Decoder())
        .listen(terminal.write);*/
    SSHLoadingFinished = true;
  }
  @override
  Widget build(BuildContext context) {
    if(SSHLoadingFinished == false){
      return LoadingWidget();
    }
    else if(client!=null){
      return Padding(
        padding: const EdgeInsets.all(0.0),
        child: StreamBuilder(
          stream: readDistanceStream(client, widget.trig, widget.echo),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if(!snapshot.hasData){
              print("loading");
              return const LoadingWidget();
            }
            else if(snapshot.hasData && snapshot.data?[0] != "T"){
              return Padding(
                  padding: EdgeInsets.all(15.0),
                child: Container(
                  decoration: BoxDecoration( borderRadius: BorderRadius.circular(24.0), color: Colors.grey[900] ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25.0),
                    child: Center(child: Text('${snapshot.data}', style: TextStyle(color: Colors.orange),)),

                  ),
                ),
              );
              
              //return Text('${snapshot.data}');
            }
            else if(snapshot.hasData && snapshot.data?[0] == "T"){
              return Padding(
                padding: EdgeInsets.all(15.0),
                child: Container(
                  decoration: BoxDecoration( borderRadius: BorderRadius.circular(24.0), color: Colors.grey[900] ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 25.0),
                    child: Center(child: Text('...', style: TextStyle(color: Colors.orange),)),

                  ),
                ),
              );

              //return Text('${snapshot.data}');
            }
            return const CircularProgressIndicator();

          },
        )
      );
    }
    else{
      return CircularProgressIndicator();
    }
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:comfyssh_flutter/comfyScript/HC_SR04.dart';
import 'package:comfyssh_flutter/comfyScript/LED.dart';
import 'package:comfyssh_flutter/components/LoadingWidget.dart';
import 'package:comfyssh_flutter/components/pop_up.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xterm/core.dart';
import 'package:xterm/ui.dart';
import '../comfyScript/DCmotor.dart';
import '../comfyScript/customInput.dart';
import '../comfyScript/stepperMotor.dart';
import '../function.dart';
import '../main.dart';
import '../state.dart';

const double buttonPadding = 2.0;

class comfyAppBar extends StatefulWidget {
  const comfyAppBar({super.key, required this.title, this.WiredashWidget, this.automaticallyImplyLeading = false});
  final String title; final Widget? WiredashWidget; final bool automaticallyImplyLeading;
  @override
  State<comfyAppBar> createState() => _comfyAppBarState();
}

class _comfyAppBarState extends State<comfyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      actions: [
        Row(
          children: [
            (widget.WiredashWidget != null)? widget.WiredashWidget! :SizedBox(width: 0,),
            SizedBox(width: 10,),
          ],
        )
      ],
      iconTheme: IconThemeData(
        //color: textcolor,
      ),
      toolbarHeight: 64,
      titleSpacing: 20,
      title: Row(
        children: <Widget>[
          Text(widget.title,),
        ],
      ),
      elevation: 0,
    );
  }
}

class spaceTile extends StatefulWidget {
  const spaceTile({super.key, required this.spaceName});
  final String spaceName;

  @override
  State<spaceTile> createState() => _spaceTileState();
}

/*class _spaceTileState extends State<spaceTile> {
  late String spaceNameHolder; late String hostNameHolder; late String userNameHolder; late String passwordHolder;
  @override
  void initState(){
    super.initState();
    getSpaceInfo(widget.spaceName);
  }
  void editPrompt(){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: const Text("Edit Space"),
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
          /*TextButton(onPressed: (){
            updateAndroidMetaData('comfySpace.db');
          }, child: const Text("METADATA")),
          TextButton(onPressed: (){
            deleteDB('comfySpace.db');
          }, child: Text("Wipe")),*/
          TextButton(onPressed: (){
            deleteSpace('comfySpace.db', widget.spaceName);
            Navigator.push(context, MaterialPageRoute(builder: (context) =>  const comfySpace()),);
            Future.delayed(const Duration(milliseconds: 100), (){
              setState(() {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  const comfySpace()),);
              });
            });
            Navigator.pop(context);
          }, child: Text("Delete")),
          TextButton(onPressed: (){
            editSpace('comfySpace.db', widget.spaceName, spaceNameHolder, hostNameHolder, userNameHolder, passwordHolder);
            Navigator.push(context, MaterialPageRoute(builder: (context) =>  const comfySpace()),);
            Future.delayed(const Duration(milliseconds: 100), (){
              setState(() {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  const comfySpace()),);
              });
            });
            Navigator.pop(context);
            setState(() {
              print(widget.spaceName);
              print(spaceNameHolder);
            });
          }, child: const Text("Rename")),
        ],
      );
    });
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
            icon: const Icon(Icons.add, size: 50,color: Colors.white,)
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
                children: <Widget>[
                  IconButton(onPressed: (){editPrompt();}, icon: Icon(Icons.edit, size: 25,))
                ],
              ),
            ),
            onLongPress: () { editPrompt(); },
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
}*/
class _spaceTileState extends State<spaceTile> {
  late String spaceNameHolder; late String hostNameHolder; late String userNameHolder; late String passwordHolder; bool hostInfoLoaded = false;
  @override
  void initState(){
    super.initState();
    getSpaceInfo(widget.spaceName);
    setState(() {
    });
  }
  void editPrompt(){
    showDialog(context: context, builder: (BuildContext context){
      return EditSpaceDialog(spaceName: widget.spaceName);
      /*return AlertDialog(
        title: const Text("Edit Space"),
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
          /*TextButton(onPressed: (){
            updateAndroidMetaData('comfySpace.db');
          }, child: const Text("METADATA")),
          TextButton(onPressed: (){
            deleteDB('comfySpace.db');
          }, child: Text("Wipe")),*/
          TextButton(onPressed: (){
            deleteSpace('comfySpace.db', widget.spaceName);
            //Navigator.push(context, MaterialPageRoute(builder: (context) =>  const comfySpace()),);
            Future.delayed(const Duration(milliseconds: 100), (){
              setState(() {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  const comfySpace()),);
              });
            });
            Navigator.pop(context);
          }, child: Text("Delete")),
          TextButton(onPressed: (){
            editSpace('comfySpace.db', widget.spaceName, spaceNameHolder, hostNameHolder, userNameHolder, passwordHolder);
            //Navigator.push(context, MaterialPageRoute(builder: (context) =>  const comfySpace()),);
            Future.delayed(const Duration(milliseconds: 100), (){
              setState(() {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  const comfySpace()),);
              });
            });
            Navigator.pop(context);
            setState(() {
              print(widget.spaceName);
              print(spaceNameHolder);
            });
          }, child: const Text("Rename")),
        ],
      );*/
    });
  }
  Future<void> getSpaceInfo(String spaceName) async{
    var spaceInfo = await hostInfoRenderer('comfySpace.db', widget.spaceName);
    print(spaceInfo.toString());
    hostNameHolder = spaceInfo['host'].toString();
    userNameHolder = spaceInfo['user'].toString();
    passwordHolder = spaceInfo['password'].toString();
    hostInfoLoaded = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          children: [
            /*Container(
              decoration: const BoxDecoration(
                color: textcolor,

                borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(0.0), bottomLeft: Radius.circular(8.0), bottomRight: Radius.circular(0.0))
              ),
              height: 128, width: 106,
              child: IconButton(
                onPressed: (){},
                icon: const Icon(Icons.terminal, size: 50, color: Colors.white,)
              ),
            ),*/
            SizedBox(
              width: MediaQuery.of(context).size.width-40,
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.only(top:16.0, bottom: 16.0, left: 16.0, right: 16.0),
                trailing: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect( borderRadius: BorderRadius.circular(12),
                    child: Container(
                      color: Theme.of(context).colorScheme.primary,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: (){
                                editPrompt();
                          }, icon: const Icon(Icons.edit_outlined, color: Color(0xffEADDFF),))
                        ],
                      ),
                    ),
                  ),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => spacePage(spaceName: widget.spaceName, hostname: hostNameHolder, username: userNameHolder, password: passwordHolder)),);
                  print("$userNameHolder@$hostNameHolder");
                },
                shape: RoundedRectangleBorder(side: BorderSide(width: 2, color: Theme.of(context).colorScheme.tertiary), borderRadius: BorderRadius.only(topLeft: Radius.circular(12.0), bottomLeft: Radius.circular(8.0), topRight: Radius.circular(8.0), bottomRight: Radius.circular(8.0)), ),
                  title: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(widget.spaceName, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),),
                      hostInfoLoaded? Text('$userNameHolder @ $hostNameHolder', style: GoogleFonts.poppins(fontSize: 16), ) : Text('')
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
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
    print("closed");
  }
  @override
  Widget build(BuildContext context) {
    if(SSHLoadingFinished == true){
      return GestureDetector(
        onTap: () async {
          if (toggleState == true){
            widget.terminal.write('LED ${widget.pin} on \r\n');
          }
          else{
            widget.terminal.write('LED ${widget.pin} off \r\n');
          }
          setState((){
            toggleState = !toggleState;
            print(toggleState.toString());
          });
          HapticFeedback.vibrate();
          var command = await client.run(toggleLED(widget.pin.toString(), toggleState));
        },
        child: Padding(
          padding: EdgeInsets.all(buttonPadding),
          child: Container(
            color: toggleState? Colors.white :Colors.black,
            child: Padding(
              padding: EdgeInsets.all(buttonPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity, alignment: AlignmentDirectional.center,
                    color: toggleState? Colors.black: Colors.white,
                    child: Text(
                      widget.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: toggleState? Colors.white :Colors.black,
                      ),
                    ),
                  ),
                  Container(height: 2.0,
                      color: toggleState? Colors.black: Colors.white,
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      color: toggleState? Colors.black: Colors.white,
                        child: Icon(toggleState? Icons.emoji_objects :Icons.lightbulb, color: toggleState? Colors.white :Colors.grey.shade700,)),
                  )
                ],
              ),
            ),
          ),
        ),
      );}
    else{
      return const LoadingSpaceWidget();
    }
  }
}

/*class DistanceSensor extends StatefulWidget {
  const DistanceSensor({super.key, required this.spaceName, required this.name, required this.id, required this.hostname, required this.username, required this.password, required this.trig,required this.echo});
  final String spaceName; final String name; final int id;
  final String hostname; final String username; final String password;
  final String trig; final String echo;
  @override
  State<DistanceSensor> createState() => _DistanceSensorState();
}

class _DistanceSensorState extends State<DistanceSensor> {
  bool SSHLoadingFinished = false; late SSHClient client; late String data;
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
    SSHLoadingFinished = true;
    print('distance sensor connected');
  }
  @override
  Widget build(BuildContext context) {
    if(SSHLoadingFinished == false){
      return const LoadingSpaceWidget();
    }
    else{
      print("lets load");
      return Padding(
        padding: const EdgeInsets.all(0.0),
        child: StreamBuilder(
          stream: readDistanceStream(client, widget.trig, widget.echo),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if(!snapshot.hasData){
              return Text("no data");
              //return const LoadingSpaceWidget();
            }
            else if(snapshot.hasData){
              return Text(snapshot.data!);
              /*return Padding(
                  padding: const EdgeInsets.all(15.0),
                child: Container(
                  decoration: BoxDecoration( borderRadius: BorderRadius.circular(24.0), color: Colors.grey[900] ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25.0),
                    child: Center(child: Text('${snapshot.data}', style: TextStyle(color: Colors.orange),)),

                  ),
                ),
              );*/

              //return Text('${snapshot.data}');
            }
            /*else if(snapshot.hasData && snapshot.data?[0] == "T"){
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
            }*/
            else{
              return Text("something else");
            }
          },
        )
      );
    }
  }
}*/

class CustomToggleButton extends StatefulWidget {
  const CustomToggleButton({super.key, required this.name, required this.hostname, required this.username, required this.password, required this.commandOn, required this.commandOff, required this.terminal});
  final String name; final String hostname; final String username; final String password; final String commandOn; final String commandOff; final Terminal terminal;
  @override
  State<CustomToggleButton> createState() => _CustomToggleButtonState();
}

class _CustomToggleButtonState extends State<CustomToggleButton> {
  bool SSHLoaded = false; bool toggleState = false; late SSHClient client;
  @override
  void initState(){
    print(widget.commandOn);
    super.initState();
    initClient();
  }
  void dispose(){
    super.dispose();
    closeClient();
  }
  Future<void> initClient() async{
    client = SSHClient(
      await SSHSocket.connect(widget.hostname, 22),
      username: widget.username,
      onPasswordRequest: () => widget.password,
    );
    print("initClient username: ${client.username}");
    setState(() {SSHLoaded = true;});
  }
  Future<void> closeClient() async{
    final shell = await client.shell();
    await shell.done;
    client.close();

  }
  Future<void> sendCommand() async{
    if (toggleState == false){
      var command = await client.run(widget.commandOn);
      String commandString = utf8.decode(command);
      widget.terminal.write('${widget.commandOn}\r\n');
      toggleState =!toggleState;
    }
    else{
      var command = await client.run(widget.commandOff);
      widget.terminal.write('${widget.commandOff}\r\n');
      toggleState =!toggleState;
    }
    setState(() {HapticFeedback.vibrate();});
  }
  @override
  Widget build(BuildContext context) {
    if (SSHLoaded == true){
      return Padding(
        padding: EdgeInsets.all(buttonPadding),
        child: GestureDetector(
          onTap: (){
            sendCommand();
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.0),
              color: toggleState? Colors.grey[900] : const Color.fromARGB(44, 164, 167, 189),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      alignment: Alignment.topCenter,
                      child: IconButton(
                        icon: Icon(Icons.add, color: toggleState? Colors.white :Colors.green.shade700,),
                        onPressed: (){
                          sendCommand();

                        },
                      )
                  ),
                  Row(
                    children: [
                      Expanded(child: Padding(
                        padding: EdgeInsets.only(left: 25.0),
                        child: Text(widget.name,
                          style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold, color: toggleState? Colors.white :Colors.black,
                          ),),
                      ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),

      );
    }
    else{
    return LoadingSpaceWidget();
    }
  }
}

class CustomInputButton extends StatefulWidget {
  const CustomInputButton({super.key, required this.name, required this.hostname, required this.username, required this.password, required this.commandIn, required this.terminal});
  final String name; final String hostname; final String username; final String password; final String commandIn; final Terminal terminal;
  @override
  State<CustomInputButton> createState() => _CustomInputButtonState();
}

class _CustomInputButtonState extends State<CustomInputButton> {
  late final terminal = Terminal();
  bool SSHLoaded = false; bool toggleState = false; late SSHClient client;
  @override
  void initState(){
    print(widget.commandIn);
    super.initState();
    initClient();
  }
  void dispose(){
    super.dispose();
    closeClient();
  }
  Future<void> initClient() async{
    client = SSHClient(
      await SSHSocket.connect(widget.hostname, 22),
      username: widget.username,
      onPasswordRequest: () => widget.password,
    );
    print("initClient username: ${client.username}");
    setState(() {SSHLoaded = true;});
  }

  Future<void> closeClient() async{
    final shell = await client.shell();
    await shell.done;
    client.close();

  }
  Future<void> sendCommand() async{
    var command = await client.run(widget.commandIn);
  }
  @override
  Widget build(BuildContext context) {
    if (SSHLoaded == true){
      return StreamBuilder(
        stream: readInputStream(client, widget.commandIn),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot,){
            if(snapshot.hasData){
              return Padding(padding: const EdgeInsets.all(buttonPadding),
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(24.0), color: Colors.grey[900]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25.0),
                    child: Stack(
                      alignment: AlignmentDirectional.topCenter,
                      children:[
                        const SizedBox(height: 4),
                        Text(widget.name,style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 18),),
                        Center(child: Text(snapshot.data!, style: TextStyle(color: Colors.orange, fontSize: 18))),
                      ]

                    ),
                  ),
                )
              );
            }
            else{
              return LoadingSpaceWidget();
            }
          });
    }
    else{
      return LoadingSpaceWidget();
    }
  }
}

class DCMotorSingle extends StatefulWidget {
  const DCMotorSingle({super.key, required this.name, required this.id, required this.pin1, required this.pin2, required this.hostname, required this.username, required this.password});
  final String name; final int id; final String pin1; final String pin2;
  final String hostname; final String username; final String password;
  @override
  State<DCMotorSingle> createState() => _DCMotorSingleState();
}

class _DCMotorSingleState extends State<DCMotorSingle> {
  bool SSHLoadingFinished = false;
  int rotationDirection = 1; //0 means counterclockwise, 1 means stop, 2 means clockwise
  final List<bool> _DCState = <bool>[true, false];
  late SSHClient client;
  int index = 0;
  String direction = 'pause'; //either pause, forward or backward
  List<Widget> motorIcon = [Icon(Icons.pause_circle_filled, size: 60,), Icon(Icons.arrow_upward, size: 60), Icon(Icons.arrow_downward, size:60)];
  List<Color> motorColor = [const Color.fromARGB(44, 164, 167, 189),Colors.red,Colors.red];
  @override
  void initState(){
    super.initState();
    initClient();
  }
  @override
  void dispose(){
    closeClient();
    client.close();
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
  Future<void> motorRun(int state1, int state2) async{
    HapticFeedback.selectionClick();
    String command = DCMotorSingleRun(widget.pin1, widget.pin2, state1.toString(),state2.toString());
    var motorRun = await client.run(command);
  }
  @override
  Widget build(BuildContext context) {
    if(SSHLoadingFinished == true){
      print(index);
      return Padding(
        padding: const EdgeInsets.all(buttonPadding),
        child: GestureDetector(
          onVerticalDragStart: (dragDetail){
          },
          onVerticalDragUpdate: (dragDetail){
            if(dragDetail.primaryDelta!<0){
              //dragged up
              direction = 'up';
              setState(() {index = 1;});
            }
            else if(dragDetail.primaryDelta!>0){
              //dragged down
              direction = 'down';
              setState(() {index = 2;});
            }
          },
          onVerticalDragEnd: (dragDetail){
            if(direction == 'up'){
              motorRun(1,0);
              print(direction);
              setState(() {index = 1;});
            }
            if(direction =='down'){
              motorRun(0,1);
              print(direction);
            }

          },
          onTap: (){
            direction = 'pause';
            motorRun(0,0);
            print('tap');
            setState(() {index = 0;});
          },

          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              const SizedBox(height: 4),
              Text(widget.name,style: GoogleFonts.poppins(color: textcolor, fontWeight: FontWeight.w400, fontSize: 18),),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(24.0),
                  //color: Colors.grey[900],
                  color: motorColor[index],
                ),
                child: Center(child: motorIcon[index]),
              ),
            ],
          ),
        )
      );}
    else{
      return const LoadingSpaceWidget();
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
  String direction = 'pause';
  late SSHClient client;
  int index = 0;
  List<Widget> motorIcon = [Icon(Icons.pause_circle_filled, size: 60,), Icon(Icons.arrow_right, size: 60), Icon(Icons.arrow_left, size:60)];
  List<Color> motorColor = [const Color.fromARGB(44, 164, 167, 189),Colors.red,Colors.red];
  @override
  void initState(){
    super.initState();
    initClient();
  }
  @override
  void dispose(){
    closeClient();
    client.close();
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
  Future<void> motorRun(int stepperState) async{
    HapticFeedback.selectionClick();
    String command = stepperMotor(widget.pin1, widget.pin2, widget.pin3, widget.pin4, stepperState.toString());
    var motorRun = await client.run(command);
    print('stepper state is $stepperState');
  }
  @override
  Widget build(BuildContext context) {
    if(SSHLoadingFinished == true){
      return Padding(
        padding: const EdgeInsets.all(buttonPadding),
        child: GestureDetector(
            onHorizontalDragStart: (dragDetail){
            },
            onHorizontalDragUpdate: (dragDetail){
              if(dragDetail.primaryDelta!>0){
                //clockwise
                setState(() {index = 1;direction = 'down';});

              }
              else if(dragDetail.primaryDelta!<0){
                //counter-clockwise
                setState(() {index = 2;direction = 'up';});
              }
            },
            onHorizontalDragEnd: (dragDetail){
              if(direction == 'up'){
                motorRun(-1);
                print(direction);
              }
              if(direction =='down'){
                motorRun(1);
                print(direction);
              }
            },
            onTap: (){
              direction = 'pause';
              motorRun(0);
              setState(() {index = 0;});
              print(direction);
            },
            child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: <Widget>[

                  Column(
                    children: [
                      const SizedBox(height: 4),
                      Text(widget.name,style: GoogleFonts.poppins(color: textcolor, fontWeight: FontWeight.w400, fontSize: 18),),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(24.0),
                      //color: Colors.grey[900],
                      color: motorColor[index],
                    ),
                    child: Center(child: motorIcon[index]),
                  ),
                ]
            )
        ),
      );}
    else{
      return const LoadingSpaceWidget();
    }
  }
}
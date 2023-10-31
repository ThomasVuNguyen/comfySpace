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

const double buttonPadding = 8.0;

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

class SinglePressButton extends StatefulWidget {
  const SinglePressButton({super.key, required this.name, required this.hostname, required this.username, required this.password, required this.command, required this.terminal});
  final String name; final String hostname; final String username; final String password; final String command; final Terminal terminal;
  @override
  State<SinglePressButton> createState() => _SinglePressButtonState();
}

class _SinglePressButtonState extends State<SinglePressButton> {
  bool SSHLoaded = false; bool toggleState = false; late SSHClient client;
  @override
  void initState(){
    print(widget.command);
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
    HapticFeedback.vibrate();
      var command = await client.run(widget.command);
      String commandString = utf8.decode(command);
      widget.terminal.write('\r\n${widget.command}');
    setState(() {
      toggleState = !toggleState;
    });
      Future.delayed(Duration(milliseconds: 50), (){
        setState(() {
          toggleState = !toggleState;
        });
      });

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
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(24.0),
                  color: toggleState? Colors.white :Colors.black,
                ),
                child: Center(child: toggleState? Icon(Icons.toggle_on, size: 60,color: Colors.black,) :Icon(Icons.toggle_off, size: 60,color: Colors.white,),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('${widget.name} ',style: GoogleFonts.poppins( fontWeight: FontWeight.w400, fontSize: 18, color:!toggleState? Colors.white :Colors.black, )),
              ),
            ],

          ),
          /*Container(
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
          ),*/
        ),

      );
    }
    else{
    return LoadingSpaceWidget();
    }
  }
}






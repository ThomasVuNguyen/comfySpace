import 'dart:convert';

import 'package:comfyssh_flutter/comfyScript/statemanagement.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:xterm/core.dart';

import '../components/LoadingWidget.dart';
import '../components/custom_ui_components.dart';
import '../components/custom_widgets.dart';
import '../components/pop_up.dart';
import '../function.dart';
import '../main.dart';

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
    Future.delayed(Duration(milliseconds: 100), (){
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
                child: Center(child: toggleState? Icon(Icons.radio_button_checked, size: 60,color: Colors.black,) :Icon(Icons.radio_button_unchecked, size: 60,color: Colors.white,),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('${widget.name} ',style: GoogleFonts.poppins( fontWeight: FontWeight.w400, fontSize: 18, color:!toggleState? Colors.white :Colors.black, )),
              ),
            ],

          ),

        ),

      );
    }
    else{
      return LoadingSpaceWidget();
    }
  }
}

class AddComfyTapButton extends StatefulWidget {
  const AddComfyTapButton({super.key, required this.spaceName});
  final String spaceName;
  @override
  State<AddComfyTapButton> createState() => _AddComfyTapButtonState();
}

class _AddComfyTapButtonState extends State<AddComfyTapButton> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ButtonAdditionModel())
      ],
      child: ListTile(
          title: Text('Tap'),
          onTap: (){
            Scaffold.of(context).closeEndDrawer();
            late String pinOut; late String buttonName;
            showDialog(context: context, builder: (BuildContext context){
              String buttonType = 'customOutput';
              buttonSizeY = 1;
              buttonSizeX=1;
              buttonPosition=1;
              return ButtonAlertDialog(
                  title: 'Tap Button',
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        comfyTextField(onChanged: (btnName){
                          buttonName = btnName;
                        }, text: 'button name'),
                        const SizedBox(height: 32, width: double.infinity,),
                        comfyTextField(onChanged: (btnCommand){
                          buttonCommand = btnCommand;
                        }, text: 'command', keyboardType: TextInputType.multiline,),
                      ],
                    ),
                  ),
                  actions: [
                    comfyActionButton(
                      onPressed: (){
                        addButton('comfySpace.db', widget.spaceName, buttonName, buttonSizeX, buttonSizeY, buttonPosition, buttonCommand, 'ComfyTapButton');
                        Provider.of<ButtonAdditionModel>(context, listen: false).ChangeAdditionState();
                        Navigator.pop(context);
                      },
                    ),
                  ]);
            });
          }
      ),
    );
  }
}
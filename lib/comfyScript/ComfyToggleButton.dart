import 'package:comfyssh_flutter/main.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xterm/xterm.dart';

import '../components/LoadingWidget.dart';
import '../components/custom_widgets.dart';

List<String> CommandExtract(String command) {
  List<String> CommandList = command.split(ConnectionCharacter);
  return CommandList;
}

class ComfyToggleButton extends StatefulWidget {
  const ComfyToggleButton({super.key, required this.commandOn, required this.commandOff, required this.name, required this.hostname, required this.username, required this.password, required this.terminal});
  final String name;
  final String commandOn; final String commandOff;
  final String hostname; final String username; final String password;
  final Terminal terminal;
  @override
  State<ComfyToggleButton> createState() => _ComfyToggleButtonState();
}

class _ComfyToggleButtonState extends State<ComfyToggleButton> {
  bool toggleState=false; bool SSHLoadingFinished = false;
  late SSHClient client;
  @override
  void initState(){
    super.initState();
    initClient();
  }
  @override
  void dispose(){
    super.dispose();
    closeClient();
    print("closed");
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
      return GestureDetector(
        onTap: () async {
          setState((){
            toggleState = !toggleState;
            print(toggleState.toString());
          });
          if (toggleState == true){
            widget.terminal.write('\r\n${widget.commandOff} ');
            var command = await client.run(widget.commandOff);
          }
          else{
            widget.terminal.write('\r\n${widget.commandOn} ');
            var command = await client.run(widget.commandOn);
          }

          SystemSound.play(SystemSoundType.click);

        },
        child: Padding(
          padding: const EdgeInsets.all(buttonPadding),
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
        )
      );}
    else{
      return const LoadingSpaceWidget();
    }
  }
}
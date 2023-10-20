import 'package:comfyssh_flutter/main.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            widget.terminal.write('${widget.commandOff} \r\n');
            var command = await client.run(widget.commandOff);
          }
          else{
            widget.terminal.write('${widget.commandOn} \r\n');
            var command = await client.run(widget.commandOn);
          }
          //HapticFeedback.vibrate();

          SystemSound.play(SystemSoundType.click);

        },
        child: Padding(
          padding: const EdgeInsets.all(buttonPadding),
          child: Container(
            color: toggleState? Colors.white :Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(buttonPadding),
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
                    color: toggleState? Colors.white: Colors.black,
                  ),
                  Expanded(
                    child: Container(
                        width: double.infinity,
                        color: toggleState? Colors.black: Colors.white,
                        child: Icon(toggleState? Icons.catching_pokemon :Icons.account_tree, color: toggleState? Colors.white :Colors.grey.shade700,)),
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
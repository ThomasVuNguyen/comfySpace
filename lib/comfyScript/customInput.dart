import 'dart:convert';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xterm/core.dart';

import '../components/LoadingWidget.dart';
import '../components/custom_widgets.dart';

Future<String> readInput(SSHClient client, String command) async {
  await Future.delayed(const Duration(seconds: 1));
  final distance = await client.run(command);
  return utf8.decode(distance);
}

Stream<String> readInputStream(SSHClient client, String command) async* {
  while(true){
    await Future<void>.delayed(Duration(milliseconds: 400));
    final distance = await client.run(command);
    yield utf8.decode(distance);
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
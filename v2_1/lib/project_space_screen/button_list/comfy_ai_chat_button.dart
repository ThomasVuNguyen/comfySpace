import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';

import '../../home_screen/comfy_user_information_function/project_information.dart';
import 'comfy_swipe_button.dart';

class comfy_ai_chat_button extends StatefulWidget {
  const comfy_ai_chat_button({super.key, required this.button,
    required this.hostname, required this.staticIP, required this.username, required this.password,
  });
  final comfy_button button; final String hostname; final String username; final String password; final String staticIP;
  @override
  State<comfy_ai_chat_button> createState() => _comfy_ai_chat_buttonState();
}

class _comfy_ai_chat_buttonState extends State<comfy_ai_chat_button> {
  late SSHClient sshClient;
  @override
  void initState(){
    initClient();
    print('hi swipe');
    super.initState();
  }

  @override
  void dispose(){
    try{
      sshClient.close();
    } catch (e){

    }

    super.dispose();
  }

  @override
  void deactivate(){
    try{
      sshClient.close();
    } catch (e){

    }
    super.deactivate();
  }
  Future<void> initClient() async{
    for(String potentialHostName in [widget.staticIP.trim(), widget.hostname]){
      try{
        sshClient = SSHClient(
          await SSHSocket.connect(potentialHostName, 22),
          username: widget.username,
          onPasswordRequest: () => widget.password,
        );
        //attempt a connection
        await sshClient.execute('echo hi');
        print('ssh connection successfully created with hostname $potentialHostName');
        break;

      }
      catch (e){
        //if all hostname tested and not working, report!
        if(potentialHostName == widget.hostname){
          //SSH connection not made
          //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error connecting to $potentialHostName: $e}')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text('ai'),),
    );
  }
}

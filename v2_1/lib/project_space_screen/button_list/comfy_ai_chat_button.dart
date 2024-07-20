import 'dart:convert';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../home_screen/comfy_user_information_function/project_information.dart';


class comfy_ai_chat_button extends StatefulWidget {
  const comfy_ai_chat_button({super.key, required this.button,
    required this.hostname, required this.staticIP, required this.username, required this.password,
    required this.voiceInstance
  });
  final comfy_button button; final String hostname; final String username; final String password; final String staticIP;
  final SpeechToText voiceInstance;
  @override
  State<comfy_ai_chat_button> createState() => _comfy_ai_chat_buttonState();
}

class _comfy_ai_chat_buttonState extends State<comfy_ai_chat_button> {
  late SSHClient sshClient;
  bool _status = false;

  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState(){

    //initTTS();
    initClient();
    //initSpeech();
    print('hi swipe');
    super.initState();
  }
  @override
  void dispose(){
    try{
      sshClient.close();
    } catch (e){
    }
    _stopListening();
    super.dispose();
  }
  @override
  void deactivate(){
    try{
      sshClient.close();
    } catch (e){

    }
    _stopListening();
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



  Future<void> _startListening() async {
    print('listening');
    await widget.voiceInstance.listen(onResult: _onSpeechResult);
    setState(() {});
  }
  Future<void> _stopListening() async {
    print('stopping');
    await widget.voiceInstance.stop();
    setState(() {});

  }
  Future<void> _onSpeechResult(SpeechRecognitionResult result) async {
    print(result.recognizedWords);
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  Future<String> askAI(String query) async{
    print('asking gemini $query');
    var response = await sshClient.run('comfy gemini_run $query');
    var answer =  utf8.decode(response);
    print('gemini response: $answer');
    _status != _status;
    return answer;

  }

  Future<void> AIPromptInterface() async{
    print('prompting AI interface');
    showDialog(context: context, builder: (context){
      return AlertDialog(
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async{
          widget.voiceInstance.isNotListening?
          _startListening() : _stopListening();
        },

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              color: widget.voiceInstance.isNotListening? Colors.red: Colors.green,
              ),
        )
    );

  }
}




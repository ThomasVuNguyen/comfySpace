import 'dart:convert';
import 'dart:io';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../home_screen/comfy_user_information_function/project_information.dart';


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
  bool _status = false;

  var flutterTts = FlutterTts();

  @override
  void initState(){
    initTTS();
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
    flutterTts.stop();
    super.dispose();
  }
  @override
  void deactivate(){
    try{
      sshClient.close();
    } catch (e){

    }
    flutterTts.stop();
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

  Future<String> askAI(String query) async{
    print('asking gemini $query');
    var response = await sshClient.run('comfy gemini_run ' + '"' + query + '"');
    var answer =  utf8.decode(response);
    print('gemini response: $answer');
    _status != _status;
    print('speaking');
    try{
      await flutterTts.speak(answer);
    } catch (e){
      print('error speaking $e');
    }
    return answer;

  }
  Future<void> AIPromptInterface() async{
    print('prompting AI interface');
    showDialog(context: context, builder: (context){
      return AlertDialog(
      );
    });
  }

  Future<void> Speech2Text() async{
    SpeechToText speech = SpeechToText();

    bool available = await speech.initialize(

      options: [
        SpeechToText.webDoNotAggregate,
      ]
        ,
      debugLogging: true,
        onError: (error){
      print('error: $error');
    });
    if ( available ) {
      speech.listen(
        pauseFor: Duration(milliseconds: 500),
        //partialResults: false,
        listenOptions: SpeechListenOptions(
          partialResults: true,
          enableHapticFeedback: true
        ),
          onResult: (result){
        print(result.recognizedWords);
        if(Platform.isIOS){
          speech.stop();
        }

          if(Platform.isAndroid && speech.lastStatus == 'notListening'){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.recognizedWords)));
            speech.stop();
            askAI(result.recognizedWords);
          }
          if(Platform.isIOS && speech.lastStatus == 'listening' ){
            print('status ${speech.lastStatus}');
            speech.stop();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.recognizedWords)));
            askAI(result.recognizedWords);
          }


      });
    }
    else {
      print("The user has denied the use of speech recognition.");
    }

  }

  Future<void> initTTS() async{


    if(Platform.isIOS){
      await flutterTts.setSharedInstance(true);
      await flutterTts.setIosAudioCategory(IosTextToSpeechAudioCategory.ambient,
          [
            IosTextToSpeechAudioCategoryOptions.allowBluetooth,
            IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
            IosTextToSpeechAudioCategoryOptions.mixWithOthers
          ],
          IosTextToSpeechAudioMode.voicePrompt
      );
    }
    print('speaking, spaceman');
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak("hello, spaceman");
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Speech2Text();
        },
        onDoubleTap: (){
          flutterTts.stop();
        },


        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              color: Colors.green
              ),
        )
    );

  }
}




import 'dart:convert';
import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../home_screen/comfy_user_information_function/project_information.dart';
import 'comfy_swipe_button.dart';
import 'package:flutter_tts/flutter_tts.dart';


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

  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState(){
    _speechToText = widget.voiceInstance;
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

  Future<void> initTTS() async{
    FlutterTts flutterTts = FlutterTts();
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
  }

  Future<void> initSpeech() async{
    _speechEnabled = await _speechToText.initialize(
      onStatus: (status){
        print('speech init status $status');
      },
      onError: (error){
        print('error: ${error.errorMsg}');
      }
    );
    print(_speechEnabled);
    print('speech initialized');
}
  Future<void> _startListening() async {
    print('listening');
    try{
      await _speechToText.listen(onResult: _onSpeechResult);
    } catch (e){
      print(e.toString());
    }


  }
  Future<void> _stopListening() async {
    await _speechToText.stop();

  }
  Future<void> _onSpeechResult(SpeechRecognitionResult result) async {
    print('recognized word: ${result.recognizedWords}');
    String response = await askAI(result.recognizedWords);
  }

  Future<String> askAI(String query) async{
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
          _speechToText.isNotListening?
          _startListening()
              : _stopListening();
        },

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              color: _speechToText.isNotListening ? Colors.red: Colors.green,
              ),
        )
    );

  }
}

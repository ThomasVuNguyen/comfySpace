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
    super.initState();
  }
  @override
  void dispose(){
    try{
      sshClient.close();
    } catch (e){
    }
    print('disposing tts');
    //flutterTts.stop();
    super.dispose();
  }
  @override
  void deactivate(){
    try{
      sshClient.close();
    } catch (e){

    }
    print('disposing tts');
    //flutterTts.stop();
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
    await flutterTts.speak(answer);
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
    String _lastWords = '';

    bool available = await speech.initialize(
        debugLogging: true,
        onStatus: (status){
          print('status: $status');
        },
        onError: (error){
      print('error: $error');
    });
    print('speech initialized $available');
    if ( available ) {
      print('voice available');
      speech.listen(
          onResult: (result){
            print(result.recognizedWords);
            print(speech.lastStatus);

        if(Platform.isIOS == true){
          print('ios device found');
          speech.stop();
        }
        print('is android ${Platform.isAndroid}');
        print('status ${speech.lastStatus}');
        if (Platform.isAndroid == true && speech.lastStatus == 'notListening'){
          print('android found and done');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.recognizedWords)));
          askAI(result.recognizedWords);}

        else if(Platform.isIOS == true && speech.lastStatus == 'listening'){
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
    // some time later...
    //speech.stop();

  }

  Future<void> initTTS() async{
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);

    if(Platform.isIOS == true){
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
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.awaitSynthCompletion(true);
    /*
    print('speaking, man');
    await flutterTts.speak("hello, spaceman");
    */

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


        child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: widget.button.color!
                            //Theme.of(context).colorScheme.onBackground
                            , width: 2)
                    ),

                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25, bottom: 45),
                    child: Image.asset('assets/gemini/gemini-logo.webp',),
                  )
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    widget.button.name!,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ],
            )
        )
    );
  }
}



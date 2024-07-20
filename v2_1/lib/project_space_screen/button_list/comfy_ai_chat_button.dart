import 'dart:convert';
import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';

import '../../home_screen/comfy_user_information_function/project_information.dart';
import 'comfy_swipe_button.dart';
import 'package:flutter_tts/flutter_tts.dart';


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
  @override
  void initState(){
    initTTS();
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
  Future<void> askAI(String query) async{
    var response = await sshClient.run('comfy gemini_run $query');
    var answer =  utf8.decode(response);
    print('gemini response: $answer');
    _status != _status;
    //return answer;
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
          await AIPromptInterface();
          setState(
                  () {
                _status = !_status;
              }
          );
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
                        color: const Color(0xFFDAEED7),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: widget.button.color!
                            //Theme.of(context).colorScheme.onBackground
                            , width: 2)
                    ),

                  ),
                ),
                Container(
                  child: Builder(
                      builder: (context){
                        if(_status==true) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 25, right: 25, bottom: 45),
                            child: Image.asset('assets/froggie/tap-on.png',),
                          );
                        }
                        else{
                          return Padding(
                            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 45, top: 20),
                            child: Image.asset('assets/froggie/tap-off.png', fit: BoxFit.fill,),
                          );
                        }}
                  ),
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
    return GestureDetector(
        onTap:()  async{

          //Show listening popup
          //Parse in prompt
          //Receive Respond
          //Speaking
        print('tapping');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('tapped')));
        await askAI('who is donald trump?');
      },
      child: Container(
        child: Center(child: Text('ai ${widget.button.name}'),),
      ),
    );
  }
}

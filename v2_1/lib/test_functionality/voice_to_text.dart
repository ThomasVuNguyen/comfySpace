import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceScreenTest extends StatelessWidget {
  const VoiceScreenTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(

        onPressed: () async{
          SpeechToText speech = SpeechToText();
        bool available = await speech.initialize( onStatus: (status){
          print('status: $status');
        }, onError: (error){
          print('error: $error');
        });
        if ( available ) {
          speech.listen( onResult: (result){
            print(result.recognizedWords);
          });
        }
        else {
          print("The user has denied the use of speech recognition.");
        }
        // some time later...
        //speech.stop();
    },

      ),
    );
  }
}

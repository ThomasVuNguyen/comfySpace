import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TTSTestScreen extends StatefulWidget {
  const TTSTestScreen({super.key});

  @override
  State<TTSTestScreen> createState() => _TTSTestScreenState();
}

class _TTSTestScreenState extends State<TTSTestScreen> {
  var flutterTts = FlutterTts();
  @override
  void initState() {
    initTTS();
    // TODO: implement initState
    super.initState();
  }

  Future<void> initTTS() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);

    //await flutterTts.awaitSpeakCompletion(true);
    //await flutterTts.awaitSynthCompletion(true);

    print('speaking, spaceman');
    await flutterTts.speak("hello, spaceman");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: TextButton(
          child: const Text('hu'),
          onPressed: () async {
            await flutterTts.speak('hi');
            print('spoken');
          },
        ),
      ),
    );
  }
}

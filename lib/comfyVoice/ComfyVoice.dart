import 'package:comfyssh_flutter/comfyScript/ComfyToggleButton.dart';
import 'package:comfyssh_flutter/comfyScript/statemanagement.dart';
import 'package:comfyssh_flutter/components/pop_up.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_to_text.dart';
import 'package:xterm/xterm.dart';

import '../function.dart';
import 'ComfyVoiceDB.dart';

class ComfyVoice extends StatefulWidget {
  const ComfyVoice({super.key, required this.spaceName,
    required this.hostname, required this.username, required this.password,
 required this.terminal
  });
  final String spaceName;
  final String hostname; final String username; final String password;
  final Terminal terminal;
  @override
  State<ComfyVoice> createState() => _ComfyVoiceState();
}

class _ComfyVoiceState extends State<ComfyVoice> {
  late Map<String, String> Command;
  bool SSHLoaded = false;
  late SSHClient client;
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState(){
    super.initState();
    initClient();
    ExtractVoiceCommand();
    _initSpeech();
  }
  @override
  void dispose(){
    super.dispose();
    closeClient();
    _stopListening();
    print("closed");
  }
  Future<void> ExtractVoiceCommand() async{
    Command = await  VoiceCommandExtracted('comfySpace.db', widget.spaceName);
  }
  Future<void> initClient() async{
    client = SSHClient(
      await SSHSocket.connect('10.0.0.85', 22),
      username: 'tung',
      onPasswordRequest: () => 'tung',
    );

  }
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }
  Future<void> _startListening() async {
    print('listening');
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }
  Future<void> closeClient() async{
    final shell = await client.shell();
    await shell.done;
    client.close();
  }
  Future<void> _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }
  Future<void> _onSpeechResult(SpeechRecognitionResult result) async {
    print(result.recognizedWords);
    if(Command[result.recognizedWords] == null){
      widget.terminal.write('${result.recognizedWords} not found');
    }
    else{
      await client.run(Command[result.recognizedWords]!);
    }
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SpaceEdit())
      ],
      child: FloatingActionButton(onPressed: (){
        _speechToText.isNotListening?
        _startListening()
            : _stopListening();
      },
          child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),),
    );
  }
}


class AddComfyVoiceButton extends StatefulWidget {
  const AddComfyVoiceButton({super.key, required this.spaceName});
  final String spaceName;
  @override
  State<AddComfyVoiceButton> createState() => _AddComfyVoiceButtonState();
}

class _AddComfyVoiceButtonState extends State<AddComfyVoiceButton> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text('Voice', style: Theme.of(context).textTheme.titleMedium,),
        onTap: () {
          //var VoiceTable = await VoiceCommandExtracted('comfySpace.db', widget.spaceName);
          //var VoiceTable = await CheckVoiceTable('comfySpace.db');
          //print(VoiceTable);
          Scaffold.of(context).closeEndDrawer();
          showDialog(context: context, builder: (BuildContext context){
            String buttonCommand = '';
            String buttonPrompt = '';
            return ButtonAlertDialog(
                title: 'Voice',
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FutureBuilder(
                          future: VoiceCommandExtractedList('comfySpace.db', widget.spaceName),
                          builder: (context, snapshot){
                            if(snapshot.connectionState == ConnectionState.done){
                              return SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Container(
                                    height: 100,
                                    width: double.infinity,
                                    child: ListView.builder(
                                        padding: EdgeInsets.all(8.0),
                                        itemCount: snapshot.data?.length,
                                        itemBuilder: (context, index){
                                          return Row(
                                            children: [
                                              Text(snapshot.data?[index]['prompt']),
                                              Text(snapshot.data?[index]['command']),
                                            ],
                                          );
                                        }),
                                  ),
                                ),
                              );


                            }
                            else{
                              return Text('loading');
                            }

                          }),
                      comfyTextField(onChanged: (prompt){
                        buttonPrompt =prompt;
                      }, text: 'prompt'),
                      const SizedBox(height: 32, width: double.infinity,),
                      comfyTextField(onChanged: (btnCommand){
                        buttonCommand = btnCommand;
                      }, text: 'command', keyboardType: TextInputType.multiline,),
                    ],
                  ),
                ),
                actions: [
                  comfyActionButton(
                    onPressed: () async {
                      await addVoicePrompt('comfySpace.db', widget.spaceName, buttonPrompt, buttonCommand, context);
                      Provider.of<SpaceEdit>(context, listen: false).ChangeSpaceEditState();
                      Navigator.pop(context);

                    },
                  ),
                ]);
          });
        }
    );
  }
}
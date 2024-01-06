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

class ComfyVoice extends StatefulWidget {
  const ComfyVoice({super.key,
    required this.name,
    required this.hostname, required this.username, required this.password,
    required this.command, required this.terminal
  });
  final String name; final String hostname; final String username; final String password;
  final String command; final Terminal terminal;
  @override
  State<ComfyVoice> createState() => _ComfyVoiceState();
}

class _ComfyVoiceState extends State<ComfyVoice> {
  bool SSHLoaded = false;
  late SSHClient client;
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  late Map<String, String> VoiceCommand;
  @override
  void initState(){
    super.initState();
    VoiceCommand = ExtractVoiceCommand(widget.command);
    initClient();
    _initSpeech();
  }
  @override
  void dispose(){
    super.dispose();
    closeClient();
    _stopListening();
    print("closed");
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
    if(VoiceCommand[result.recognizedWords] == null){
      widget.terminal.write('${result.recognizedWords} not found');
    }
    else{
      await client.run(VoiceCommand[result.recognizedWords]!);
    }
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Text(_speechToText.isListening? '$_lastWords': _speechEnabled? 'Tap to start': 'no speech'),
        IconButton(onPressed: (){
          _speechToText.isNotListening?
          _startListening()
              : _stopListening();
        },
            icon: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),),
      ],
    );
  }
}

Map<String, String> ExtractVoiceCommand(String CommandInfo){
  List<String> CommandList = CommandExtract(CommandInfo);
  List<String> CommandListFiltered = List.from(CommandList.where((element) => element !=''));
  Map<String, String> VoiceCommand = {};
  for (int i = 0; i<CommandListFiltered.length; i=i+2){
    VoiceCommand[CommandListFiltered[i]] = CommandListFiltered[i+1];
  }
  return VoiceCommand;
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SpaceEdit())
      ],
      child: ListTile(
          title: Text('Voice', style: Theme.of(context).textTheme.titleMedium,),
          onTap: (){
            Scaffold.of(context).closeEndDrawer();
            showDialog(context: context, builder: (BuildContext context){
              String buttonCommand = '';
              String buttonPrompt = '';
              return ButtonAlertDialog(
                  title: 'Tap Button',
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                      onPressed: (){
                        addVoiceButton('comfySpace.db', widget.spaceName, 1, 1, 1, buttonCommand, 'ComfyVoice');
                        //Provider.of<SpaceEdit>(context, listen: false).ChangeSpaceEditState();
                        //Navigator.pop(context);
                      },
                    ),
                  ]);
            });
          }
      ),
    );
  }
}
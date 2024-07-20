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
    /*if (Theme.of(context).platform!= TargetPlatform.windows && Theme.of(context).platform!=TerminalTargetPlatform.macos && Theme.of(context).platform!= TargetPlatform.linux){
      ExtractVoiceCommand();
      _initSpeech();
    }*/
    ExtractVoiceCommand();
    _initSpeech();

  }
  @override
  void dispose(){
    super.dispose();
    /*if (Theme.of(context).platform!= TargetPlatform.windows && Theme.of(context).platform!=TerminalTargetPlatform.macos && Theme.of(context).platform!= TargetPlatform.linux){
      closeClient();
      _stopListening();
    }*/
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
    if (Theme.of(context).platform!= TargetPlatform.windows && Theme.of(context).platform!=TerminalTargetPlatform.macos && Theme.of(context).platform!= TargetPlatform.linux){
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
    else{
      return Container(
        height: 0, width: 0,
      );
    }

  }
}
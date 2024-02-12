import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';

class ComfyInitializer extends StatefulWidget {
  const ComfyInitializer({super.key,
    required this.hostname, required this.username, required this.password});
  final String hostname; final String username; final String password;

  @override
  State<ComfyInitializer> createState() => _ComfyInitializerState();
}

class _ComfyInitializerState extends State<ComfyInitializer> {
  late SSHClient client;
  @override
  void initState(){
    super.initState();
    initClient();
  }
  Future<void> initClient() async{
    client = SSHClient(
        await SSHSocket.connect(widget.hostname, 22),
        username: widget.username,
        onPasswordRequest: () => widget.password
    );
    client.run('comfy camera stream');
    client.run('sudo raspi-config nonint do_legacy 0');
  }
  @override
  Widget build(BuildContext context) {
    return Container(width: 0, height: 0,);
  }
}

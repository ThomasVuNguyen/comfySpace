import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';

class ComfyCameraStream extends StatefulWidget {
  const ComfyCameraStream({super.key,
    required this.hostname, required this.username, required this.password});
  final String hostname; final String username; final String password;

  @override
  State<ComfyCameraStream> createState() => _ComfyCameraStreamState();
}

class _ComfyCameraStreamState extends State<ComfyCameraStream> {
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
  }
  @override
  Widget build(BuildContext context) {
    return Container(width: 0, height: 0,);
  }
}

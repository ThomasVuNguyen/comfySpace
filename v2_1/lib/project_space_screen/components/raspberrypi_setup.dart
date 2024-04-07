import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';

class IntitialSetup extends StatefulWidget {
  const IntitialSetup({
    super.key,
    required this.hostname, required this.staticIP, required this.username, required this.password,
  });
  final String hostname; final String username; final String password; final String staticIP;
  @override
  State<IntitialSetup> createState() => _IntitialSetupState();
}

class _IntitialSetupState extends State<IntitialSetup> {
  late SSHClient _sshClient;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> _initialSetup() async{
    _sshClient = SSHClient(
      await SSHSocket.connect('localhost', 22),
      username: '<username>',
      onPasswordRequest: () => '<password>',
    );
  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

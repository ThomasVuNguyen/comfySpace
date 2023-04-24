import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';
import 'package:flutter/cupertino.dart';
import 'package:xterm/xterm.dart';

const host = '10.0.0.167';
const port = 22;
const username = 'tung';
const password = 'tung';

void main() {
  runApp(MyApp());
}  //main function, execute MyApp

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'xterm.dart demo',
      home: Welcome(),
    );
  }
}  //MyApp, wraps the main home page

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);
  @override
  _WelcomePage createState() => _WelcomePage();
}

class Term extends StatefulWidget {
  const Term({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _TerminalPage createState() => _TerminalPage();
} //MyHomePage

class _WelcomePage extends State<Welcome>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body:Container(
        child: TextFormField(

        ),
      )
    );
  }

}

class _TerminalPage extends State<Term> {
  late final terminal = Terminal(inputHandler: defaultInputHandler);
  var title = host;
  @override
  void initState() {
    super.initState();
    initTerminal();
  }

  Future<void> initTerminal() async {
    terminal.write('Connecting...\r\n');

    final client = SSHClient(
      await SSHSocket.connect(host, port),
      username: username,
      onPasswordRequest: () => password,
    );

    terminal.write('Connected\r\n');

    final session = await client.shell(
      pty: SSHPtyConfig(
        width: terminal.viewWidth,
        height: terminal.viewHeight,
      ),
    );

    terminal.buffer.clear();
    terminal.buffer.setCursor(0, 0);

    terminal.onTitleChange = (title) {
      setState(() => this.title = title);
    };

    terminal.onResize = (width, height, pixelWidth, pixelHeight) {
      session.resizeTerminal(width, height, pixelWidth, pixelHeight);
    };

    terminal.onOutput = (data) {
      session.write(utf8.encode(data) as Uint8List);
    };

    session.stdout
        .cast<List<int>>()
        .transform(Utf8Decoder())
        .listen(terminal.write);

    session.stderr
        .cast<List<int>>()
        .transform(Utf8Decoder())
        .listen(terminal.write);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: Text(title),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: TerminalView(terminal),
            ),
          ],
        ),
      )
    );
  }
}  //TerminalState
import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';
import 'package:flutter/cupertino.dart';
import 'package:xterm/xterm.dart';

String? hostname;
int port = 22;
String? username;
String? password;
const bgcolor = Color(0x001f1f1f);

void main() {
  runApp(MyApp());
}  //main function, execute MyApp

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'xterm.dart demo',
      debugShowCheckedModeBanner: false,
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
  /*String? value1;
  String? hostname;
  int port = 22;
  String? username;
  String? password;
  Color bgcolor = Color(0x001f1f1f);*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        title: const Text("Welcome, Thomas"),
        backgroundColor: bgcolor,
        leading: const Icon(
          Icons.menu,
        ),
        actionsIconTheme: const IconThemeData(
          size: 30.0,
          color: Colors.white,
          opacity: 10.0
        ),
        actions: <Widget>[
          Padding(padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap:(){},
              child: const Icon(
                Icons.add,
                size: 26.0,
              )
            ),
          )
        ]
      ),
      body: Column(
        children: <Widget> [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListTile(
              leading: const Icon(
                Icons.star,
              ),
              title: const Text("Ubuntu 20.04"),
              subtitle: const Text("@ 192.168.0.127"),
              //onTap: () => ,
              //onLongPress: () => ,
              trailing: InkWell(
                child: const Icon(
                Icons.settings,
              ),
                onTap: (){
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Insert information"),
                          content: Column(
                            children: [
                              TextField( //hostname input
                                onChanged: (host1){
                                hostname =host1;
                                print("hostname is " + hostname!);},
                                decoration: const InputDecoration(
                                  hintText: "hostname",
                                ),
                              ),
                              TextField(
                                  onChanged: (user1){
                                    username = user1;
                                    print("username is "+username!);},
                                decoration: const InputDecoration(
                                  hintText: "username",
                                ),
                              ),
                              TextField(
                                  onChanged: (pw1){
                                    password = pw1;
                                    print(password);},
                                decoration: const InputDecoration(
                                  hintText: "password, promise won't leak :)"
                                ),
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            MaterialButton(
                              color: Colors.green,
                                textColor: Colors.white,
                                child: const Text("Connect"),

                                onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  const Term()),
                              );
                            })
                          ],
                        );
                      }
                  );
                },
              ),
              tileColor: Colors.orange,
              visualDensity: VisualDensity(vertical: 3.3),

            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: ListTile(
              leading: Icon(
                Icons.star,
              ),
              title: Text("Raspbian 64-bit"),
              subtitle: Text("@ 192.168.0.135"),
              //onTap: () => ,
              //onLongPress: () => ,
              trailing: Icon(
                Icons.settings,
              ),
              tileColor: Colors.green,
              visualDensity: VisualDensity(vertical: 3.3),
            ),
          ),
        ],

      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white,
        backgroundColor: bgcolor,
        items:  const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'calls',),
          BottomNavigationBarItem(icon: Icon(Icons.camera), label: 'camera',),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'chat',),
        ],
      ),
    );
  }
}
class _TerminalPage extends State<Term> {
  late final terminal = Terminal(inputHandler: defaultInputHandler);

  var title = hostname! + username! + password!;
  @override
  void initState() {
    super.initState();
    initTerminal();
  }
  Future<void> initTerminal() async {
    terminal.write('Connecting...\r\n');

    final client = SSHClient(
      await SSHSocket.connect(hostname!, port),
      username: username!,
      onPasswordRequest: () => password!,
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
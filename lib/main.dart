import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';
import 'package:flutter/cupertino.dart';
import 'package:xterm/xterm.dart';
import 'package:shared_preferences/shared_preferences.dart';
String? nickname;
String? hostname;
int port = 22;
String? username;
String? password;
String? color;
const bgcolor = Colors.grey;
List<String> nameList = [];
List<String> hostList = [];
List<String> userList = [];
List<String> passList = [];
List<String> colorList = [];

void main() {
  reAssign();
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        title: Text(nameList!.toString()),
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
              onTap:(){
                showDialog(context: context, builder:(BuildContext context){
                  return AlertDialog(
                    title: const Text("Add a new host"),
                    content: Column(
                      children: [
                        TextField( //add nickname
                          onChanged: (name1){
                            nickname = name1;
                            },
                          decoration: const InputDecoration(
                            hintText: "nickname",
                          ),textInputAction: TextInputAction.next,
                        ),
                        TextField( //add hostname
                          onChanged: (host1){
                            hostname = host1;
                            ;},
                          decoration: const InputDecoration(
                            hintText: "hostname",
                          ),textInputAction: TextInputAction.next,
                        ),
                        TextField( //add username
                          onChanged: (user1){
                            username = user1;
                            },
                          decoration: const InputDecoration(
                            hintText: "username",
                          ),textInputAction: TextInputAction.next,
                        ),
                        TextField( //add password
                          onChanged: (pass1){
                            password = pass1;
                            },
                          decoration: const InputDecoration(
                            hintText: "password",
                          ),textInputAction: TextInputAction.next,
                        ),
                        TextField( //add color
                          onChanged: (color1){
                            color = color1;},
                          decoration: const InputDecoration(
                            hintText: "color",
                          ),textInputAction: TextInputAction.next,
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      MaterialButton(
                          color: Colors.green,
                          textColor: Colors.white,
                          child: const Text("Save"),
                          onPressed: (){
                            newName(nickname!);
                            newHost(hostname!);
                            newUser(username!);
                            newPass(password!);
                            newColor(color!);
                            setState(() {
                            });
                            Navigator.pop(context);
                          }
                      )
                    ],
                  );
                });

              },
              child: const Icon(
                Icons.add,
                size: 26.0,
              )
            ),
          ),
        Padding(padding: const EdgeInsets.only(right:20),
              child: GestureDetector(
                  onTap:(){ //clear all data
                    clearData();
                    setState(() {
                    });
                  },
                  child: const Icon(
                    Icons.accessibility,
                    size: 26.0,
                  )
              )),
          Padding(padding: const EdgeInsets.only(right:20),
              child: GestureDetector(
                  onTap:(){ //clear all data
                    setState(() {
                    });
                  },
                  child: const Icon(
                    Icons.dangerous,
                    size: 26.0,
                  )
              ))
        ]
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: List.generate(nameList.length, (index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
              title: Text("name is ${nameList[index]}"),
            subtitle: Text("host ${hostList[index]}"),
            tileColor: Colors.red,
          ),
        )),
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

newName(String name) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> oldNameList = prefs.getStringList("listName")!;
  oldNameList.add(name);
  prefs.setStringList("listName", oldNameList);
  nameList = prefs.getStringList("listName")!;
  //print("new name"); print(nameList!);
}

newHost(String name) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> oldHostList = prefs.getStringList("listHost")!;
  oldHostList.add(name);
  prefs.setStringList("listHost", oldHostList);
  hostList = prefs.getStringList("listHost")!;
  //print("new host"); print(hostList!);
}

newUser(String name) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> oldUserList = prefs.getStringList("listUser")!;
  oldUserList.add(name);
  prefs.setStringList("listUser", oldUserList);
  userList = prefs.getStringList("listUser")!;
  //print("new user"); print(userList!);
}

newPass(String name) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> oldPassList = prefs.getStringList("listPass")!;
  oldPassList.add(name);
  prefs.setStringList("listPass", oldPassList);
  passList = prefs.getStringList("listPass")!;
  //print("new pass"); print(passList!);
}

newColor(String name) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> oldColorList = prefs.getStringList("listColor")!;
  oldColorList.add(name);
  prefs.setStringList("listColor", oldColorList);
  colorList = prefs.getStringList("listColor")!;
  //print("new color"); print(colorList!);
}

clearData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList("listName", <String>[]);
  prefs.setStringList("listHost", <String>[]);
  prefs.setStringList("listUser", <String>[]);
  prefs.setStringList("listPass", <String>[]);
  prefs.setStringList("listColor", <String>[]);
  nameList = <String>[];hostList = <String>[];userList = <String>[];passList = <String>[];colorList = <String>[];
}
reAssign() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //prefs.reload();
  nameList = prefs.getStringList("listName")!;
  hostList = prefs.getStringList("listHost")!;
  userList = prefs.getStringList("listUser")!;
  passList = prefs.getStringList("listPass")!;
  colorList = prefs.getStringList("listColor")!;
}
resetData() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList("listName", nameList);
  prefs.setStringList("listHost", hostList);
  prefs.setStringList("listPass", passList);
  prefs.setStringList("listColor", colorList);
}
/*
Navigator.push(
context,
MaterialPageRoute(builder: (context) =>  const Term()),
);
*/

/*setState()*/
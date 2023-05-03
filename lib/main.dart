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
const bgcolor = Color(0x001f1f1f);
List<String> nameList = ["name1"];
List<String> hostList = ["host1"];
List<String> userList = [];
List<String> passList = [];
List<String> colorList = [];
var name = "ok";

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
                          ),
                        ),
                        TextField( //add hostname
                          onChanged: (host1){
                            hostname = host1;
                            ;},
                          decoration: const InputDecoration(
                            hintText: "hostname",
                          ),
                        ),
                        TextField( //add username
                          onChanged: (user1){
                            username = user1;
                            },
                          decoration: const InputDecoration(
                            hintText: "username",
                          ),
                        ),
                        TextField( //add password
                          onChanged: (pass1){
                            password = pass1;
                            },
                          decoration: const InputDecoration(
                            hintText: "password",
                          ),
                        ),
                        TextField( //add color
                          onChanged: (color1){
                            color = color1;},
                          decoration: const InputDecoration(
                            hintText: "color",
                          ),
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
          },
          child: const Icon(
            Icons.accessibility,
            size: 26.0,
          )
        ))
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
                  title: Text("hi"),
              subtitle: const Text("@ 192.168.0.127"),
              //onTap: () => ,
              //onLongPress: () => ,
              trailing: InkWell(
                child: const Icon(
                Icons.settings,
              ),
                onTap: (){
                  newName("tung");
                  setState(() {
                  }); //force all widget rebuild
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
                                child: const Text("Save"),
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

newName(String name) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList("listName", nameList);
  List<String> oldNameList = prefs.getStringList("listName")!;
  oldNameList.add(name);
  prefs.setStringList("listName", oldNameList);
  nameList = prefs.getStringList("listName")!;
  print("new name"); print(nameList!);
}

newHost(String name) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList("listHost", hostList);
  List<String> oldHostList = prefs.getStringList("listHost")!;
  oldHostList.add(name);
  prefs.setStringList("listHost", oldHostList);
  hostList = prefs.getStringList("listHost")!;
  print("new host"); print(hostList!);
}

newUser(String name) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList("listUser", userList);
  List<String> oldUserList = prefs.getStringList("listUser")!;
  oldUserList.add(name);
  prefs.setStringList("listUser", oldUserList);
  userList = prefs.getStringList("listUser")!;
  print("new user"); print(userList!);
}

newPass(String name) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList("listPass", passList);
  List<String> oldPassList = prefs.getStringList("listPass")!;
  oldPassList.add(name);
  prefs.setStringList("listPass", oldPassList);
  passList = prefs.getStringList("listPass")!;
  print("new pass"); print(passList!);
}

newColor(String name) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList("listColor", colorList);
  List<String> oldColorList = prefs.getStringList("listColor")!;
  oldColorList.add(name);
  prefs.setStringList("listColor", oldColorList);
  colorList = prefs.getStringList("listColor")!;
  print("new color"); print(colorList!);
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
/*
Navigator.push(
context,
MaterialPageRoute(builder: (context) =>  const Term()),
);
*/

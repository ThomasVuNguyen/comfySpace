import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';
import 'package:flutter/cupertino.dart';
import 'package:xterm/xterm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
String? nickname;
String? hostname;
int port = 22;
String? username;
String? password;
String? color;
int _selectedIndex = 0;
ValueNotifier<int> reloadState = ValueNotifier(0);
Color? currentColor; String? currentColorString;
const bgcolor = Color(0xffFCF3E6);
const borderColor = Colors.black;
const cardColor = Colors.white;
List<String> nameList = [];
List<String> hostList = [];
List<String> userList = [];
List<String> passList = [];
List<String> distroList = []; List<String>? distro = [];
Map<String, Color> colorMap = {"Ubuntu": const Color(0xffE95420), "Raspbian": Colors.green, "Kali Linux": Colors.blue};String currentDistro = colorMap.keys.first;

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
        elevation: 0,
        backgroundColor: bgcolor,
        title: const Text("My Hosts", style: TextStyle(
          color: Colors.black,
          //height: 26, fontSize: 10
        ),
        ),
        //backgroundColor: bgcolor,
        leading: Material(
          type: MaterialType.transparency,
          child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Ink(
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor, width: 2.0 ),
                  color: cardColor,
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(00.0),
                  child: const Padding(
                    padding: EdgeInsets.all(0.0),
                    child: Icon(
                      Icons.menu,
                      size: 20.0,
                      color: Colors.black,
                    ),),),),),),
        actionsIconTheme: const IconThemeData(
          size: 30.0,
          color: Colors.white,
          opacity: 10.0
        ),
        /*actions: <Widget>[
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
                        DropdownButtonFormField<String> (
                          value: colorMap.keys.toList()![0],
                            items: colorMap.keys.toList()!.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(fontSize: 10),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? value){
                            currentDistro = value!;
                            print("changed" + currentDistro!);
                            },
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
                            newDistro(currentDistro!);
                            setState(() {
                            });
                            Navigator.pop(context);
                            currentDistro=colorMap.keys.first;
                          })],);});},
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
                    size: 0.0,
                  )
              )),
        ]*/
      ),
      body: SizedBox(
        child: ListView(
          padding: const EdgeInsets.all(10.0),
          children: List.generate(nameList.length, (index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Image.asset('assets/ubuntu-tile.png'),
                dense: true,
                title: Text(nameList[index][0].toUpperCase()+nameList[index].substring(1)),
              subtitle: Text("${userList[index]} @ ${hostList[index]}"),
              tileColor: colorMap[distroList[index]],
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton( icon:const Icon(Icons.delete, size: 26.0,),
                    onPressed: () { removeItem(index); setState(() {}); },
                  ),
                  IconButton( icon:const Icon(Icons.more, size: 26.0,),
                    onPressed: () { setState(() {}); },
                  ),
                ],
              ),
              onTap: (){
                hostname = hostList[index]; username = userList[index]; password = passList[index];
                Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  const Term()),
          );
              },
            ),
          )),
        ),
      ),
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _selectedIndex,
        iconSize: 30,
        showElevation: false, // use this to remove appBar's elevation
        onItemSelected: (index){
          infoBox(index, context);
          reloadState.addListener(() => setState(() {
          }));
          reloadState.value = 0;
        },
        items: [
          FlashyTabBarItem( icon: const Icon(Icons.scanner), title: const Text('Scan'),),
          FlashyTabBarItem( icon: const Icon(Icons.add), title: const Text('Add'),),
          /*FlashyTabBarItem(
            icon: Image.asset(
              "assets/homeIcon.png",
              color: Color(0xff9496c1),
              width: 30,
            ),
            title: Text('Home'),
          ),*/
          FlashyTabBarItem( icon: const Icon(Icons.settings),  title: const Text('Settings'),),
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
newDistro(String name) async{

  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> oldDistroList = prefs.getStringList("listDistro")!;
  //print("oldDistroList is " + oldDistroList.toString());
  oldDistroList.add(name);
  prefs.setStringList("listDistro", oldDistroList);
  distroList = prefs.getStringList("listDistro")!;
  //print("new distroList is "+ distroList.toString());
  //print("new distro " + name + "added");
}
clearData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList("listName", <String>[]);
  prefs.setStringList("listHost", <String>[]);
  prefs.setStringList("listUser", <String>[]);
  prefs.setStringList("listPass", <String>[]);
  prefs.setStringList("listDistro", <String>[]);
  nameList = <String>[];hostList = <String>[];userList = <String>[];passList = <String>[];distroList = <String>[];
}
reAssign() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //prefs.reload();
  nameList = prefs.getStringList("listName")!;
  hostList = prefs.getStringList("listHost")!;
  userList = prefs.getStringList("listUser")!;
  passList = prefs.getStringList("listPass")!;
  distroList = prefs.getStringList("listDistro")!;
}
resetData() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList("listName", nameList);
  prefs.setStringList("listHost", hostList);
  prefs.setStringList("listPass", passList);
  prefs.setStringList("listColor", distroList);
}
removeItem(int index) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var tempName = prefs.getStringList("listName");
  var tempHost = prefs.getStringList("listName");
  var tempUser = prefs.getStringList("listName");
  var tempPass = prefs.getStringList("listName");
  var tempDistro= prefs.getStringList("listDistro");
  tempName?.removeAt(index);
  tempHost?.removeAt(index);
  tempUser?.removeAt(index);
  tempPass?.removeAt(index);
  tempDistro?.removeAt(index);
  nameList = tempName!; hostList = tempHost!; userList = tempUser!; passList = tempPass!; distroList = tempDistro!;

  prefs.setStringList("listName", tempName!);
  prefs.setStringList("listHost", tempHost!);
  prefs.setStringList("listUser", tempUser!);
  prefs.setStringList("listPass", tempPass!);
  prefs.setStringList("listDistro", tempDistro!);
  print("new list");
  print(tempName);
}
infoBox(int count, BuildContext context) async{
  if(count == 1) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Add a new host"),
          content: Column(
            children: [
              TextField( onChanged: (name1){
                nickname = name1;},
                decoration: const InputDecoration(hintText: "nickname"), textInputAction: TextInputAction.next,
              ),
              TextField( onChanged: (host1){
                hostname = host1;},
                decoration: const InputDecoration(hintText: "hostname"), textInputAction: TextInputAction.next,
              ),
              TextField( onChanged: (user1){
                username = user1;},
                decoration: const InputDecoration(hintText: "username"), textInputAction: TextInputAction.next,
              ),
              TextField( onChanged: (pass1){
                password = pass1;},
                decoration: const InputDecoration(hintText: "password"), textInputAction: TextInputAction.next,
              ),
              DropdownButtonFormField<String> (
                value: colorMap.keys.toList()![0],
                items: colorMap.keys.toList()!.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                }).toList(),
                onChanged: (String? value){
                  currentDistro = value!;
                  print("changed$currentDistro");
                },
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
                  newDistro(currentDistro);
                  print("saved");
                  print("popped 1");
                  currentDistro=colorMap.keys.first;
                  reloadState.value = 1;
                  Navigator.of(context, rootNavigator:true).pop();
                })],
        )
    );
  }
}



/*

*/

/*setState()*/
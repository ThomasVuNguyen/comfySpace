import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:comfyssh_flutter/components/virtual_keyboard.dart';
import 'package:comfyssh_flutter/function.dart';
import 'package:comfyssh_flutter/main.dart';
import 'package:comfyssh_flutter/pages/home_page.dart';
import 'package:comfyssh_flutter/pages/splash.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xterm/xterm.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_url/open_url.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';

String? nickname;String? hostname;int port = 22;String? username;String? password;String? color;int _selectedIndex = 0; String? distro;
ValueNotifier<int> reloadState = ValueNotifier(0);
Color? currentColor; String? currentColorString;
const borderColor = Colors.black;
const cardColor = Colors.white;
List<String> nameList = [];
List<String> hostList = [];
List<String> userList = [];
List<String> passList = [];
List<String> distroList = [];
Map<String, Color> colorMap = {"Ubuntu": const Color(0xffE95420), "Raspbian": Colors.green, "Kali Linux": Colors.blue};String currentDistro = colorMap.keys.first;
const bgcolor = Color(0xffFFFFFF);
const textcolor = Color(0xff000000);
const subcolor = Color(0xff000000);
const keycolor = Color(0xff656366);

void main() {
  memoryCheck();
  reAssign();
  runApp(const MyApp());
}  //main function, execute MyApp

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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff1C3D93),
              onPressed: () {showDialog(context: context, builder:(BuildContext context){
                return AlertDialog(
                  title: const Text("Add a new host"),
                  content: Column(
                    children: [
                      TextField( //add nickname
                        onChanged: (name1){
                          nickname = name1.replaceFirst(name1[0], name1[0].toUpperCase());
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
                          print(password);
                          print(pass1);
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
                          print("done");
                          setState(() {
                          });
                          Navigator.pop(context);
                          currentDistro=colorMap.keys.first;
                        })],);});
              },
              child: Icon(Icons.add, size: 28,),
            ),
      appBar: AppBar(
        shape: const Border(bottom: BorderSide(color: textcolor, width: 2)),
          toolbarHeight: 64,
          title: Row(
            children: <Widget>[
              SizedBox(width: 0, height: 20, child: DecoratedBox(decoration: BoxDecoration(color: bgcolor, ),),), Text('COMFYSSH', style: GoogleFonts.poppins(color: textcolor, fontWeight: FontWeight.bold, fontSize: 24),),
            ],
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: bgcolor,
          ),
          elevation: 0,
          backgroundColor: bgcolor,
          // title: const Text("My Hosts", style: TextStyle( color: Colors.black,),),
          //backgroundColor: bgcolor,
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
                                print(password);
                                print(pass1);
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
                                print("done");
                                setState(() {
                                });
                                Navigator.pop(context);
                                currentDistro=colorMap.keys.first;
                              })],);});},
                  child: const Icon(
                    Icons.add,
                    size: 0,
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
            Padding(padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                child: Icon(Icons.menu, color: textcolor,),
              ),
            )
          ]
      ),
      body: Column(
        children: <Widget>[
          //SizedBox(height: 35,),
          Padding(padding: EdgeInsets.only(top: 35, left: 20),
            child: Align(alignment: Alignment.centerLeft, child: Text("HOSTS", style: GoogleFonts.poppins(color: textcolor, fontWeight: FontWeight.bold, fontSize: 24),)),),
          Padding(padding: EdgeInsets.only(top: 10, left: 20),
            child: Align(alignment: Alignment.centerLeft, child: Text("Code Away", style: GoogleFonts.poppins(color: textcolor, fontSize: 16),)),),
          const SizedBox(height: 43),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0.0), //card wall padding
              children: List.generate(nameList.length, (index) => Padding(
                padding: const EdgeInsets.only(bottom: 20.0), //distance between cards
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: textcolor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),topRight: Radius.circular(0.0),bottomLeft: Radius.circular(8.0),bottomRight: Radius.circular(0.0),
                          )
                      ),
                      height: 128, width: 106,
                      child: IconButton(
                        icon: Image.asset('assets/ubuntu-icon.png'), onPressed: () {
                        nickname = nameList[index];hostname = hostList[index]; username = userList[index]; password = passList[index]; distro = distroList[index];
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  const Term()),
                        );
                      },
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width-40-106, height: 128,
                      child: ListTile(contentPadding: const EdgeInsets.only(top:0.0, bottom: 0.0),
                          trailing: Container( width: 40,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.arrow_forward_ios, color: textcolor,size: 25,),
                              ],
                            ),
                          ),
                          onLongPress: () => showDialog<String>(
                            context: context, builder: (BuildContext context) => AlertDialog(
                            title: const Text('Delete host?'),
                            content: const Text('This will permanently remove host information.'),
                            actions: <Widget>[
                              TextButton(onPressed: () => Navigator.pop(context, 'Cancel'), child: const Text('Cancel'),),
                              TextButton(onPressed: () {removeItem(index); Navigator.pop(context, 'OK'); setState(() {});}, child: const Text('OK'),),],),),
                          onTap: (){
                            nickname = nameList[index];hostname = hostList[index]; username = userList[index]; password = passList[index]; distro = distroList[index];
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>  const Term()),
                            );
                          },
                          shape: const RoundedRectangleBorder(side: BorderSide(width: 2, color:textcolor) , borderRadius: BorderRadius.only(topLeft: Radius.circular(0.0),topRight: Radius.circular(8.0),bottomLeft: Radius.circular(0.0),bottomRight: Radius.circular(8.0),)),
                          title: Padding(
                            padding: const EdgeInsets.only(left: 15.0, top: 23, bottom: 23),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(nameList[index][0].toUpperCase()+nameList[index].substring(1), style: GoogleFonts.poppins(color: textcolor, fontWeight: FontWeight.bold,  fontSize: 20)),
                                Text("${userList[index]} @ ${hostList[index]}", style: GoogleFonts.poppins(color: textcolor, fontSize: 16)),
                              ],
                            ),
                          )
                      ),
                    )
                  ],
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}

class _TerminalPage extends State<Term> {
  late final terminal = Terminal(inputHandler: keyboard);
  final keyboard = VirtualKeyboard(defaultInputHandler);
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 64,
        shape: const Border(bottom: BorderSide(color: textcolor, width: 2)),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: bgcolor,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        title: Column(
            crossAxisAlignment: CrossAxisAlignment.start, //left alignment for texts
          children: [
            Text(nickname!,style: GoogleFonts.poppins(color: textcolor, fontWeight: FontWeight.bold, fontSize: 21)),
            Text(distro!,style: GoogleFonts.poppins(color: textcolor, fontSize: 12)),
          ],
        ),
        backgroundColor: bgcolor,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: const Icon(Icons.arrow_back, color: textcolor,))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: TerminalView(terminal),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: VirtualKeyboardView(keyboard),
      ),
    );
  }
} //TerminalState


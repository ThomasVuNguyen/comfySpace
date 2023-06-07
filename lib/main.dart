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

String? nickname;String? hostname;int port = 22;String? username;String? password;String? color;int _selectedIndex = 0;
ValueNotifier<int> reloadState = ValueNotifier(0);
Color? currentColor; String? currentColorString;
const borderColor = Colors.black;
const cardColor = Colors.white;
List<String> nameList = [];
List<String> hostList = [];
List<String> userList = [];
List<String> passList = [];
List<String> distroList = []; List<String>? distro = [];
Map<String, Color> colorMap = {"Ubuntu": const Color(0xffE95420), "Raspbian": Colors.green, "Kali Linux": Colors.blue};String currentDistro = colorMap.keys.first;
const bgcolor = Color(0xffFFFFFF);
const textcolor = Color(0xff000000);
const subcolor = Color(0xff000000);

void main() {
  memoryCheck();
  reAssign();
  runApp(MyApp());
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
        backgroundColor: Colors.blue,
        onPressed: () {showDialog(context: context, builder:(BuildContext context){
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
                  })],);});
        },
      ),
      appBar: AppBar(
        shape: Border(bottom: BorderSide(color: textcolor, width: 2)),
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
          SizedBox(height: 43),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
              children: List.generate(nameList.length, (index) => Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: SizedBox(
                  height: 128,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(side: BorderSide(width: 2, color:  textcolor/*colorMap[distroList[index]]!*/) , borderRadius: BorderRadius.circular(8.0)),
                    //visualDensity: VisualDensity(vertical: -3, horizontal: 0),
                    leading:  Image.asset('assets/ubuntu-icon.png'),
                    dense: true,
                    title: Text(nameList[index][0].toUpperCase()+nameList[index].substring(1), style: GoogleFonts.ubuntu(color: textcolor, fontSize: 20),),
                    subtitle: Text("${userList[index]} @ ${hostList[index]}", style: GoogleFonts.ubuntu(color: subcolor, fontSize: 18),),
                    tileColor: colorMap[distroList[index]]!,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton( icon:const Icon(Icons.delete, size: 26.0, color: subcolor,),
                          onPressed: () { removeItem(index); setState(() {}); },
                        ),
                        /*IconButton( icon:const Icon(Icons.more, size: 26.0,),
                                    onPressed: () { setState(() {}); },
                                  ),*/
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
      //floatingActionButton:  KeyPressSimulatorWidget(),
      //ArrowUpWidget(),
      /*FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
        onPressed: ,
      )*/
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: bgcolor,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        title: Text(title),
        backgroundColor: bgcolor,
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

class ArrowUpWidget extends StatefulWidget {
  const ArrowUpWidget({super.key});

  @override
  _ArrowUpWidgetState createState() => _ArrowUpWidgetState();
}

class _ArrowUpWidgetState extends State<ArrowUpWidget> {
  final _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void moveCursorUp() async {
    print("up");
    final currentText = _textEditingController.text;
    final selection = _textEditingController.selection;

    if (selection.extentOffset > 0) {
      final updatedOffset = selection.extentOffset - 1;
      final updatedSelection = TextSelection.collapsed(offset: updatedOffset);

      _textEditingController.value = TextEditingValue(
        text: currentText,
        selection: updatedSelection,
        composing: TextRange.empty,
      );

      // Platform-specific code to simulate arrow key press
      if (Theme.of(context).platform == TargetPlatform.android) {
        print("android");
      }
        // iOS does not have a direct way to simulate arrow key press
        // You may need to find a third-party package or custom solution
      } else {
      print("not android");
        /*SystemChannels.textInput.invokeMethod('TextInput.sendKeyEvent', {
          'ok': 'sup',
          'keymap': 'windows', // Change to 'windows' for web platform
          'keyCode': 65, // Key code for arrow-up
          'type': 'keydown',
        });*/
      final event = RawKeyDownEvent(data: RawKeyEventDataAndroid(
        keyCode: 29,
        scanCode: 30,
        metaState: 0,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(onPressed: moveCursorUp,
      backgroundColor: Colors.blue,
      child: Icon(Icons.upload),
    );
  }
}

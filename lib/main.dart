import 'dart:async';
import 'dart:convert';
import 'package:comfyssh_flutter/components/virtual_keyboard.dart';
import 'package:comfyssh_flutter/function.dart';
import 'package:comfyssh_flutter/pages/splash.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xterm/xterm.dart';
import 'package:sqflite/sqflite.dart';

String nickname = "nickname";String hostname = "hostname";int port = 22;String username = "username";String password = "password";String color = "color";int _selectedIndex = 0; String distro = "distro";
ValueNotifier<int> reloadState = ValueNotifier(0);
Color? currentColor; String? currentColorString;
const borderColor = Colors.black;
const cardColor = Colors.white;
List<String> nameList = [];List<String> hostList = [];List<String> userList = [];List<String> passList = [];List<String> distroList = [];
List<String> spaceList = [];
Map<String, String> colorMap = {"Ubuntu": "assets/icons/distro/ubuntu-icon.png", "Raspbian": "assets/icons/distro/RPI-icon.png", "Kali Linux": "assets/icons/distro/kali-icon.png", "Fedora": "assets/icons/distro/fedora-icon.png", "Manjaro": "assets/icons/distro/manjaro-icon.png", "Arch Linux": "assets/icons/distro/arch-icon.png", "Mint Linux": "assets/icons/distro/mint-icon.png", "Debian":  "assets/icons/distro/debian-icon.png", "OpenSUSE": "assets/icons/distro/openSUSE-icon.png", "Custom Distro":"assets/icons/distro/linux-icon.png"};
//Map<String, Color> colorMap = {"Ubuntu": const Color(0xffE95420), "Raspbian": const Color(0xffBC1142), "Kali Linux": const Color(0xff249EFF), "Fedora": const Color(0xff294172), "Manjaro": const Color(0xff35BF5C), "Arch Linux": const Color(0xff1793D1), "Mint Linux": const Color(0xff69B53F), "Debian": const Color(0xffA80030)};
String currentDistro = colorMap.keys.first;
const bgcolor = Color(0xffFFFFFF);const textcolor = Color(0xff000000);const subcolor = Color(0xff000000);const keycolor = Color(0xff656366);const accentcolor = Color(0xff1C3D93);const warningcolor = Color(0xffCE031B);
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

class _WelcomePage extends State<Welcome>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: accentcolor,
        onPressed: () {showDialog(context: context, builder:(BuildContext context){
          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
            contentPadding: const EdgeInsets.all(20.0),
            title: const Center(child: Text("New Host")),
            titleTextStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 24.0, color: textcolor),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField( //add nickname
                    onChanged: (name1){
                      nickname = name1.replaceFirst(name1[0], name1[0].toUpperCase());
                    },
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 15.0, top: 15.0, bottom: 15.0),
                        hintText: "nickname", hintStyle: GoogleFonts.poppins(fontSize: 18.0),
                        focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)),borderSide: BorderSide(color: Colors.blue, width: 2.0)),
                        enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)),borderSide: BorderSide(color: textcolor, width: 2.0))
                    ),textInputAction: TextInputAction.next,
                  ), const SizedBox(height: 32, width: double.infinity,),
                  TextField( //add hostname
                    onChanged: (host1){hostname = host1;},
                    decoration: InputDecoration(
                        hintText: "hostname / IP", hintStyle: GoogleFonts.poppins(fontSize: 18.0),
                        focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)),borderSide: BorderSide(color: Colors.blue, width: 2.0)),
                        enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)),borderSide: BorderSide(color: textcolor, width: 2.0))
                    ),textInputAction: TextInputAction.next,
                  ), const SizedBox(height: 32, width: double.infinity,),
                  TextField( //add username
                    onChanged: (user1){
                      username = user1;
                    },
                    decoration: InputDecoration(
                        hintText: "username", hintStyle: GoogleFonts.poppins(fontSize: 18.0),
                        focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)),borderSide: BorderSide(color: Colors.blue, width: 2.0)),
                        enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)),borderSide: BorderSide(color: textcolor, width: 2.0))
                    ),textInputAction: TextInputAction.next,
                  ), const SizedBox(height: 32, width: double.infinity,),
                  TextField( //add password
                    onChanged: (pass1){
                      password = pass1;
                    },
                    decoration: InputDecoration(
                        hintText: "password", hintStyle: GoogleFonts.poppins(fontSize: 18.0),
                        focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)),borderSide: BorderSide(color: Colors.blue, width: 2.0)),
                        enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)),borderSide: BorderSide(color: textcolor, width: 2.0))
                    ),textInputAction: TextInputAction.next,
                  ), const SizedBox(height: 32, width: double.infinity,),
                  DropdownButtonFormField<String> (
                    decoration: const InputDecoration(
                        border:  OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)), borderSide: BorderSide(color: Colors.blue, width: 2.0))
                    ),
                    iconSize: 30.0, iconDisabledColor: textcolor, iconEnabledColor: Colors.blue,
                    value: colorMap.keys.toList()[0],
                    items: colorMap.keys.toList().map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: GoogleFonts.poppins(fontSize: 18.0),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value){
                      currentDistro = value!;
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                  color: accentcolor,
                  textColor: Colors.white,
                  child: Text("Done", style: GoogleFonts.poppins(fontSize: 18),),
                  onPressed: (){
                    newName(nickname);
                    newHost(hostname!);
                    newUser(username);
                    newPass(password);
                    newDistro(currentDistro);
                    print("done");
                    setState(() {
                    });
                    Navigator.pop(context);
                    currentDistro=colorMap.keys.first;
                  })],);});
        },
        child: const Icon(Icons.add, size: 28,),
      ),
      appBar: AppBar(
          shape: const Border(bottom: BorderSide(color: textcolor, width: 2)),
          toolbarHeight: 64,
          title: Row(
            children: <Widget>[
              const SizedBox(width: 0, height: 20, child: DecoratedBox(decoration: BoxDecoration(color: bgcolor, ),),), Text('HOSTS', style: GoogleFonts.poppins(color: textcolor, fontWeight: FontWeight.bold, fontSize: 24),),
            ],
          ),
          systemOverlayStyle: const SystemUiOverlayStyle(
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
                        title: Text("Add a new host",  style: GoogleFonts.poppins(fontSize: 18, color: textcolor),),
                        content: Column(mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField( //add nickname
                              onChanged: (name1){
                                nickname = name1;},
                              decoration: const InputDecoration(
                                hintText: "nickname",
                              ),textInputAction: TextInputAction.next,
                            ),
                            TextField( //add hostname
                              onChanged: (host1){
                                hostname = host1;},
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
                              value: colorMap.keys.toList()[0],
                              items: colorMap.keys.toList().map<DropdownMenuItem<String>>((String value) {
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
                                newName(nickname);
                                newHost(hostname!);
                                newUser(username);
                                newPass(password);
                                newDistro(currentDistro);
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
                child: const Icon(Icons.menu, color: textcolor,),
                /*onTap: (){
                  showDialog<String>(
                      context: context, builder: (BuildContext context) =>
                      AlertDialog(
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: [
                                Image.asset("assets/comfy-cat.png", width: 40.0,),
                                const SizedBox(width: 10.0,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("comfyStudio team",style: GoogleFonts.poppins(fontSize: 21.0,fontWeight: FontWeight.bold )),
                                    Text("Hey there!",style: GoogleFonts.poppins(fontSize: 12.0, color: const Color(0xff656366))),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0,),
                            Text("Thank you for using comfySSH!",style: GoogleFonts.poppins(fontSize: 16.0, ),),
                            Text("",style: GoogleFonts.poppins(fontSize: 16.0, ),),
                            Text("With comfySSH, we want to deliver to you a comfortable development experience - minimal and powerful.",style: GoogleFonts.poppins(fontSize: 16.0, )),
                            Text("",style: GoogleFonts.poppins(fontSize: 16.0, )),Text("If you have any feedback or feature suggestion, you can do so at our website/email:",style: GoogleFonts.poppins(fontSize: 16.0, )),
                            Text("",style: GoogleFonts.poppins(fontSize: 16.0, )), SelectableText("comfyStudio.tech",style: GoogleFonts.poppins(fontSize: 16.0, fontWeight:FontWeight.w600 )),
                            SelectableText("feedback@comfystudio.tech",style: GoogleFonts.poppins(fontSize: 12.0, fontWeight:FontWeight.w600 )),
                            Text("",style: GoogleFonts.poppins(fontSize: 16.0, )),Text("You can also see how we have planned for feedback & feature request in the past at our website.",style: GoogleFonts.poppins(fontSize: 16.0, )),
                            Text("",style: GoogleFonts.poppins(fontSize: 16.0, )),Text("In the mean time, look out for more updates and take care!",style: GoogleFonts.poppins(fontSize: 16.0, )),
                            Text("",style: GoogleFonts.poppins(fontSize: 16.0, ))
                          ],
                        ),
                      )
                  );
                },*/
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  const comfySpace()),
                  );
                }
              ),
            ),

          ]
      ),
      body: FutureBuilder(
        future: Future.wait([reAssignNameList(),reAssignHostList(),reAssignUserList(),reAssignPassList(),reAssignDistroList()]),
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            return Column(
              children: <Widget>[
                const SizedBox(height: 43),
                Expanded(
                  child: ListView(
                    physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0.0, top: 0.0), //card wall padding
                    children: List.generate(snapshot.data[0].length, (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 20.0), //distance between cards
                      child: Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                color: textcolor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),topRight: Radius.circular(0.0),bottomLeft: Radius.circular(8.0),bottomRight: Radius.circular(0.0),
                                )
                            ),
                            height: 128, width: 106,
                            child: IconButton(
                                onPressed: () {
                                  nickname = snapshot.data[0][index] ;hostname = snapshot.data[1][index]; username = snapshot.data[2][index]; password = snapshot.data[3][index]; distro = snapshot.data[4][index];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>  const Control()),
                                  );
                                },icon: Image.asset(colorMap[distroList[index]]!, height: 50,)
                            ),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width-40-106, height: 128,
                            child: ListTile(contentPadding: const EdgeInsets.only(top:0.0, bottom: 0.0),
                                trailing: Container( width: 40,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: const [
                                      Icon(Icons.arrow_forward_ios, color: textcolor,size: 25,),
                                    ],
                                  ),
                                ),
                                onLongPress: () => showDialog<String>(
                                  context: context, builder: (BuildContext context) => AlertDialog(
                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)), side: BorderSide(color: warningcolor, width: 2.0)),
                                  title: Text('Delete host?', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold ),),
                                  content: Text('This will permanently remove host information.', style: GoogleFonts.poppins(fontSize: 16 )),
                                  actions: <Widget>[
                                    RawMaterialButton(onPressed: () => Navigator.pop(context, 'Cancel'), child: const Text('Cancel'),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(8.0))
                                      ),
                                    ),
                                    RawMaterialButton(onPressed: () {removeItem(index); Navigator.pop(context, 'Delete'); setState(() {});}, child: const Text('Delete'),
                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)), ),
                                      fillColor: warningcolor,
                                      textStyle: GoogleFonts.poppins(color: bgcolor, fontWeight: FontWeight.w600, fontSize: 16),
                                    ),],),),
                                onTap: (){
                                  nickname = snapshot.data[0][index];hostname = snapshot.data[1][index]; username = snapshot.data[2][index]; password = snapshot.data[3][index]; distro = snapshot.data[4][index];
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
                                      Text(snapshot.data[0][index][0].toUpperCase()+snapshot.data[0][index].substring(1), style: GoogleFonts.poppins(color: textcolor, fontWeight: FontWeight.bold,  fontSize: 20)),
                                      Text("${snapshot.data[2][index]} @ ${snapshot.data[1][index]}", style: GoogleFonts.poppins(color: textcolor, fontSize: 16)),
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
            );
          }
          return Text("loading");
        },
      )
    );
  }
}

class Term extends StatefulWidget {
  const Term({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _TerminalPage createState() => _TerminalPage();

} //MyHomePage

class _TerminalPage extends State<Term> {
  late final terminal = Terminal(inputHandler: keyboard);
  final keyboard = VirtualKeyboard(defaultInputHandler);
  var title = hostname! + username! + password!;
  int buttonState = 1;
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
    print(client.username);

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

class Control extends StatefulWidget {
  const Control({super.key});

  @override
  State<Control> createState() => _ControlState();
}

class _ControlState extends State<Control> {
  List<String> buttonList = [];
  List<String> sizeXList =[];
  List<String> sizeYList = [];
  List<String> positionList = [];
  List<String> commandList = [];
  String message = 'hi im message';
  void init(){
    String space1 = "space1";
    createSpace(space1);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(message),
      ),
      floatingActionButton: IconButton(
        icon: Icon(Icons.connected_tv_sharp), onPressed : () async {
          var listTotal = await renderer('space1'); buttonList = listTotal[0]; sizeXList = listTotal[1]; sizeYList = listTotal[2]; positionList = listTotal[3]; commandList = listTotal[4];
          createSpace('space1');
        addButton('space1', "tung", 1, 1, 1, 'echo Im tung');
        setState(() {});
        },),
      body: GridView.count(
        crossAxisCount: 4,
        children:
        List.generate(buttonList.length, (index) {
          return Center(
            child: IconButton(
              onPressed: () {setState(() {message = commandList[index];});},
              icon: const Icon(Icons.ac_unit_rounded),
            ),
          );
        }),
      ),
    );
  }
}

class comfySpace extends StatefulWidget {
  const comfySpace({super.key});
  @override
  State<comfySpace> createState() => _comfySpaceState();
}

class _comfySpaceState extends State<comfySpace> {

  @override
  void initState(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      updateSpaceRender();
    });
    super.initState();
    
    print(spaceList.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("comfySpace"),
        actions: <Widget>[
          IconButton(onPressed: () async {
            //List<String> ok = await updateSpaceList('comfySpace');
            //print(ok);
            setState(() {});
          }, icon: const Icon(Icons.update))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.create),
        onPressed: () {
          String spaceName = 'space1';
          showDialog(context: context, builder: (BuildContext context){
            return AlertDialog(
              title: const Text("Create a new space"),
              content: TextField(
                onChanged: (name){
                  spaceName = name;
                },
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () async{
                      createSpace(spaceName);
                      updateSpaceRender();
                      Navigator.pop(context);
                      setState(() {});
                      },
                    child: const Text("save")
                )
              ],
            );
          }); },

      ),
      body: FutureBuilder(
        future: updateSpaceRender(),
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.connectionState != ConnectionState.done){
            return ColoredBox(color: Colors.red);
          }
          if(snapshot.hasData){
            final currentSpaceList = snapshot.data;
            return ListView.builder(
              itemCount: currentSpaceList.length,
                itemBuilder: (context, index){
                return ListTile(
                  title: Text(currentSpaceList[index]),
                  leading: Icon(Icons.one_k),
                );
                });
          }
          return Text("loading");
        },
      )
    );
  }
}

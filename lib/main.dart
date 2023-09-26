import 'dart:async';
import 'dart:convert';
import 'package:comfyssh_flutter/comfyScript/LED.dart';
import 'package:comfyssh_flutter/comfyScript/servo.dart';
import 'package:comfyssh_flutter/comfyScript/updateRepo.dart';
import 'package:comfyssh_flutter/components/custom_ui_components.dart';
import 'package:comfyssh_flutter/components/custom_widgets.dart';
import 'package:comfyssh_flutter/components/pop_up.dart';
import 'package:comfyssh_flutter/components/virtual_keyboard.dart';
import 'package:comfyssh_flutter/function.dart';
import 'package:comfyssh_flutter/pages/Experimental.dart';
import 'package:comfyssh_flutter/pages/settings.dart';
import 'package:comfyssh_flutter/pages/splash.dart';
import 'package:comfyssh_flutter/state.dart';
import 'package:comfyssh_flutter/states/spaceState.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:xterm/xterm.dart';
import 'dart:io' show Platform;


String nickname = "nickname";String hostname = "hostname";int port = 22;String username = "username";String password = "password";String color = "color";int _selectedIndex = 0; String distro = "distro";
ValueNotifier<int> reloadState = ValueNotifier(0);
String spaceLaunch = '';
Color? currentColor; String? currentColorString;
String buttonName = ''; int buttonSizeX = 1; int buttonSizeY = 1; int buttonPosition = 1; String buttonCommand = 'htop';
const borderColor = Colors.black;
const cardColor = Colors.white;
List<String> nameList = [];List<String> hostList = [];List<String> userList = [];List<String> passList = [];List<String> distroList = [];
List<String> spaceList = [];
Map<String, String> colorMap = {"Ubuntu": "assets/icons/distro/ubuntu-icon.png", "Raspbian": "assets/icons/distro/RPI-icon.png", "Kali Linux": "assets/icons/distro/kali-icon.png", "Fedora": "assets/icons/distro/fedora-icon.png", "Manjaro": "assets/icons/distro/manjaro-icon.png", "Arch Linux": "assets/icons/distro/arch-icon.png", "Mint Linux": "assets/icons/distro/mint-icon.png", "Debian":  "assets/icons/distro/debian-icon.png", "OpenSUSE": "assets/icons/distro/openSUSE-icon.png", "Custom Distro":"assets/icons/distro/linux-icon.png"};
//Map<String, Color> colorMap = {"Ubuntu": const Color(0xffE95420), "Raspbian": const Color(0xffBC1142), "Kali Linux": const Color(0xff249EFF), "Fedora": const Color(0xff294172), "Manjaro": const Color(0xff35BF5C), "Arch Linux": const Color(0xff1793D1), "Mint Linux": const Color(0xff69B53F), "Debian": const Color(0xffA80030)};
String currentDistro = colorMap.keys.first;
List<String> componentTypeList = ['LED', 'RGBLED', 'Servo'];
List<String> buttonTypeList = ['toggleButton', 'slider', 'slider'];
const bgcolor = Color(0xffFFFFFF);const textcolor = Color(0xff000000);const subcolor = Color(0xff000000);const keycolor = Color(0xff656366);const accentcolor = Color(0xff1C3D93);const warningcolor = Color(0xffCE031B);
const keyGreen = Color(0xff3DDB87);
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  memoryCheck();
  //sqfliteFfiInit();
  //databaseFactory = databaseFactoryFfi;
  if (Platform.isWindows){
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  reAssign();
  runApp(MyApp());
  createHostInfo();
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
                      newHost(hostname);
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

} //Term

class _TerminalPage extends State<Term> {
  late final terminal = Terminal(inputHandler: keyboard);
  final keyboard = VirtualKeyboard(defaultInputHandler);
  var title = hostname! + username! + password!;
  int buttonState = 1;
  @override
  void initState() {
    print(hostname);
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
    //String space1 = "space1";
    //createSpace(space1, host, user, password)
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
        //createSpace('space1');

        setState(() {});
      },),
      body: GridView.count(
        crossAxisCount: 4,
        children:
        List.generate(buttonList.length, (index) {
          return Center(
            child: IconButton(
              onPressed: () {

                setState(() {message = commandList[index];});},
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
  int bottomBarIndex = 0;
  final List<Widget> pageLists = [
    Padding(
      padding: const EdgeInsets.only(top:43),
      child: FutureBuilder(
        future: updateSpaceList('comfySpace.db'),
        //updateSpaceListStream('comfySpace.db'),
        //Stream<List<String>>.fromFuture(updateSpaceList('comfySpace.db')),
        initialData: const [],
        builder: (context, AsyncSnapshot snapshot){
          /*if(snapshot.connectionState != ConnectionState.done){
          print("state issue");
          return const ColoredBox(color: Colors.red);
        }
        else if(!snapshot.hasData){
          return const CircularProgressIndicator();
        }*/
          if(snapshot.hasData){
            print("has data");
            return ListView.builder(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0.0, top: 0.0), //card wall padding
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: spaceTile(spaceName: snapshot.data[index]),
                  );
                });
          }
          return Text("loading");
        },
      ),
    ),
    SettingPage(),
    Center(child: Text("documentation"),),
    Center(child: Text("about us"),),
  ];
  @override
  void initState(){
    super.initState();
    setState(() {});
  }

  @override
  void dispose(){
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: bgcolor,
            border: Border(top: BorderSide(color: borderColor, width: 2.0),)
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10,),
              child: GNav(
                rippleColor: Colors.blue, haptic: true, duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutExpo,
                backgroundColor: Colors.white, color: Colors.black, activeColor: Colors.white, tabBackgroundColor: Colors.black,
                tabActiveBorder: Border.all(color: Colors.black, width: 1), tabBorderRadius: 10.0,
                padding: const EdgeInsets.all(16),
                gap: 8,
                tabs: const [
                  GButton(icon: Icons.home, ),
                  GButton(icon: Icons.settings, ),
                  GButton(icon: Icons.help_center, ),
                  GButton(icon: Icons.more, ),
                ],
                selectedIndex: bottomBarIndex,
                onTabChange: (index){
                  //print(index);
                  setState(() {
                    bottomBarIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(64.0),
          child: AppBar(
            titleSpacing: 20,
            automaticallyImplyLeading: false,
            shape: const Border(bottom: BorderSide(color: textcolor, width:2)),
            title: GestureDetector(
              onTap: (){
                showDialog(context: context, builder: (BuildContext context){
                  return const Credit();
                });
              },
                child: Text('ComfySpace', style: GoogleFonts.poppins(color: textcolor, fontWeight: FontWeight.bold, fontSize: 24),)),
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: bgcolor,
            ),
            elevation: 0, backgroundColor: bgcolor,
            actionsIconTheme: const IconThemeData(size: 30, color: Colors.black, opacity: 10.0),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  child: Icon(Icons.restart_alt, color: Colors.black),
                  onTap: (){
                    setState(() {});
                    String testHost = checkHostInfo('comfySpace.db').toString();
                    print(testHost);
                  },
                ),
              ),

            ],
          ),
        ),
        //floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
          ),
          tooltip: 'Add New Space',
          child: const Icon(Icons.add),
          onPressed: () {
            print("creating");

            //String spaceName = 'space1'; late String hostInfo; late String userInfo; late String passwordInfo;
            showDialog(context: context, builder: (BuildContext context){
              return const NewSpaceDialog();
              /*return AlertDialog(
                title: const Text("Create a new space"),
                content: Column(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (name){
                          spaceName = name;
                        },
                        decoration: InputDecoration(hintText: "space name"), textInputAction: TextInputAction.next,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        onChanged: (text2){
                          hostInfo = text2;
                        }, decoration: InputDecoration(hintText: "host"), textInputAction: TextInputAction.next,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        onChanged: (text3){
                          userInfo = text3;
                        }, decoration: InputDecoration(hintText: "user"), textInputAction: TextInputAction.next,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                          onChanged: (text4){
                            passwordInfo = text4;
                          }, decoration: InputDecoration(hintText: "password")
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        createSpace(spaceName, hostInfo, userInfo, passwordInfo );
                        //Navigator.push(context, MaterialPageRoute(builder: (context) =>  const comfySpace()),);
                        Future.delayed(const Duration(milliseconds: 100), (){
                          setState(() {
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>  const comfySpace()),);
                          });
                        });
                      },
                      child: const Text("save")
                  )
                ],
              );*/
            }
            ); },

        ),
        body: pageLists[bottomBarIndex],
    );
  }
}

class spacePage extends StatefulWidget {
  const spacePage({super.key, required this.spaceName, required this.hostname, required this.username, required this.password});
  final String spaceName; final String hostname; final String username; final String password;
  @override
  State<spacePage> createState() => _spacePageState();
}

class _spacePageState extends State<spacePage> {
  late final terminal = Terminal(
    maxLines: 6,
  );
  Map<int, bool> toggleState = {};
  Map<int, int> servoState = {};
  late SSHClient clientControl;
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  @override
  void initState(){
    super.initState();
    print("welcome to ${widget.spaceName}");
    initControl();
  }
  @override
  void dispose(){
    super.dispose();
    clientControl.close();
  }
  Future<void> initTerminal() async{
    terminal.write('yo');
}
  Future<void> initControl() async{
    clientControl = SSHClient(
      await SSHSocket.connect(widget.hostname, port),
      username: widget.username,
      onPasswordRequest: () => widget.password,
    );
    print("${clientControl.username} is ready");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: comfyAppBar(title: widget.spaceName)),
        backgroundColor: bgcolor,
        floatingActionButton:
        //AddingButtonDial(databaseName: 'comfySpace.db', spaceName: widget.spaceName, ),
        SpeedDial(
          //animatedIcon: AnimatedIcons.event_add,
          tooltip: "Add Button",
          icon: Icons.add_circle,
          activeIcon: Icons.close,
          visible: true,
          closeManually: false,
          curve: Curves.bounceIn,
          overlayColor: Colors.black, backgroundColor: textcolor,
          onOpen: (){},onClose: (){},
          children: [
            SpeedDialChild(
                child: Image.asset('assets/speedDialIcons/custom_button.png',),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                label: "custom", labelStyle: TextStyle(fontSize: 18),
                onTap: (){
                  showDialog(context: context, builder: (BuildContext context){
                    String buttonType = 'custom';
                    buttonSizeY = 1;
                    buttonSizeX=1;
                    buttonPosition=1;
                    return ButtonAlertDialog(
                        title: 'Custom button',
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              comfyTextField(onChanged: (btnName){
                                buttonName = btnName;
                              }, text: 'button name'),
                              const SizedBox(height: 32, width: double.infinity,),
                              comfyTextField(onChanged: (btnCommand){
                                buttonCommand = btnCommand;
                              }, text: 'command'),
                            ],
                          ),
                        ),
                        actions: [
                          comfyActionButton(
                            onPressed: (){
                              addButton('comfySpace.db', widget.spaceName, buttonName, buttonSizeX, buttonSizeY, buttonPosition, buttonCommand, 'custom');
                              print("$buttonName has been added to ${widget.spaceName}");
                              Navigator.pop(context);
                              setState(() {});
                              },
                          ),
                        ]);
                  });
                }
            ),
            SpeedDialChild(
              backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Image.asset('assets/speedDialIcons/led.png', width: 40,),
                label: 'LED',
                onTap: (){
                  late String pinOut;
                  showDialog(context: context, builder: (BuildContext context){
                    return ButtonAlertDialog(
                        title: 'LED toggle',
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              comfyTextField(text: 'button name', onChanged: (btnName){
                                buttonName = btnName;
                              }),
                              const SizedBox(height: 32, width: double.infinity,),
                              comfyTextField(text: 'pin number',
                                onChanged: (pinNum){pinOut = pinNum;},
                                keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              ),
                              Icon8Credit(iconName: 'LED',iconLink: 'https://icons8.com/icon/8BGi5ks3s1pY/led-diode',),
                            ],
                          ),
                        ),
                      actions: <Widget>[
                        comfyActionButton(onPressed: (){
                          addButton('comfySpace.db', widget.spaceName, buttonName, buttonSizeX, buttonSizeY, buttonPosition, pinOut,'LED');
                          Navigator.pop(context);
                          setState(() {});
                        },)
                      ],
                    );
                  });
                }
            ),
            SpeedDialChild(
              backgroundColor: Colors.transparent,
              label: 'Stepper Motor',
              child: Image.asset('assets/speedDialIcons/stepperMotor.png', width: 40,),
              onTap: (){
                late String pin1; late String pin2; late String pin3; late String pin4;
                showDialog(context: context, builder: (BuildContext context){
                  return ButtonAlertDialog(
                    title: 'Stepper Motor',
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          comfyTextField(text: 'button name', onChanged: (btnName){
                            buttonName = btnName;
                          }),
                          const SizedBox(height: 32, width: double.infinity,),
                          comfyTextField(text: 'pin1', onChanged: (pin){
                            pin1 = pin;
                          }),
                          const SizedBox(height: 32, width: double.infinity,),
                          comfyTextField(text: 'pin2', onChanged: (pin){
                            pin2 = pin;
                          }),
                          const SizedBox(height: 32, width: double.infinity,),
                          comfyTextField(text: 'pin3', onChanged: (pin){
                            pin3 = pin;
                          }),
                          const SizedBox(height: 32, width: double.infinity,),
                          comfyTextField(text: 'pin4', onChanged: (pin){
                            pin4 = pin;
                          }),
                          const SizedBox(height: 32, width: double.infinity,),
                          const Icon8Credit(iconLink: 'https://icons8.com/icon/lOL-oIF5khIW/stepper-motor', iconName: 'Stepper Motor')
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(onPressed: (){
                        String stepperPinList = "$pin1 $pin2 $pin3 $pin4";
                        addButton('comfySpace.db', widget.spaceName, buttonName, buttonSizeX, buttonSizeY, buttonPosition, stepperPinList,'stepperMotor');
                        Navigator.pop(context);
                        setState(() {});
                      },
                          child: const Text("servo")
                      )
                    ],
                  );
                });
              }
            ),
            SpeedDialChild(
                backgroundColor: Colors.transparent,
                label: 'DC Motor',
                child: Image.asset('assets/speedDialIcons/dc-motor.png', width: 40,),
                onTap: (){
                  late String pin1; late String pin2; late String pin3; late String pin4;
                  showDialog(context: context, builder: (BuildContext context){
                    return ButtonAlertDialog(
                      title: 'DC Motor',
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            comfyTextField(text: 'button name', onChanged: (btnName){
                              buttonName = btnName;
                            }),
                            const SizedBox(height: 32, width: double.infinity,),
                            comfyTextField(text: 'pin1', onChanged: (pin){
                              pin1 = pin;
                            }),
                            const SizedBox(height: 32, width: double.infinity,),
                            comfyTextField(text: 'pin2', onChanged: (pin){
                              pin2 = pin;
                            }),
                            const SizedBox(height: 32, width: double.infinity,),
                            const Icon8Credit(iconLink: 'https://icons8.com/icon/lOL-oIF5khIW/stepper-motor', iconName: 'DC Motor')
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(onPressed: (){
                          String stepperPinList = "$pin1 $pin2";
                            addButton('comfySpace.db', widget.spaceName, buttonName, buttonSizeX, buttonSizeY, buttonPosition, stepperPinList,'DCMotor');
                          Navigator.pop(context);
                          setState(() {});
                        },
                            child: const Text("servo")
                        )
                      ],
                    );
                  });
                }
            ),
            SpeedDialChild(
              backgroundColor: Colors.transparent,
              child: Image.asset('assets/speedDialIcons/ultrasonic_distance_sensor.png'), label: 'Ultrasonic sensor',
              onTap: (){
                late String trig; late String echo;
                showDialog(context: context, builder: (BuildContext context){
                  return ButtonAlertDialog(
                    title: "Distance sensor",
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          comfyTextField(text: 'button name', onChanged: (btnName){
                            buttonName = btnName;
                          }),
                          const SizedBox(height: 32, width: double.infinity,),

                          comfyTextField(text: 'trigger pin',
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              onChanged: (pin){
                            trig = pin;
                          }),
                          const SizedBox(height: 32, width: double.infinity,),

                          comfyTextField(text: 'echo pin',
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              onChanged: (pin){
                                echo = pin;
                              }),
                          const SizedBox(height: 32, width: double.infinity,),

                          const IconDuckCredit(iconLink: 'https://iconduck.com/icons/190115/ultrasonic-distance-sensor', iconName: 'Sensor'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: (){
                          String HCSR04PinList = '$trig $echo';
                          addButton('comfySpace.db', widget.spaceName, buttonName, buttonSizeX, buttonSizeY, buttonPosition, HCSR04PinList, 'HCSR04');
                          Navigator.pop(context);
                          setState(() {});
                        }, child: Text("Add distance sensor"),
                      )
                    ],
                  );
                });
              }
            )
          ],
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              updateRepoWidget(hostname: widget.hostname, username: widget.username, password: widget.password, terminal: terminal),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: keyGreen, width: 5),
                      borderRadius: BorderRadius.circular(0.0),
                      //color: Colors.black,
                    ),
                  height: 120,
                    child: TerminalView(terminal, readOnly: true, autoResize: true, padding: const EdgeInsets.only(left: 20, top: 10),textStyle: const TerminalStyle(fontSize: 13,))),
              ),
              const SizedBox(height: 32,),
              Expanded(
                child: FutureBuilder(
                    future: buttonRenderer('comfySpace.db', widget.spaceName),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done){
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: GridView.builder(
                            shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              itemCount: snapshot.data?.length,
                              itemBuilder: (BuildContext context, index){
                                if (snapshot.data![index]["buttonType"] == "LED"){
                                  return GestureDetector(
                                      onLongPress: (){
                                        setState(() {
                                          deleteButton('comfySpace.db', widget.spaceName, snapshot.data![index]["name"], snapshot.data![index]["id"]);
                                        });
                                      },
                                      child: LedToggle(spaceName: widget.spaceName, name: snapshot.data![index]["name"], pin: snapshot.data![index]["command"], id: snapshot.data![index]["id"], hostname: widget.hostname, username: widget.username, password: widget.password,terminal: terminal));
                                }
                                else if (snapshot.data![index]["buttonType"] == "servo"){
                                  if(servoState[index]==null){
                                    servoState[index] = 0;
                                  };
                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return GestureDetector(
                                          onLongPress: (){
                                            deleteButton('comfySpace.db', spaceLaunch, snapshot.data![index]["name"], snapshot.data![index]["id"]);
                                            servoState.remove(index);
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext context) => super.widget));
                                          },
                                          child: Slider(
                                            onChanged: (newAngle) async {
                                              setState(() {servoState[index] = newAngle.toInt();});
                                              var command = await clientControl.run(servoAngle(snapshot.data![index]["command"], servoState[index]!));
                                            }, value: servoState[index]!.toDouble(),
                                            min: 0.0, max: 180.0, divisions: 4,
                                          )
                                      );
                                    },
                                  );
                                }
                                else if (snapshot.data![index]["buttonType"] == "stepperMotor"){
                                  List<String> pinList = snapshot.data![index]["command"].split(" ");
                                  return GestureDetector(
                                    onLongPress: (){
                                      setState(() {
                                        deleteButton('comfySpace.db', widget.spaceName, snapshot.data![index]["name"], snapshot.data![index]["id"]);
                                      });},
                                    child: StepperMotor(name: snapshot.data![index]["name"], id: snapshot.data![index]["id"] ,pin1: pinList[0], pin2: pinList[1], pin3: pinList[2], pin4: pinList[3], hostname: widget.hostname, username: widget.username, password: widget.password),
                                  );
                                }
                                else if (snapshot.data![index]["buttonType"] == "HCSR04"){
                                  List<String> pinList = snapshot.data![index]["command"].split(" ");
                                  return GestureDetector(
                                    onLongPress: (){
                                      setState(() {deleteButton('comfySpace.db', widget.spaceName, snapshot.data![index]["name"], snapshot.data![index]["id"]);});
                                    },
                                    child: DistanceSensor(spaceName: widget.spaceName, name: snapshot.data![index]["name"], id: snapshot.data![index]["id"], hostname: widget.hostname, username: widget.username, password: widget.password, trig: pinList[0], echo: pinList[1]),
                                  );
                                }
                                else if (snapshot.data![index]["buttonType"] == "DCMotor"){
                                  List<String> pinList = snapshot.data![index]["command"].split(" ");
                                  return GestureDetector(
                                    onLongPress: (){
                                      setState(() {
                                        deleteButton('comfySpace.db', widget.spaceName, snapshot.data![index]["name"], snapshot.data![index]["id"]);
                                      });
                                    },
                                    child: DCMotorSingle(name: snapshot.data![index]["name"], id: snapshot.data![index]["id"] ,pin1: pinList[0], pin2: pinList[1], hostname: widget.hostname, username: widget.username, password: widget.password),
                                  );
                                }
                                else{
                                  /*return ListTile(
                                    title: Text(snapshot.data![index].toString()),
                                    tileColor: Colors.grey,
                                    onTap: () async {
                                      var command = await clientControl.run(snapshot.data![index]["command"]);
                                      print("command is " + snapshot.data![index]["command"]);
                                      print(toggleState.toString());
                                    },
                                    onLongPress: (){
                                      showDialog(context: context, builder: (BuildContext context){
                                        String btnName = snapshot.data![index]["name"];
                                        int btnSizeX = snapshot.data![index]["size_x"];
                                        int btnSizeY = snapshot.data![index]["size_y"];
                                        int btnPosition = snapshot.data![index]["position"];
                                        String btnCommand = snapshot.data![index]["command"];
                                        return AlertDialog(
                                          title: const Text("Edit buttons"),
                                          content: Column(
                                            children: [
                                              TextField(
                                                onChanged: (newName){
                                                  btnName = newName;
                                                },
                                                decoration: const InputDecoration(hintText: 'new name'),
                                                textInputAction: TextInputAction.next,
                                              ),
                                              /*
                                        TextField(
                                          onChanged: (newSizeX){
                                            btnSizeX = int.parse(newSizeX);
                                          },
                                          decoration: const InputDecoration(hintText: 'new sizeX'),
                                          textInputAction: TextInputAction.next,
                                        ),
                                        TextField(
                                          onChanged: (newSizeY){
                                            btnSizeY = int.parse(newSizeY);
                                          },
                                          decoration: const InputDecoration(hintText: 'new sizeY'),
                                          textInputAction: TextInputAction.next,
                                        ),
                                        TextField(
                                          onChanged: (newPostion){
                                            btnPosition = int.parse(newPostion);
                                          },
                                          decoration: const InputDecoration(hintText: 'new position'),
                                          textInputAction: TextInputAction.next,
                                        ),
                                        */

                                              TextField(
                                                onChanged: (newCommand){
                                                  btnCommand = newCommand;
                                                },
                                                decoration: const InputDecoration(hintText: 'new command'),
                                              ),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            TextButton(onPressed: (){
                                              deleteButton('comfySpace.db', spaceLaunch, snapshot.data![index]["name"], snapshot.data![index]["id"]);
                                              Navigator.pop(context);
                                              setState(() {});
                                            }, child: Text("Delete")),
                                            TextButton(onPressed: (){
                                              editButton('comfySpace.db', spaceLaunch, snapshot.data![index]["id"], btnName, btnSizeX, btnSizeY, btnPosition, btnCommand);
                                              Navigator.pop(context);
                                              setState(() {});
                                            }, child: Text("Alter"))
                                          ],
                                        );
                                      });
                                      //deleteButton('comfySpace.db', spaceLaunch, snapshot.data![index]["name"], snapshot.data![index]["id"]);
                                      setState(() {});
                                    },
                                  );*/
                                  //return CustomToggleButton(name: snapshot.data![index]["name"], hostname: widget.hostname, username: widget.username, password: widget.password, commandOn: snapshot.data![index]["command"], commandOff: snapshot.data![index]["command"], terminal: terminal);
                                  return GestureDetector(
                                    onLongPress: (){deleteButton('comfySpace.db', widget.spaceName, snapshot.data![index]["name"], snapshot.data![index]["id"]); setState(() {
                                    });},
                                    child: CustomToggleButton(name: snapshot.data![index]["name"], hostname: widget.hostname, username: widget.username, password: widget.password, commandOn: snapshot.data![index]["command"], commandOff: snapshot.data![index]["command"], terminal: terminal),
                                  );
                                }
                              }),
                        );
                      }
                      else{
                        return const CircularProgressIndicator();
                      }
                    }
                ),
              ),
            ],
          ),
        )
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:comfyssh_flutter/comfyScript/Buzzer.dart';
import 'package:comfyssh_flutter/comfyScript/ComfyToggleButton.dart';
import 'package:comfyssh_flutter/comfyScript/ComfyVerticalSwipeButton.dart';
import 'package:comfyssh_flutter/comfyScript/LED.dart';
import 'package:comfyssh_flutter/comfyScript/servo.dart';
import 'package:comfyssh_flutter/comfyScript/statemanagement.dart';
import 'package:comfyssh_flutter/comfyScript/updateRepo.dart';
import 'package:comfyssh_flutter/components/DocumentationButton.dart';
import 'package:comfyssh_flutter/components/LoadingWidget.dart';
import 'package:comfyssh_flutter/components/custom_ui_components.dart';
import 'package:comfyssh_flutter/components/custom_widgets.dart';
import 'package:comfyssh_flutter/components/pop_up.dart';
import 'package:comfyssh_flutter/components/virtual_keyboard.dart';
import 'package:comfyssh_flutter/function.dart';
import 'package:comfyssh_flutter/pages/AboutUs.dart';
import 'package:comfyssh_flutter/pages/Experimental.dart';
import 'package:comfyssh_flutter/pages/IdeaSuggestion.dart';
import 'package:comfyssh_flutter/pages/settings.dart';
import 'package:comfyssh_flutter/pages/splash.dart';
import 'package:comfyssh_flutter/state.dart';
import 'package:comfyssh_flutter/states/CounterModel.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:wiredash/wiredash.dart';
import 'package:xterm/xterm.dart';
import 'dart:io' show Platform;

import 'comfyScript/ComfyButton.dart';
import 'comfyScript/ComfyHorizontalSwipeButton.dart';
import 'comfyScript/ComfyTapButton.dart';
import 'comfyScript/DCmotor.dart';
import 'comfyScript/FullGestureButton.dart';
import 'comfyScript/customInput.dart';
import 'comfyScript/stepperMotor.dart';
import 'components/UniversalVariable.dart';


String nickname = "nickname";String hostname = "hostname";int port = 22;String username = "username";String password = "password";String color = "color";int _selectedIndex = 0; String distro = "distro";
ValueNotifier<int> reloadState = ValueNotifier(0);
String spaceLaunch = '';
Color? currentColor; String? currentColorString;
String buttonName = ''; int buttonSizeX = 1; int buttonSizeY = 1; int buttonPosition = 1; String buttonCommand = 'htop';
String ConnectionCharacter = '!@@@###'; //used for connecting commands together in a string that allows easy extraction
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
  runApp(
    const MyApp());
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
  int bottomBarIndex = 0; bool FloatingButtonTip = false;
  final List<Widget> pageLists = [
    Padding(
      padding: const EdgeInsets.only(top:43),
      child: FutureBuilder(
        future: updateSpaceList('comfySpace.db'),
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
            if(snapshot.data.length !=0){
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
            else{
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Such emptiness... ", style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 24),),
                  /*FloatingActionButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    tooltip: 'Add New Space',
                    child: const Icon(Icons.add),
                    onPressed: (){
                      showDialog(context: context, builder: (BuildContext context){
                        return const NewSpaceDialog();
                      });
                    },
                  )*/
                ],
              ),);
            }

          }
          else{
            return Center(child: Text("loading database"));
          }

        },
      ),
    ),
    WiredashSettingPage(),
    WiredashIdeaPage(),
    AboutUs(),
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
  Future<void> countingSpace() async{
    var lists = await countSpace('comfySpace.db');
    print(lists[0]['count(*)'].toString());
    if (lists[0]['count(*)'] == 0){
      FloatingButtonTip = true;
    }
    else{
      FloatingButtonTip = false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
        bottomNavigationBar: Container(
          child: Container(
            color: Color(0xff211F26),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, top:20.0, bottom: 20.0, right: 20.0),
              child: SafeArea(
                child: GNav(
                  color: Theme.of(context).colorScheme.secondaryContainer, activeColor: Theme.of(context).colorScheme.secondary,
                  curve: Curves.linear,
                  tabBackgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  tabActiveBorder: Border.all(color: Theme.of(context).colorScheme.onSecondaryContainer, width: 1), tabBorderRadius: 40.0, iconSize: 30.0,
                  padding: const EdgeInsets.all(12),
                  tabs: const [
                    GButton(icon: Icons.home),
                    GButton(icon: Icons.settings, ),
                    GButton(icon: Icons.lightbulb ),
                    GButton(icon: Icons.public, ),
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
        ),
        appBar: AppBar(
          titleSpacing: 20,
          automaticallyImplyLeading: false,
          title: GestureDetector(
            onTap: (){
              showDialog(context: context, builder: (BuildContext context){
                return const Credit();
              });
            },
              child: Text('ComfySpace', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 24),)),
          elevation: 0,
          //actionsIconTheme: const IconThemeData(size: 30, opacity: 10.0),
          actions: <Widget>[
            //Text(context.watch<CounterModel>().count.toString()),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                child: Icon(Icons.feedback_outlined),
                onTap: (){ Wiredash.of(context).show(); },
              ),
            ),

          ],
        ),
        //floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: (bottomBarIndex != 0 )? null:
        FloatingActionButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
          ),
          tooltip: 'Add New Space',
          child: const Icon(Icons.add),
          onPressed: () {
            //final counter = context.read<CounterModel>();
            //counter.increment();
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

class WireDashComfySpacePage extends StatelessWidget {
  const WireDashComfySpacePage({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: WireDashInfo(),
        builder: (context, AsyncSnapshot<List<String>> snapshot){
      if(snapshot.hasData){
        print(snapshot.data);
        return Wiredash(
            projectId: snapshot.data![0], secret: snapshot.data![1],
            child: comfySpace()
        );
      }
      else{
        print("no data");
        return Wiredash(projectId: 'feedbacktest-s5yadlk', secret: 'lful0I9yhcgriPKd-MTEY2LBGv1pM3C_',
            child: comfySpace()
        );
      }
    });
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
  late String projectID; late String secretCode; bool TerminalShow = true;
  List<DraggableGridItem> ButtonList =[];
  @override
  void initState(){
    super.initState();
    initControl();
  }
  @override
  void dispose(){
    super.dispose();
    clientControl.close();
  }
  Future<void> initControl() async{
    clientControl = SSHClient(
      await SSHSocket.connect(widget.hostname, port),
      username: widget.username,
      onPasswordRequest: () => widget.password,
    );
    print("${clientControl.username} is ready");
  }
  void CreateButtonList(List<Map<dynamic, dynamic>> buttonList){
    ButtonList.clear();
    for (final button in buttonList){
      DraggableGridItem buttonPlacement = DraggableGridItem(
        dragCallback: (context, bool){print("dragged");},
          isDraggable: true,
        child: GestureDetector(
            child: ButtonSorting(button["id"], button["name"], button["buttonType"], widget.spaceName, widget.hostname, widget.username, widget.password, button["command"], terminal),
            /*onLongPress: (){
              showDialog(context: context, builder: (BuildContext context){
                return AlertDialog(
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  contentPadding: const EdgeInsets.all(20.0),
                  title: Text('Delete Button'),
                  actions: [
                    CancelButtonPrompt(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                    deleteButtonPrompt(
                      onPressed: (){
                        setState(() {
                          deleteButton('comfySpace.db', widget.spaceName, button["name"], button["id"]);
                        });
                        Navigator.pop(context);
                      },
                    )
                  ],
                );});
            }*/ ),
      );
      ButtonList.add(buttonPlacement);
  }
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(//uncomment mediaquery for windows build
          endDrawer: Drawer(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 14.0, top:14.0),
                      child: Text('Add Buttons', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),),
                    ),
                    SizedBox(height: 10,),
                    ExpansionTile(
                      iconColor: Theme.of(context).colorScheme.onPrimary,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      collapsedBackgroundColor: Theme.of(context).colorScheme.secondary,
                      textColor: Theme.of(context).colorScheme.onPrimary,
                        title: Text('Component Button', style: GoogleFonts.poppins(fontSize: 20),),
                      children: [
                        AddLEDButton(spaceName: widget.spaceName),
                        AddComfyStepperMotor(spaceName: widget.spaceName),
                        AddComfyDCMotor(spaceName: widget.spaceName),
                        AddComfyDistanceSensor(spaceName: widget.spaceName),
                        AddBuzzerButton(spaceName: widget.spaceName),
                      ],
                    ),
                    ExpansionTile(
                      iconColor: Theme.of(context).colorScheme.onPrimary,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      collapsedBackgroundColor: Theme.of(context).colorScheme.secondary,
                      textColor: Theme.of(context).colorScheme.onPrimary,
                      title: Text('Gesture Button', style: GoogleFonts.poppins(fontSize: 20),),
                      children: [
                        AddComfyTapButton(spaceName: widget.spaceName),
                        AddComfyHorizontalSwipeButton(spaceName: widget.spaceName),
                        AddComfyVerticalSwipeButton(spaceName: widget.spaceName),
                        AddComfyToggleButton(spaceName: widget.spaceName),
                        AddComfyFullGestureButton(spaceName: widget.spaceName),
                        AddComfyDataButton(spaceName: widget.spaceName),

                    ],),
                    Align(
                      alignment: FractionalOffset.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ButtonDocumentation()
                      ),
                    )
                  ],
                ),
              ),
            )
          ),

          appBar: //(MediaQuery.of(context).orientation == Orientation.landscape && Theme.of(context).platform != TargetPlatform.windows && Theme.of(context).platform != TargetPlatform.linux )? null :
          PreferredSize(
              preferredSize: const Size.fromHeight(64),
              child: comfyAppBar(
                endDrawer: true,
                IsSpacePage: true,
                  //automaticallyImplyLeading: true,
                  title: widget.spaceName + context.watch<SpaceEdit>().EditSpaceState.toString()
              )),
          body: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => SpaceEdit())
            ],
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  updateRepoWidget(hostname: widget.hostname, username: widget.username, password: widget.password, terminal: terminal),
                  //(MediaQuery.of(context).orientation == Orientation.landscape && Theme.of(context).platform != TargetPlatform.windows && Theme.of(context).platform != TargetPlatform.linux)? SizedBox(height: 0) :
                  //(MediaQuery.of(context).orientation == Orientation.landscape && Theme.of(context).platform != TargetPlatform.windows && Theme.of(context).platform != TargetPlatform.linux)? SizedBox(height: 0) :
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: Container(
                        color:  Theme.of(context).colorScheme.onSecondaryContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              //collapsedBackgroundColor: Theme.of(context).colorScheme.primaryContainer,
                              //backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                              initiallyExpanded: true,
                              title: const Text("Terminal"),
                              onExpansionChanged: (bool expanded){
                                  TerminalShow = expanded;
                                  print(TerminalShow);
                              },
                              children: [
                                SizedBox(
                                    height: 120,
                                    child: TerminalView(
                                        terminal, readOnly: true, padding: const EdgeInsets.all(16.0),
                                        textStyle: const TerminalStyle(
                                          fontSize: 16.0,
                                          fontFamily: 'poppins',
                                        ),
                                        theme: TerminalTheme(
                                          cursor: Theme.of(context).colorScheme.onSecondaryContainer,
                                          selection: Colors.black,
                                          foreground: Colors.black,
                                          background: Theme.of(context).colorScheme.onSecondaryContainer,
                                          white: Colors.white, red: Colors.red, green: Colors.green, yellow: Colors.yellow, blue: Colors.blue,
                                          magenta: Colors.white, cyan: Colors.cyan, brightBlack: Colors.black38, brightBlue: Colors.blue, brightRed: Colors.redAccent,
                                          brightGreen: Colors.greenAccent, brightCyan: Colors.cyanAccent, brightMagenta: Colors.purpleAccent, brightWhite: Colors.white30,
                                          brightYellow: Colors.yellowAccent, searchHitBackground: Colors.white30, searchHitBackgroundCurrent: Colors.white30, searchHitForeground: Colors.black, black: Colors.black38,
                                        )
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  //(MediaQuery.of(context).orientation == Orientation.landscape && Theme.of(context).platform != TargetPlatform.windows && Theme.of(context).platform != TargetPlatform.linux)? SizedBox(height: 0) :
                  Expanded(
                    child: FutureBuilder(
                        future: buttonRenderer('comfySpace.db', widget.spaceName),
                        builder: (context, snapshot) {
                          /*if (snapshot.connectionState == ConnectionState.done){
                            CreateButtonList(snapshot.data!);
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: DraggableGridViewBuilder(

                                dragChildWhenDragging: (ButtonList, int index){
                                  return PlaceHolderWidget(child: Container(width: 50, color: Colors.red,));
                                },
                                dragPlaceHolder: (ButtonList, int index){
                                  return PlaceHolderWidget(child: Container(width: 50, color: Colors.yellow,));
                                },
                                dragCompletion: (ButtonList, int beforeIndex, int afterIndex){
                                  print("before $beforeIndex after $afterIndex");
                                },
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 3),
                                ),
                                children: ButtonList,
                              )
                            );

                          }
                          else{
                            return const CircularProgressIndicator();
                          }*/
                          return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: PopulateButton(context),
                                  ),
                                  itemCount: snapshot.data?.length,
                                  itemBuilder: (BuildContext context, index){
                                    return ComfyButton(buttonName: snapshot.data![index]["name"], id: snapshot.data![index]["id"], spaceName: widget.spaceName, command: snapshot.data![index]["command"], buttonType: snapshot.data![index]["buttonType"], hostname: widget.hostname, username: widget.username, password: widget.password, terminal: terminal);
                                    /*
                                    if (snapshot.data![index]["buttonType"] == "LED"){
                                      /*return GestureDetector(
                                          onLongPress: (){
                                            showDialog(context: context, builder: (BuildContext context){
                                              print(snapshot.data![index]["id"]);
                                              return AlertDialog(
                                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                contentPadding: const EdgeInsets.all(8.0),
                                                title: Text('Delete Button'),
                                                actions: [
                                                  CancelButtonPrompt(
                                                    onPressed: (){
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  deleteButtonPrompt(
                                                    onPressed: () {
                                                      setState(() {
                                                        deleteButton('comfySpace.db', widget.spaceName, snapshot.data![index]["name"], snapshot.data![index]["id"]);
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  )
                                                ],
                                              );
                                            });
                                          },
                                          child: LedToggle(spaceName: widget.spaceName, name: snapshot.data![index]["name"], pin: snapshot.data![index]["command"], id: snapshot.data![index]["id"], hostname: widget.hostname, username: widget.username, password: widget.password,terminal: terminal));*/
                                      return ComfyButton(buttonName: snapshot.data![index]["name"], id: snapshot.data![index]["id"], spaceName: widget.spaceName, command: snapshot.data![index]["command"], buttonType: snapshot.data![index]["buttonType"], hostname: widget.hostname, username: widget.username, password: widget.password, terminal: terminal);

                                    }
                                    else if (snapshot.data![index]["buttonType"] == "servo"){
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
                                          showDialog(context: context, builder: (BuildContext context){
                                            return AlertDialog(
                                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                              contentPadding: const EdgeInsets.all(20.0),
                                              title: Text('Delete Button'),
                                              actions: [
                                                CancelButtonPrompt(
                                                  onPressed: (){
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                deleteButtonPrompt(
                                                  onPressed: () {
                                                    setState(() {
                                                      deleteButton('comfySpace.db', widget.spaceName, snapshot.data![index]["name"], snapshot.data![index]["id"]);
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                        },
                                        child: StepperMotor(name: snapshot.data![index]["name"], id: snapshot.data![index]["id"] ,pin1: pinList[0], pin2: pinList[1], pin3: pinList[2], pin4: pinList[3], hostname: widget.hostname, username: widget.username, password: widget.password),
                                      );
                                    }
                                    else if (snapshot.data![index]["buttonType"] == "HCSR04"){
                                      List<String> pinList = snapshot.data![index]["command"].split(" ");
                                      return GestureDetector(
                                          onLongPress: (){
                                            showDialog(context: context, builder: (BuildContext context){
                                              return AlertDialog(
                                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                contentPadding: const EdgeInsets.all(20.0),
                                                title: Text('Delete Button'),
                                                actions: [
                                                  CancelButtonPrompt(
                                                    onPressed: (){
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  deleteButtonPrompt(
                                                    onPressed: () {
                                                      setState(() {
                                                        deleteButton('comfySpace.db', widget.spaceName, snapshot.data![index]["name"], snapshot.data![index]["id"]);
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  )
                                                ],
                                              );
                                            });
                                          },
                                          child: CustomInputButton(name: snapshot.data![index]["name"], hostname: widget.hostname, username: widget.username, password: widget.password, commandIn: 'python3 comfyScript/distance_sensor/HC-SR04.py ${pinList[0]} ${pinList[1]} 1', terminal: terminal,)
                                        //child: DistanceSensor(spaceName: widget.spaceName, name: snapshot.data![index]["name"], id: snapshot.data![index]["id"], hostname: widget.hostname, username: widget.username, password: widget.password, trig: pinList[0], echo: pinList[1]),
                                      );
                                    }
                                    else if (snapshot.data![index]["buttonType"] == "DCMotor"){
                                      List<String> pinList = snapshot.data![index]["command"].split(" ");
                                      return GestureDetector(
                                        onLongPress: (){
                                          showDialog(context: context, builder: (BuildContext context){
                                            return AlertDialog(
                                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                              contentPadding: const EdgeInsets.all(20.0),
                                              title: Text('Delete Button'),
                                              actions: [
                                                CancelButtonPrompt(
                                                  onPressed: (){
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                deleteButtonPrompt(
                                                  onPressed: () {
                                                    setState(() {
                                                      deleteButton('comfySpace.db', widget.spaceName, snapshot.data![index]["name"], snapshot.data![index]["id"]);
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                        },
                                        child: DCMotorSingle(name: snapshot.data![index]["name"], id: snapshot.data![index]["id"] ,pin1: pinList[0], pin2: pinList[1], hostname: widget.hostname, username: widget.username, password: widget.password),
                                      );
                                    }
                                    else if (snapshot.data![index]["buttonType"] == "ComfyData"){
                                      return GestureDetector(
                                        onLongPress: (){
                                          showDialog(context: context, builder: (BuildContext context){
                                            return AlertDialog(
                                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                              contentPadding: const EdgeInsets.all(20.0),
                                              title: Text('Delete Button'),
                                              actions: [
                                                CancelButtonPrompt(
                                                  onPressed: (){
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                deleteButtonPrompt(
                                                  onPressed: () {
                                                    setState(() {
                                                      deleteButton('comfySpace.db', widget.spaceName, snapshot.data![index]["name"], snapshot.data![index]["id"]);
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                        },
                                        child: CustomInputButton(name: snapshot.data![index]["name"], hostname: widget.hostname, username: widget.username, password: widget.password, commandIn: snapshot.data![index]["command"], terminal: terminal),
                                      );
                                    }
                                    else if (snapshot.data![index]["buttonType"] == "ComfyToggleButton"){
                                      return GestureDetector(
                                        onLongPress: (){
                                          showDialog(context: context, builder: (BuildContext context){
                                            return AlertDialog(
                                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                              contentPadding: const EdgeInsets.all(20.0),
                                              title: Text('Delete Button'),
                                              actions: [
                                                CancelButtonPrompt(
                                                  onPressed: (){
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                deleteButtonPrompt(
                                                  onPressed: () {
                                                    setState(() {
                                                      deleteButton('comfySpace.db', widget.spaceName, snapshot.data![index]["name"], snapshot.data![index]["id"]);
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                        },
                                        child: ComfyToggleButton(name: snapshot.data![index]["name"], hostname: widget.hostname, username: widget.username, password: widget.password, commandOn: CommandExtract(snapshot.data![index]["command"])[0],commandOff: CommandExtract(snapshot.data![index]["command"])[1], terminal: terminal),
                                      );
                                    }
                                    else if (snapshot.data![index]["buttonType"] == "ComfyVerticalButton"){
                                      return GestureDetector(
                                        onLongPress: (){
                                          showDialog(context: context, builder: (BuildContext context){
                                            return AlertDialog(
                                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                              contentPadding: const EdgeInsets.all(20.0),
                                              title: Text('Delete Button'),
                                              actions: [
                                                CancelButtonPrompt(
                                                  onPressed: (){
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                deleteButtonPrompt(
                                                  onPressed: () {
                                                    setState(() {
                                                      deleteButton('comfySpace.db', widget.spaceName, snapshot.data![index]["name"], snapshot.data![index]["id"]);
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                        },
                                        child: ComfyVerticalButton(name: snapshot.data![index]["name"], hostname: widget.hostname, username: widget.username, password: widget.password, up: CommandExtract(snapshot.data![index]["command"])[0], middle: CommandExtract(snapshot.data![index]["command"])[1], down: CommandExtract(snapshot.data![index]["command"])[2] ),
                                      );
                                    }
                                    else if (snapshot.data![index]["buttonType"] == "ComfyHorizontalButton"){
                                      return GestureDetector(
                                        onLongPress: (){
                                          showDialog(context: context, builder: (BuildContext context){
                                            return AlertDialog(
                                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                              contentPadding: const EdgeInsets.all(20.0),
                                              title: Text('Delete Button'),
                                              actions: [
                                                CancelButtonPrompt(
                                                  onPressed: (){
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                deleteButtonPrompt(
                                                  onPressed: () {
                                                    setState(() {
                                                      deleteButton('comfySpace.db', widget.spaceName, snapshot.data![index]["name"], snapshot.data![index]["id"]);
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                        },
                                        child: ComfyHorizontalButton(name: snapshot.data![index]["name"], hostname: widget.hostname, username: widget.username, password: widget.password, left: CommandExtract(snapshot.data![index]["command"])[0], middle: CommandExtract(snapshot.data![index]["command"])[1], right: CommandExtract(snapshot.data![index]["command"])[2] ),
                                      );
                                    }
                                    else if (snapshot.data![index]["buttonType"] == "ComfyFullGestureButton"){
                                      return GestureDetector(
                                        onLongPress: (){
                                          showDialog(context: context, builder: (BuildContext context){
                                            return AlertDialog(
                                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                              contentPadding: const EdgeInsets.all(20.0),
                                              title: Text('Delete Button'),
                                              actions: [
                                                CancelButtonPrompt(
                                                  onPressed: (){
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                deleteButtonPrompt(
                                                  onPressed: () {
                                                    setState(() {
                                                      deleteButton('comfySpace.db', widget.spaceName, snapshot.data![index]["name"], snapshot.data![index]["id"]);
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                        },
                                        child: ComfyFullGestureButton(name: snapshot.data![index]["name"], hostname: widget.hostname, username: widget.username, password: widget.password, middle: CommandExtract(snapshot.data![index]["command"])[0], left: CommandExtract(snapshot.data![index]["command"])[1], right: CommandExtract(snapshot.data![index]["command"])[2], up: CommandExtract(snapshot.data![index]["command"])[3], down: CommandExtract(snapshot.data![index]["command"])[4] ),
                                      );
                                    }
                                    else if (snapshot.data![index]["buttonType"] == "ComfyTapButton"){
                                      //return CustomToggleButton(name: snapshot.data![index]["name"], hostname: widget.hostname, username: widget.username, password: widget.password, commandOn: snapshot.data![index]["command"], commandOff: snapshot.data![index]["command"], terminal: terminal);
                                      return GestureDetector(
                                        onLongPress: (){
                                          showDialog(context: context, builder: (BuildContext context){
                                            return AlertDialog(
                                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                              contentPadding: const EdgeInsets.all(20.0),
                                              title: Text('Delete Button'),
                                              actions: [
                                                CancelButtonPrompt(
                                                  onPressed: (){
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                deleteButtonPrompt(
                                                  onPressed: () {
                                                    setState(() {
                                                      deleteButton('comfySpace.db', widget.spaceName, snapshot.data![index]["name"], snapshot.data![index]["id"]);
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                        },
                                        child: SinglePressButton(name: snapshot.data![index]["name"], hostname: widget.hostname, username: widget.username, password: widget.password, command: snapshot.data![index]["command"], terminal: terminal),
                                      );
                                    }
                                    else if (snapshot.data![index]["buttonType"] == "Buzzer"){
                                      return GestureDetector(
                                          onLongPress: (){
                                            showDialog(context: context, builder: (BuildContext context){
                                              print(snapshot.data![index]["id"]);
                                              return AlertDialog(
                                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                contentPadding: const EdgeInsets.all(8.0),
                                                title: Text('Delete Button'),
                                                actions: [
                                                  CancelButtonPrompt(
                                                    onPressed: (){
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  deleteButtonPrompt(
                                                    onPressed: () {
                                                      setState(() {
                                                        deleteButton('comfySpace.db', widget.spaceName, snapshot.data![index]["name"], snapshot.data![index]["id"]);
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  )
                                                ],
                                              );
                                            });
                                          },
                                          child: BuzzerToggle(spaceName: widget.spaceName, name: snapshot.data![index]["name"], pin: snapshot.data![index]["command"], id: snapshot.data![index]["id"], hostname: widget.hostname, username: widget.username, password: widget.password,terminal: terminal));

                                    }
                                    else{
                                      return GestureDetector(
                                        onLongPress: (){
                                          showDialog(context: context, builder: (BuildContext context){
                                            return AlertDialog(
                                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                              contentPadding: const EdgeInsets.all(20.0),
                                              title: Text('Delete Button'),
                                              actions: [
                                                CancelButtonPrompt(
                                                  onPressed: (){
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                deleteButtonPrompt(
                                                  onPressed: () {
                                                    setState(() {
                                                      deleteButton('comfySpace.db', widget.spaceName, snapshot.data![index]["name"], snapshot.data![index]["id"]);
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                        },
                                        child: ListTile(
                                          title: Text(snapshot.data![index]["name"]),
                                          subtitle: Text('Unknown button type'),
                                        )
                                      );
                                    }
                                    */
                                  }),
                            );

                        }
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}

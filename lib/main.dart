import 'dart:async';
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:comfyssh_flutter/comfyScript/Buzzer.dart';
import 'package:comfyssh_flutter/comfyScript/ComfyToggleButton.dart';
import 'package:comfyssh_flutter/comfyScript/ComfyVerticalSwipeButton.dart';
import 'package:comfyssh_flutter/comfyVoice/ComfyVoice.dart';
import 'package:comfyssh_flutter/comfyScript/CustomButton.dart';
import 'package:comfyssh_flutter/comfyScript/LED.dart';
import 'package:comfyssh_flutter/comfyScript/statemanagement.dart';
import 'package:comfyssh_flutter/comfyScript/updateRepo.dart';
import 'package:comfyssh_flutter/comfyVoice/ComfyVoiceDB.dart';
import 'package:comfyssh_flutter/components/CameraView.dart';
import 'package:comfyssh_flutter/components/DocumentationButton.dart';
import 'package:comfyssh_flutter/components/custom_ui_components.dart';
import 'package:comfyssh_flutter/components/custom_widgets.dart';
import 'package:comfyssh_flutter/components/pop_up.dart';
import 'package:comfyssh_flutter/components/virtual_keyboard.dart';
import 'package:comfyssh_flutter/function.dart';
import 'package:comfyssh_flutter/pages/AboutUs.dart';
import 'package:comfyssh_flutter/pages/IDE.dart';
import 'package:comfyssh_flutter/pages/IdeaSuggestion.dart';
import 'package:comfyssh_flutter/pages/NetworkScan.dart';
import 'package:comfyssh_flutter/pages/settings.dart';
import 'package:comfyssh_flutter/pages/splash.dart';
import 'package:comfyssh_flutter/states/ExperimentalToggleModel.dart';
import 'package:dart_ping_ios/dart_ping_ios.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:network_tools/network_tools.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screen_recorder/screen_recorder.dart';
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
import 'comfyScript/terminal.dart';


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
late List<CameraDescription> _cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //_cameras = await availableCameras();

  memoryCheck();
  //final appDocDirectory = await getApplicationDocumentsDirectory();
  //await configureNetworkTools(appDocDirectory.path, enableDebugging: true);
  //sqfliteFfiInit();
  //databaseFactory = databaseFactoryFfi;

  if (Platform.isWindows){
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  reAssign();
  DartPingIOS.register();
  runApp(
    const MyApp());
  createHostInfo();
  CreateVoicePromptDB('comfySpace.db');
}  //main function, execute MyApp

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
            return const Center(child: Text("loading database"));
          }

        },
      ),
    ),
    //const WiredashSettingPage(),
    const WiredashIdeaPage(),
    ComfyIDE(),
    const AboutUs(),
  ];
  final List<GButton> BottomBarButtonList = [
    GButton(icon: Icons.home, text: 'Home'),
    //GButton(icon: Icons.settings, ),
    GButton(icon: Icons.lightbulb, text: 'Experimental'),
    GButton(icon: Icons.text_fields, text: 'Snippet'),
    GButton(icon: Icons.public, text: 'Documentation'),
  ];

  final List<Widget> ExperimentalPageLists = [
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
            return const Center(child: Text("loading database"));
          }

        },
      ),
    ),
    const NetworkScanPage(),
    //const WiredashSettingPage(),
    const WiredashIdeaPage(),
    const AboutUs(),
  ];
  final List<GButton> ExperimentalBottomBarButtonList = [
    GButton(icon: Icons.home, text: ' Home'),
    GButton(icon: Icons.network_ping),
    //GButton(icon: Icons.settings, ),
    GButton(icon: Icons.lightbulb ),
    GButton(icon: Icons.public, ),
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context)=> ExperimentalToggleModel(),
        ),
      ],
      child: Scaffold(
        //floatingActionButtonLocation: FloatingActionButtonLocation.end,
        backgroundColor: Theme.of(context).colorScheme.background,
          bottomNavigationBar: Container(
            color: const Color(0xff717D96),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, top:20.0, bottom: 20.0, right: 20.0),
              child: SafeArea(
                child: GNav(
                  duration: Duration(milliseconds: 300),
                  mainAxisAlignment: MainAxisAlignment.start,
                  gap: 8,
                  color: Color(0xffE2E7F0),
                  //Theme.of(context).colorScheme.secondaryContainer,
                  activeColor: Color(0xffB0DCFFB0DCFF),
                  //Theme.of(context).colorScheme.secondary,
                  curve: Curves.linear,
                  tabBackgroundColor: Colors.blue,
                  //Theme.of(context).colorScheme.onSecondaryContainer,

                  //backgroundColor: Color(0xff717D96),

                  //Theme.of(context).colorScheme.surfaceVariant,
                  /*tabActiveBorder: Border.all(
                      color: Color(0xffD1FFD9),
                      //Theme.of(context).colorScheme.onSecondaryContainer,
                      width: 1),*/
                  tabBorderRadius: 30.0, iconSize: 30.0,
                  padding: const EdgeInsets.all(12),
                  tabs:
                  //(context.watch<ExperimentalToggleModel>().Experimental == true)?
                  BottomBarButtonList,
                      //:BottomBarButtonList,
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
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
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
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  child: const Icon(Icons.feedback_outlined),
                  onTap: (){ Wiredash.of(context).show(); },
                ),
              ),

            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
          floatingActionButton: (bottomBarIndex != 0 )? null:
          FloatingActionButton(
            //backgroundColor: Color(0xffFFD43A),
            //foregroundColor: Colors.black,
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
              }
              ); },

          ),
          body:
          //(context.watch<ExperimentalToggleModel>().Experimental == true)? ExperimentalPageLists[bottomBarIndex] :
          pageLists[bottomBarIndex],
      ),
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
            child: const comfySpace()
        );
      }
      else{
        print("no data");
        return const Wiredash(projectId: 'feedbacktest-s5yadlk', secret: 'lful0I9yhcgriPKd-MTEY2LBGv1pM3C_',
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

  Terminal terminal = Terminal(
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
        ),
      );
      ButtonList.add(buttonPlacement);
  }
  }

  @override
  Widget build(BuildContext context) {
    ScreenRecorderController _screenrecordctrl = ScreenRecorderController(pixelRatio: 0.5, skipFramesBetweenCaptures: 2);
    return ScreenRecorder(
      width: double.infinity, height: double.infinity,
      controller: _screenrecordctrl,
      child: PopScope(
          canPop: false,
          child: Scaffold(//uncomment mediaquery for windows build
            backgroundColor: Color(0xff717D96),
            floatingActionButton: ComfyVoice(
              spaceName: widget.spaceName, terminal: terminal,
              hostname: widget.hostname, username: widget.username, password: widget.password,
            ),
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
                      const SizedBox(height: 10,),
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
                          //AddCustomComfyGestureButton(spaceName: widget.spaceName),
                      ],),
                      //AddComfyVoiceButton(spaceName: widget.spaceName),
                      Row(
                        children: [
                          AddComfyVoiceButton(spaceName: widget.spaceName),
                          const Align(
                            alignment: FractionalOffset.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: ButtonDocumentation()
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ),
            appBar: //(MediaQuery.of(context).orientation == Orientation.landscape && Theme.of(context).platform != TargetPlatform.windows && Theme.of(context).platform != TargetPlatform.linux )? null :
            PreferredSize(
              preferredSize: Size.fromHeight(64.0),
              child: comfyAppBar(
                endDrawer: true,
                IsSpacePage: true,
                  titleWidget: updateRepoWidget(hostname: widget.hostname, username: widget.username, password: widget.password, terminal: terminal, spacename: widget.spaceName,),
                  //automaticallyImplyLeading: true,
                  title: widget.spaceName + context.watch<SpaceEdit>().EditSpaceState.toString()
              ),
            ),
            body: MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (context) => SpaceEdit())
              ],
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [//uncomment updaterepowidget after  testing
                    //updateRepoWidget(hostname: widget.hostname, username: widget.username, password: widget.password, terminal: terminal),
                    //(MediaQuery.of(context).orientation == Orientation.landscape && Theme.of(context).platform != TargetPlatform.windows && Theme.of(context).platform != TargetPlatform.linux)? SizedBox(height: 0) :
                    //(MediaQuery.of(context).orientation == Orientation.landscape && Theme.of(context).platform != TargetPlatform.windows && Theme.of(context).platform != TargetPlatform.linux)? SizedBox(height: 0) :
                    //CameraView(camera: _cameras[0]),

                    ComfyTerminal(terminal: terminal),
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
      ),
    );
  }
}

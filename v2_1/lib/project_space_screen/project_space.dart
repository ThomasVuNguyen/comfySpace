import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:reorderable_grid/reorderable_grid.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:typewritertext/typewritertext.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/edit_button.dart';
import 'package:v2_1/home_screen/home_screen.dart';
import 'package:v2_1/project_space_screen/button_list/button_global/button_sort.dart';
import 'package:v2_1/project_space_screen/components/add_new_button_screen.dart';
import 'package:v2_1/project_space_screen/components/floating_buttons.dart';
import 'package:v2_1/project_space_screen/components/raspberrypi_setup.dart';
import 'package:v2_1/project_space_screen/function/static_ip_function.dart';
import 'package:v2_1/universal_widget/random_widget_loading.dart';

import '../home_screen/comfy_user_information_function/project_information.dart';

class project_space extends StatefulWidget {
  const project_space({super.key, required this.project_name, required this.hostname, required this.username, required this.password, this.raspberryPiInit = false});
  final String project_name; final String hostname; final String username; final String password; final bool raspberryPiInit;
  @override
  State<project_space> createState() => _project_spaceState();
}

class _project_spaceState extends State<project_space> {


  bool _speechEnabled = false;

  @override
  void initState() {
    print('howdy project');
    acquireStaticIP(widget.hostname, widget.username, widget.password);
    if (kDebugMode) {
      print(widget.project_name);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width~/150;
    return FutureBuilder(
          future: project_space_initialize(context, widget.hostname, widget.username, widget.password, widget.project_name, widget.raspberryPiInit),
          builder: (context, snapshot){
            if(snapshot.connectionState != ConnectionState.done){
              return const Center(child: randomLoadingWidget());
            }
            else {
              if(snapshot.hasError && snapshot.error.toString().contains('No element') == true || snapshot.data == null){
                //print('comfy project snapshot data error: ${snapshot.data.toString()}');
                return Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    leading: IconButton(
                      icon: const Icon(Icons.subdirectory_arrow_left),
                      onPressed: (){
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen(pageIndex: 1,)),
                              (Route<dynamic> route) => false,
                        );
                      },
                    ),
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    title: Text('Welcome, ${widget.project_name}'),
                  ),
                  body: const Center(
                    child: SizedBox(
                      height: 400, width: 200,
                      child: TypeWriterText(
                        text: Text('Welcome to your project!'),
                        duration: Duration(milliseconds: 100),
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                  floatingActionButton: FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => AddNewButtonScreen(
                          projectName: widget.project_name,
                          hostname: widget.hostname,
                          username: widget.username,
                          password: widget.password,
                        )),
                            (Route<dynamic> route) => false,
                      );
                    },

                  ),
                );
              }
              else{
                print('comfy project snapshot data: ${snapshot.data.toString()}');
                String staticIP = '0.0.0.0';
                if(snapshot.data != null){
                  staticIP = snapshot.data![0];
                  if (kDebugMode) {
                    print('static ip is $staticIP');
                  }
                }
                var buttonList = snapshot.data![1];
                Map<String, dynamic> systemInstances = (snapshot.data!.length >2)? snapshot.data![2] :{};
                return Scaffold(
                    appBar:AppBar(
                      automaticallyImplyLeading: false,
                      leading: IconButton(
                        icon: const Icon(Icons.subdirectory_arrow_left),
                        onPressed: (){
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const HomeScreen(pageIndex: 1,),),
                                (Route<dynamic> route) => false,
                          );
                        },
                      ),
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      title: Text('Welcome, ${widget.project_name}'),
                    ),
                    body: Center(
                      child: SafeArea(
                        child: ReorderableGridView.builder(
                            itemCount: buttonList!.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: screenWidth),
                            onReorder: (oldIndex, newIndex) async{
                              if (kDebugMode) {
                                print('$oldIndex swapped with $newIndex');
                              }

                              await SwapButton(oldIndex, newIndex, buttonList, widget.project_name);
                              setState(() {});
                            },
                            itemBuilder: (context, index){
                              return Container(
                                key: Key(buttonList[index].order.toString()),
                                child: button_sort(
                                  button: buttonList[index],
                                  projectName: widget.project_name,
                                  hostname: widget.hostname,
                                  username: widget.username,
                                  password: widget.password,
                                  staticIP: staticIP,
                                  systemInstances: systemInstances,
                                ),
                              );
                            }
                        ),
                      ),
                    ),
                    floatingActionButton: FloatingActionButton(
                      child: Icon(Icons.add),
                      onPressed: (){
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AddNewButtonScreen(
                          projectName: widget.project_name,
                          hostname: widget.hostname,
                          username: widget.username,
                          password: widget.password,
                        )),
                              (Route<dynamic> route) => false,
                        );
                      },
                    )
                );
              }
            }

          }
      );
  }
}

Future<List<dynamic>> project_space_initialize(BuildContext context, String hostname, String username, String password, String projectName, bool raspberryPiInit) async{
  print('initializing project: getting button list & running ssh scripts');
  //start timer
  double beginningTime = DateTime.now().microsecondsSinceEpoch/1000000;
  SpeechToText speechToText = SpeechToText();

  Map<String, dynamic> systemInstances = {};
  //acquire button list
  print('getting button list');
  var results =  await Future.wait(
      [get_button_list_information(context, projectName),
      setUpRaspberryPi(context, hostname, username, password),
      ]
  );
  List<comfy_button> buttonList = results[0] as List<comfy_button>;
  bool voice_required = buttonList.any((button) => button.type == 'ai-chat');
  if(voice_required == true){
    print('ai chat found');
    bool result = await speechToText.initialize(
        onStatus: (status){
          //print('speech init status $status');
        },
        onError: (error){
          //print('error: ${error.errorMsg}');
        }
    );
    //print('voice initialization complete');
    //print(result.toString());
    systemInstances['voice'] = speechToText;
  }
  //List<comfy_button> buttonList = await get_button_list_information(context, projectName);
  print('initializing raspbery pi done');
  // if on web, bypass
  if(kIsWeb){
    return ['web bypass', buttonList, systemInstances];
  }
  //if project screen is loaded from the home screen, run raspberry pi init function

    print('initializing raspbery pi');
    try{
      await setUpRaspberryPi(context, hostname, username, password);
    } catch(e){
      print('error inititalize rapsberry pi: $e');
    }

  print('acquiring static ip');
  //try getting static ip
  String? staticIP = '1.3.0.6';
  try{
    staticIP = await getStaticIp(hostname).timeout(const Duration(seconds: 3));
    print('opening project: static ip is $staticIP');

    double endTime = DateTime.now().microsecondsSinceEpoch/1000000;
    print('time taken to load in project $projectName: ${endTime-beginningTime} ');

    return [staticIP, buttonList, systemInstances];
  } catch(e){

    double endTime = DateTime.now().microsecondsSinceEpoch/1000000;
    print('time taken to load in project $projectName: ${endTime-beginningTime} ');
    print('system instance is $systemInstances');
    return ['comfy space initialize, static ip not found', buttonList, systemInstances];
    // if no static ip found, return a random result
  }





}
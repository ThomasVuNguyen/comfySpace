
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:reorderable_grid/reorderable_grid.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:typewritertext/typewritertext.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/edit_button.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/user_information.dart';
import 'package:v2_1/home_screen/home_screen.dart';
import 'package:v2_1/project_space_screen/button_list/button_global/button_sort.dart';
import 'package:v2_1/project_space_screen/components/add_new_button_screen.dart';
import 'package:v2_1/project_space_screen/components/floating_buttons.dart';
import 'package:v2_1/project_space_screen/components/raspberrypi_setup.dart';
import 'package:v2_1/project_space_screen/function/static_ip_function.dart';

import '../home_screen/comfy_user_information_function/project_information.dart';

class project_space extends StatefulWidget {
  const project_space({super.key, required this.project_name, required this.hostname, required this.username, required this.password});
  final String project_name; final String hostname; final String username; final String password;
  @override
  State<project_space> createState() => _project_spaceState();
}

class _project_spaceState extends State<project_space> {
  @override
  void initState() {
    acquireStaticIP(widget.hostname, widget.username, widget.password);

    if (kDebugMode) {
      print(widget.project_name);
    }
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    var screen_width = MediaQuery.of(context).size.width~/200;
    return FutureBuilder(
          future: project_space_initialize(context, widget.hostname, widget.username, widget.password, widget.project_name),
          builder: (context, snapshot){
            if(snapshot.connectionState != ConnectionState.done){
              return Center(child: CircularProgressIndicator());
            }
            else if(snapshot.hasError){
              if(snapshot.error.toString().contains('No element') == true){
                return Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    leading: IconButton(
                      icon: Icon(Icons.subdirectory_arrow_left),
                      onPressed: (){
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => HomeScreen()),
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
                  floatingActionButton: ExpandableFab(
                    openButtonBuilder: FloatingActionButtonBuilder(
                        size: 56,
                        builder: (BuildContext context, void Function()? onPressed, Animation<double> progress) {
                          return FloatingButton(
                              assetPath: 'assets/component_assets/floating_button/ComfyLogo.png',
                              color: Theme.of(context).colorScheme.primaryContainer);
                        }
                    ),
                    children: [
                      IconButton(
                          onPressed: (){

                          },
                          icon: FloatingButtonIcon(
                            icon: Icons.settings,
                            bgcolor: Theme.of(context).colorScheme.primaryContainer,
                            iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
                          )
                      ),
                      IconButton(
                          onPressed: (){
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
                          icon: FloatingButtonIcon(
                            icon: Icons.add,
                            bgcolor: Theme.of(context).colorScheme.primaryContainer,
                            iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
                          )
                      ),
                    ],
                  ),
                  floatingActionButtonLocation: ExpandableFab.location,
                );
              }
              else{
                return Text(snapshot.error.toString());
              }

            }
            else{
              String staticIP = '0.0.0.0';
              if(snapshot.data != null){
                staticIP = snapshot.data![0];
                if (kDebugMode) {
                  print('static ip is $staticIP');
                }
              }
              var button_list = snapshot.data![1];
              return Scaffold(
                appBar:AppBar(
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                    icon: Icon(Icons.subdirectory_arrow_left),
                    onPressed: (){
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen(),),
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
                        itemCount: button_list!.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: screen_width),
                        onReorder: (oldIndex, newIndex) async{
                          if (kDebugMode) {
                            print('$oldIndex swapped with $newIndex');
                          }

                          await SwapButton(oldIndex, newIndex, button_list, widget.project_name);
                          setState(() {});
                        },
                        itemBuilder: (context, index){
                          return Container(
                            key: Key(button_list[index].order.toString()),
                            child: button_sort(
                              button: button_list[index],
                              projectName: widget.project_name,
                              hostname: widget.hostname,
                              username: widget.username,
                              password: widget.password,
                              staticIP: staticIP,
                            ),
                          );
                        }
                    ),
                  ),
                ),
                floatingActionButton: ExpandableFab(
                  openButtonBuilder: FloatingActionButtonBuilder(
                      size: 56,
                      builder: (BuildContext context, void Function()? onPressed, Animation<double> progress) {
                        return FloatingButton(
                            assetPath: 'assets/component_assets/floating_button/ComfyLogo.png',
                            color: Theme.of(context).colorScheme.primaryContainer);
                      }
                  ),
                  children: [
                    IconButton(
                        onPressed: (){

                        },
                        icon: FloatingButtonIcon(
                          icon: Icons.settings,
                          bgcolor: Theme.of(context).colorScheme.primaryContainer,
                          iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
                        )
                    ),
                    IconButton(
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
                        icon: FloatingButtonIcon(
                          icon: Icons.add,
                          bgcolor: Theme.of(context).colorScheme.primaryContainer,
                          iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
                        )
                    ),
                  ],
                ),
                floatingActionButtonLocation: ExpandableFab.location,
              );
            }
          }

      );
  }
}

Future<List<dynamic>> project_space_initialize(BuildContext context, String hostname, String username, String password, String project_name) async{
  await setUpRaspberryPi(context, hostname, username, password);
  String? staticIP = await getStaticIp(hostname);
  List<comfy_button> button_list = await get_button_list_information(context, project_name);
  if(kIsWeb){
    return ['0.0.0.0', button_list];
  }
  return [staticIP, button_list];

}
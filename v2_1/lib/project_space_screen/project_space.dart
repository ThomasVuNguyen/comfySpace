
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

import '../home_screen/comfy_user_information_function/project_information.dart';

class project_space extends StatefulWidget {
  const project_space({super.key, required this.project_name});
  final String project_name;
  @override
  State<project_space> createState() => _project_spaceState();
}

class _project_spaceState extends State<project_space> {

  @override
  void initState() {
    if (kDebugMode) {
      print(widget.project_name);
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var screen_width = MediaQuery.of(context).size.width~/200;
    return Scaffold(
      appBar:AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.subdirectory_arrow_left),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text('Welcome, ${widget.project_name}'),
      ),
      body: Center(
        child: FutureBuilder(
          future: get_button_list_information(context, widget.project_name),
            builder: (context, snapshot){
            if(snapshot.connectionState != ConnectionState.done){
              return CircularProgressIndicator();
            }
            else if(snapshot.hasError){
              if(snapshot.error.toString().contains('No element') == true){
                return const SizedBox(
                  height: 400, width: 200,
                  child: TypeWriterText(
                    text: Text('Welcome to your project!'),
                    duration: Duration(milliseconds: 100),
                    alignment: Alignment.center,
                  ),
                );
              }
              else{
                return Text(snapshot.error.toString());
              }

            }
            else{
              var button_list = snapshot.data;

              return Center(
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
                          child: button_sort(button: button_list[index],
                            projectName: widget.project_name,
                          ),
                        );
                  }
                  ),
                ),
              );
            }
            }

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
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewButtonScreen(projectName: widget.project_name)));
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

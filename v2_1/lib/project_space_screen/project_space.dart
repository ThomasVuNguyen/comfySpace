import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reorderable_grid/reorderable_grid.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/user_information.dart';
import 'package:v2_1/project_space_screen/button_list/button_global/button_sort.dart';

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
    var screen_width = MediaQuery.of(context).size.width~/5;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text('Welcome, ${widget.project_name}'),
      ),
      body: Center(
        child: FutureBuilder(
          future: get_button_list_information(widget.project_name),
            builder: (context, snapshot){
            if(snapshot.connectionState != ConnectionState.done){
              return CircularProgressIndicator();
            }
            else if(snapshot.hasError){
              return Text(snapshot.error.toString());
            }
            else{
              var button_list = snapshot.data;

              return Center(
                child: SafeArea(
                  child: ReorderableGridView.builder(
                      itemCount: button_list!.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    onReorder: (oldIndex, newIndex){
                        print('old: $oldIndex new: $newIndex');
                        print('old: ${button_list[oldIndex].name}');
                        print('new: ${button_list[newIndex].name}');
                        }
                      ,
                      itemBuilder: (context, index){
                        return Container(
                          key: Key(button_list[index].order.toString()),
                          child: button_sort(button: button_list[index],),
                        );
                  }


                  ),
                ),
              );
            }
            }

        ),
      )
    );
  }
}

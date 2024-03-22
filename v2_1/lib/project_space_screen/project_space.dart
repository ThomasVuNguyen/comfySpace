import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/user_information.dart';

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

    return Scaffold(
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
              return ListView.builder(
                itemCount: button_list?.length,
                  itemBuilder: (context, index){
                  return Text(button_list![index].name!);
                  }
              );
            }
            }

        ),
      )
    );
  }
}

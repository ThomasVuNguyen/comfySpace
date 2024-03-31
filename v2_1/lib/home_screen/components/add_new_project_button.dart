import 'package:flutter/material.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/edit_button.dart';

class add_new_project extends StatelessWidget {
  const add_new_project({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
        onPressed: (){
          AddNewProject();
        }
    );
  }
}

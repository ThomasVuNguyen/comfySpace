import 'package:flutter/material.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/project_information.dart';
import 'package:v2_1/project_space_screen/button_list/comfy_swipe_button.dart';
import 'package:v2_1/project_space_screen/button_list/comfy_tap_button.dart';
import 'package:v2_1/project_space_screen/button_list/comfy_toggle_button.dart';
import 'package:v2_1/project_space_screen/components/button_edit_and_delete_page.dart';

class button_sort extends StatelessWidget {
  const button_sort({super.key, required this.button, required this.projectName});
  final comfy_button button; final String projectName;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Builder(builder: (context){
          switch (button.type){
            case 'tap':
              return comfy_tap_button(button: button);
            case 'toggle':
              return comfy_toggle_button(button: button);
            case 'swipe':
              return comfy_swipe_button(button: button);
            default:
              return Text('unidentified ${button.type}');

          }
        }),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            height: 30, width: 30,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8)
            ),
            padding: EdgeInsets.all(0),
              child: IconButton(onPressed: (){
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ButtonEditAndDeletePage(projectName: projectName, button: button,))
                );
              }, icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.onPrimaryContainer,size: 12,))),
        ),
      ],
    );


  }
}

import 'package:flutter/material.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/project_information.dart';
import 'package:v2_1/project_space_screen/button_list/comfy_swipe_button.dart';
import 'package:v2_1/project_space_screen/button_list/comfy_tap_button.dart';
import 'package:v2_1/project_space_screen/button_list/comfy_toggle_button.dart';

class button_sort extends StatelessWidget {
  const button_sort({super.key, required this.button});
  final comfy_button button;
  @override
  Widget build(BuildContext context) {
    return Builder(
    builder: (context){
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
      },
      );
  }
}

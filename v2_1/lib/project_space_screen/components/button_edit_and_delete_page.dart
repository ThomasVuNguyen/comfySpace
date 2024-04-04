import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../project_space.dart';

class ButtonEditAndDeletePage extends StatefulWidget {
  const ButtonEditAndDeletePage({super.key,
    required this.projectName,
    required this.buttonName,
  });
  final String projectName;  final String buttonName;
  @override
  State<ButtonEditAndDeletePage> createState() => _ButtonEditAndDeletePageState();
}

class _ButtonEditAndDeletePageState extends State<ButtonEditAndDeletePage> {
  bool _showSelectionScreen = true;
  bool _pickButtonTypeAndName = false;
  bool _pickCommands = false;
  bool _pickTheme = false;
  bool _confirmationPage = false;

  final buttonTypeController = TextEditingController();
  final buttonNameController = TextEditingController();
  final buttonColorController = TextEditingController();
  final buttonThemeController = TextEditingController();

  //controller for tap button
  final tapCommandTextController = TextEditingController();

  //controller for toggle buttons
  final toggleOnCommandTextController = TextEditingController();
  final toggleOffCommandTextController = TextEditingController();

  //controller for swipe buttons
  final swipeUpCommandTextController = TextEditingController();
  final swipeDownCommandTextController = TextEditingController();
  final swipeLeftCommandTextController = TextEditingController();
  final swipeRightCommandTextController = TextEditingController();
  final swipeTapCommandTextController = TextEditingController();


  Future<void> navigate() async {
    if(_confirmationPage == false){
      if(_showSelectionScreen == true){
        setState(() {
          _showSelectionScreen = false;
          _pickButtonTypeAndName = true;
          _pickCommands = false;
          _pickTheme = false;
          _confirmationPage = false;
        });
      }
      else if(_pickButtonTypeAndName == true){
        if(buttonNameController.text.isEmpty || buttonTypeController.text.isEmpty){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Button name & type cannot be empty')));
        }
        else{
          setState(() {
            _showSelectionScreen = false;
            _pickButtonTypeAndName = false;
            _pickCommands = true;
            _pickTheme = false;
            _confirmationPage = false;
          });
        }

      }
      else if(_pickCommands == true){
        setState(() {
          _showSelectionScreen = false;
          _pickButtonTypeAndName = false;
          _pickCommands = false;
          _pickTheme = true;
          _confirmationPage = false;
        });

      }
      else if(_pickTheme == true){
        setState(() {
          _showSelectionScreen = false;
          _pickButtonTypeAndName = false;
          _pickCommands = false;
          _pickTheme = false;
          _confirmationPage = true;
        });

      }

    }
    else{
      if(kDebugMode){
        print('adding button');
      }
      if(buttonTypeController.text.toLowerCase()=='tap'){
        buttonFunction = {
          'tap': tapCommandTextController.text
        };
      }
      else if(buttonTypeController.text.toLowerCase()=='toggle'){
        buttonFunction = {
          'on': toggleOnCommandTextController.text,
          'off': toggleOffCommandTextController.text,
        };
      }
      else if(buttonTypeController.text.toLowerCase()=='swipe'){
        buttonFunction = {
          'up': swipeUpCommandTextController.text,
          'down': swipeDownCommandTextController.text,
          'tap': swipeTapCommandTextController.text,
          'left': swipeLeftCommandTextController.text,
          'right': swipeRightCommandTextController.text,
        };
      }
      /*await AddNewButton(widget.projectName,
          buttonTypeController.text.toLowerCase(),
          buttonNameController.text,
          buttonFunction,
          buttonColorController.text.toLowerCase(),
          buttonThemeController.text.toLowerCase());*/
      Navigator.push(context, MaterialPageRoute(builder: (context) => project_space(project_name: widget.projectName)));
    }

  }

  //placeholder for button function map
  Map<String, String> buttonFunction = {};
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

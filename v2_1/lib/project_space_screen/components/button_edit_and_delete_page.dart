import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/delete_button.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/edit_button.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/project_information.dart';
import 'package:v2_1/home_screen/components/set_user_info.dart';
import 'package:v2_1/project_space_screen/components/ButtonCommandCreatePage.dart';

import '../project_space.dart';

class ButtonEditAndDeletePage extends StatefulWidget {
  const ButtonEditAndDeletePage({super.key,
    required this.projectName,
    required this.button,
    required this.hostname, required this.username, required this.password
  });
  final String projectName;  final comfy_button button;
  final String hostname; final String username; final String password;
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
        if(buttonThemeController.text.isEmpty || buttonColorController.text.isEmpty){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Theme & Color cannot be empty')));
        }
        else{
          setState(() {
            _showSelectionScreen = false;
            _pickButtonTypeAndName = false;
            _pickCommands = false;
            _pickTheme = false;
            _confirmationPage = true;
          });
        }
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
      await edit_button(context, widget.projectName, widget.button.name!,
          buttonNameController.text, buttonTypeController.text.toLowerCase(),
          buttonColorController.text.toLowerCase(), buttonFunction);
      Navigator.push(context, MaterialPageRoute(builder: (context) => project_space(
          project_name: widget.projectName,
        hostname: widget.hostname,
        username: widget.username,
        password: widget.password,
      )));
    }

  }

  //placeholder for button function map
  Map<String, String> buttonFunction = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Page 1: Edit or Delete button?
            Visibility(
              visible: _showSelectionScreen,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () async {
                        await delete_button(context, widget.projectName, widget.button.name!);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => project_space(
                            project_name: widget.projectName,
                          hostname: widget.hostname,
                          username: widget.username,
                          password: widget.password,
                        )));
                        },
                      icon: const Text('Delete')),
                  Gap(40),
                  IconButton(onPressed: navigate, icon: const Text('Edit button'))
                ],
              ),
            ),
            //Page 2: Pick button name and type
            Visibility(
                visible: _pickButtonTypeAndName,
                child: in_app_textfield(
                  controller: buttonNameController,
                  hintText: '', obsureText: false,
                  titleText: 'Button Name',
                  initialValue: widget.button.name!,
                )
            ),
            const Gap(20),
            Visibility(
                visible: _pickButtonTypeAndName,
                child: DropdownMenu(
                  initialSelection: widget.button.type,
                  label: const Text('Pick a button Type'),
                  enableSearch: true,
                  enableFilter: true,
                  controller: buttonTypeController,
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(value: 'tap', label: 'tap'),
                    DropdownMenuEntry(value: 'toggle', label: 'toggle'),
                    DropdownMenuEntry(value: 'swipe', label: 'swipe')
                  ],
                )
            ),

            //Page 3: Pick commands
            Visibility(
              visible: _pickCommands,
              child: ButtonCommandCreatePage(
              buttonType: buttonTypeController.text.toLowerCase(),
              buttonFunction: widget.button.function!,
              tapCommandTextController: tapCommandTextController,

              toggleOnCommandTextController: toggleOnCommandTextController,
              toggleOffCommandTextController: toggleOffCommandTextController,

              swipeUpCommandTextController: swipeUpCommandTextController,
              swipeDownCommandTextController: swipeDownCommandTextController,
              swipeLeftCommandTextController: swipeLeftCommandTextController,
              swipeRightCommandTextController: swipeRightCommandTextController,
              swipeTapCommandTextController: swipeTapCommandTextController,
            ),
            ),

            //Page4: Pick theme & color
            Visibility(
                visible: _pickTheme,
                child: DropdownMenu(
                  initialSelection: widget.button.color,
                  controller: buttonColorController,
                  enableSearch: true, enableFilter: true,
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(value: 'red', label: 'Red'),
                    DropdownMenuEntry(value: 'green', label: 'Green'),
                    DropdownMenuEntry(value: 'blue', label: 'Blue')
                  ],
                )
            ),
            const Gap(20),
            Visibility(
                visible: _pickTheme,
                child: DropdownMenu(
                  controller: buttonThemeController,
                  enableSearch: true, enableFilter: true,
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(value: 'froggie', label: 'Froggie'),
                    DropdownMenuEntry(value: 'classic', label: 'classic'),
                  ],
                )
            ),
            //Navigation button
            Gap(40),
            Visibility(
              visible: !_showSelectionScreen,
                child: IconButton(onPressed: navigate, icon: const Icon(Icons.arrow_circle_right_outlined),))

          ],
        ),
      ),
    );
  }
}

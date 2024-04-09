import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/add_button.dart';
import 'package:v2_1/home_screen/components/set_user_info.dart';
import 'package:v2_1/project_space_screen/components/ButtonCommandCreatePage.dart';
import 'package:v2_1/project_space_screen/project_space.dart';

class AddNewButtonScreen extends StatefulWidget {
  const AddNewButtonScreen({super.key,
    required this.projectName, required this.hostname, required this.username, required this.password
  });
  final String projectName;
  final String hostname; final String username; final String password;
  @override
  State<AddNewButtonScreen> createState() => _AddNewButtonScreenState();
}

class _AddNewButtonScreenState extends State<AddNewButtonScreen> {
  bool _showWelcomeScreen = true;
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

  //placeholder for button function map
  Map<String, String> buttonFunction = {};

  Future<void> navigate() async {
    if(_confirmationPage == false){
        if(_showWelcomeScreen == true){
          setState(() {
            _showWelcomeScreen = false;
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
              _showWelcomeScreen = false;
              _pickButtonTypeAndName = false;
              _pickCommands = true;
              _pickTheme = false;
              _confirmationPage = false;
            });
          }

        }
        else if(_pickCommands == true){
          setState(() {
            _showWelcomeScreen = false;
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
              _showWelcomeScreen = false;
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
      await AddNewButton(widget.projectName,
          buttonTypeController.text.toLowerCase(),
          buttonNameController.text,
          buttonFunction,
          buttonColorController.text.toLowerCase(),
          buttonThemeController.text.toLowerCase());
      Navigator.pop(context);
      /*Navigator.push(context, MaterialPageRoute(builder: (context) => project_space(
          project_name: widget.projectName,
        hostname: widget.hostname,
        username: widget.username,
        password: widget.password,
      )));*/
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Page 1: Welcome screen
            Visibility(
              visible: _showWelcomeScreen,
                child: Text('Welcome to buttons!')
            ),
            const Gap(20),

            //Page 2: Pick button type & name
            Visibility(
              visible: _pickButtonTypeAndName,
                child: DropdownMenu(
                  label: Text('Pick a button Type'),
                  enableSearch: true,
                  enableFilter: true,
                  controller: buttonTypeController,
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(value: 'tap', label: 'Tap'),
                    DropdownMenuEntry(value: 'toggle', label: 'Toggle'),
                    DropdownMenuEntry(value: 'swipe', label: 'Swipe')
                  ],
                )
            ),
            const Gap(20),
            Visibility(
              visible: _pickButtonTypeAndName,
                child: in_app_textfield(
              controller: buttonNameController,
              hintText: 'LED Control', obsureText: false, titleText: 'Name your button',
            )),

            //Page 3: Pick a command
            Visibility(
              visible: _pickCommands,
                child: ButtonCommandCreatePage(
                  buttonType: buttonTypeController.text.toLowerCase(),
                  tapCommandTextController: tapCommandTextController,

                  toggleOnCommandTextController: toggleOnCommandTextController,
                  toggleOffCommandTextController: toggleOffCommandTextController,

                  swipeUpCommandTextController: swipeUpCommandTextController,
                  swipeDownCommandTextController: swipeDownCommandTextController,
                  swipeLeftCommandTextController: swipeLeftCommandTextController,
                  swipeRightCommandTextController: swipeRightCommandTextController,
                  swipeTapCommandTextController: swipeTapCommandTextController,
                )
            ),
            const Gap(20),

            //Page4: Pick theme & color
            Visibility(
              visible: _pickTheme,
                child: DropdownMenu(
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

            //Page 5: Confirmation screen

            Visibility(
              visible: _confirmationPage,
                child: Text('Button added')),
            //Navigation Button
            const Gap(40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.assignment_return)),
                IconButton(onPressed: () { navigate();}, icon: const Icon(Icons.arrow_right))
              ],
            )


          ],
        ),
      ),
    );
  }
}


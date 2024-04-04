import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/add_button.dart';
import 'package:v2_1/home_screen/components/set_user_info.dart';
import 'package:v2_1/project_space_screen/project_space.dart';

class AddNewButtonScreen extends StatefulWidget {
  const AddNewButtonScreen({super.key,
    required this.projectName
  });
  final String projectName;

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

  Future<void> navigate() async {
    if(_confirmationPage == false){
      setState(() {
        if(_showWelcomeScreen == true){
          _showWelcomeScreen = false;
          _pickButtonTypeAndName = true;
          _pickCommands = false;
          _pickTheme = false;
          _confirmationPage = false;
        }
        else if(_pickButtonTypeAndName == true){
          _showWelcomeScreen = false;
          _pickButtonTypeAndName = false;
          _pickCommands = true;
          _pickTheme = false;
          _confirmationPage = false;
        }
        else if(_pickCommands == true){
          _showWelcomeScreen = false;
          _pickButtonTypeAndName = false;
          _pickCommands = false;
          _pickTheme = true;
          _confirmationPage = false;
        }
        else if(_pickTheme == true){
          _showWelcomeScreen = false;
          _pickButtonTypeAndName = false;
          _pickCommands = false;
          _pickTheme = false;
          _confirmationPage = true;
        }
      });
    }
    else{
      if(kDebugMode){
        print('adding button');
      }
      await AddNewButton(widget.projectName,
          buttonTypeController.text.toLowerCase(),
          buttonNameController.text,
          {'tap': 'comfy led 17 1'},
          buttonColorController.text.toLowerCase(),
          buttonThemeController.text.toLowerCase());
      Navigator.push(context, MaterialPageRoute(builder: (context) => project_space(project_name: widget.projectName)));
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
                child: const Text('Pick command')
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

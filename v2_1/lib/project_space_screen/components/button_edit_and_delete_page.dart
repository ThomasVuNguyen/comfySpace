import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/delete_button.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/edit_button.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/project_information.dart';
import 'package:v2_1/home_screen/components/set_user_info.dart';
import 'package:v2_1/project_space_screen/components/ButtonCommandCreatePage.dart';
import 'package:v2_1/universal_widget/buttons.dart';

import '../../home_screen/comfy_user_information_function/color_conversion.dart';
import '../button_list/button_global/button_sort.dart';
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

  //controller for ai buttons
  final AIButtonTextController = TextEditingController();


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
          'tap': (tapCommandTextController.text.isEmpty == true)? '':tapCommandTextController.text
        };
      }
      else if(buttonTypeController.text.toLowerCase()=='toggle'){
        buttonFunction = {
          'on': (toggleOnCommandTextController.text.isEmpty == true)? '': toggleOnCommandTextController.text,
          'off': ( toggleOffCommandTextController.text.isEmpty == true)? '': toggleOffCommandTextController.text,
        };
      }
      else if(buttonTypeController.text.toLowerCase()=='swipe'){
        buttonFunction = {
          'up': (swipeUpCommandTextController.text.isEmpty == true)? '': swipeUpCommandTextController.text,
          'down': (swipeDownCommandTextController.text.isEmpty == true)? '': swipeDownCommandTextController.text,
          'tap': (swipeTapCommandTextController.text.isEmpty == true)? '':swipeTapCommandTextController.text,
          'left': (swipeLeftCommandTextController.text.isEmpty == true)? '':swipeLeftCommandTextController.text,
          'right': (swipeRightCommandTextController.text.isEmpty == true)? '' :swipeRightCommandTextController.text,
          'api': (AIButtonTextController.text.isEmpty == true)? '': AIButtonTextController.text
        };
      }
      await edit_button(context, widget.projectName, widget.button.name!,
          buttonNameController.text, buttonTypeController.text.toLowerCase(),
          buttonColorController.text.toLowerCase(), buttonFunction, buttonThemeController.text.toLowerCase());
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => project_space(
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
    buttonThemeController.text = 'froggie';
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //preview of button
            Builder(builder: (context) {
              String btnName = (widget.button.name == null)? 'button name' :widget.button.name!;
              String type = (widget.button.type == null)? 'tap' :widget.button.type!;
              int order = 1;
              Map<String, String> function = (widget.button.function == null)?
              {
                'on': '',
                'off': '',
                'tap': '',
                'up': '',
                'down': '',
                'left': '',
                'right': ''
              }:
                  widget.button.function!
              ;
              Color color = (widget.button.color == null)?  Theme.of(context).colorScheme.onSurface: widget.button.color!;

              if (buttonNameController.text != '') {
                btnName = buttonNameController.text;
              }
              if (buttonTypeController.text != '') {
                type = buttonTypeController.text.toLowerCase();
              }
              if(buttonColorController.text != ''){
                color = colorConversion(context, buttonColorController.text.toLowerCase());
              }
              return Container(
                padding: const EdgeInsets.all(20),
                width: 240, height: 240,
                child: button_sort(
                    button: comfy_button(
                        btnName, type, color, order, function
                    ),
                    projectName: '',
                    hostname: '',
                    staticIP: '',
                    username: '',
                    password: ''),
              );

            }),
            //Page 1: Edit or Delete button?
            Visibility(
              visible: _showSelectionScreen,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: AnimatedTextKit(
                    isRepeatingAnimation: false,
                    animatedTexts: [
                      TypewriterAnimatedText(
                          'Would you like to delete or edit a button?',
                          textAlign: TextAlign.center, textStyle: Theme.of(context).textTheme.titleMedium,
                          speed: const Duration(milliseconds: 100)
                      ),
                    ],
                    onTap: () {
                    },
                  ),
                ),
            ),
            Visibility(
              visible: _showSelectionScreen,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  clickable_text(text: 'Delete button', onTap: () async {
                await delete_button(context, widget.projectName, widget.button.name!).then((value) =>
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => project_space(
                      project_name: widget.projectName,
                      hostname: widget.hostname,
                      username: widget.username,
                      password: widget.password,
                    ))));
              },),
                  clickable(icon: Icons.cancel, onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => project_space(project_name: widget.projectName, hostname: widget.hostname, username: widget.username, password: widget.password)));
                  }),
                  clickable_text(text: 'Edit button', onTap: navigate)
                  //IconButton(onPressed: navigate, icon: const Text('Edit button'))
                ],
              ),
            ),
            //Page 2: Pick button name and typ
            Visibility(
              visible: _pickButtonTypeAndName,
              child: //Text('Welcome to buttons!')
              AnimatedTextKit(
                isRepeatingAnimation: false,
                animatedTexts: [
                  TypewriterAnimatedText(
                      'Pick a new name?',
                      textAlign: TextAlign.center, textStyle: Theme.of(context).textTheme.titleMedium,
                      speed: const Duration(milliseconds: 100)
                  ),
                ],
                onTap: () {
                },
              ),
            ),
            Visibility(visible: _pickButtonTypeAndName, child: const Gap(20)),
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
                  textStyle: Theme.of(context).textTheme.titleMedium,
                  width: MediaQuery.of(context).size.width*2/3,
                  initialSelection: widget.button.type,
                  label: Text('Pick a button Type', style: Theme.of(context).textTheme.titleMedium,),
                  //enableSearch: true,
                  //enableFilter: true,
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
              buttonFunction: {
                'on': (widget.button.function?['on'] == null)? '' :widget.button.function!['on']!,
                'off': (widget.button.function?['off'] == null)? '' :widget.button.function!['off']!,
                'tap': (widget.button.function?['tap'] == null)? '' :widget.button.function!['tap']!,
                'up': (widget.button.function?['up'] == null)? '' :widget.button.function!['up']!,
                'down': (widget.button.function?['down'] == null)? '' :widget.button.function!['down']!,
                'left': (widget.button.function?['left'] == null)? '' :widget.button.function!['left']!,
                'right': (widget.button.function?['right'] == null)? '' :widget.button.function!['right']!,
                'api': ((widget.button.function)?['api'] == null)? '':widget.button.function!['']!,
              },

              tapCommandTextController: tapCommandTextController,

              toggleOnCommandTextController: toggleOnCommandTextController,
              toggleOffCommandTextController: toggleOffCommandTextController,

              swipeUpCommandTextController: swipeUpCommandTextController,
              swipeDownCommandTextController: swipeDownCommandTextController,
              swipeLeftCommandTextController: swipeLeftCommandTextController,
              swipeRightCommandTextController: swipeRightCommandTextController,
              swipeTapCommandTextController: swipeTapCommandTextController, aiAPIButtonTextController:AIButtonTextController,
            ),
            ),

            //Page4: Pick theme & color
            Visibility(
                visible: _pickTheme,
                child: DropdownMenu(
                  textStyle: Theme.of(context).textTheme.titleMedium,
                  width: MediaQuery.of(context).size.width*2/3,
                  label: Text('Pick a color', style: Theme.of(context).textTheme.titleMedium,),
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
                visible: false,
                //_pickTheme,
                child: DropdownMenu(
                  textStyle: Theme.of(context).textTheme.titleMedium,
                  width: MediaQuery.of(context).size.width*2/3,
                  label: Text('Pick a theme', style: Theme.of(context).textTheme.titleMedium,),

                  controller: buttonThemeController,
                  enableSearch: true, enableFilter: true,
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(value: 'froggie', label: 'Froggie'),
                    DropdownMenuEntry(value: 'classic', label: 'classic'),
                  ],
                )
            ),

            //Page 5: confirmation page

            Visibility(
              visible: _confirmationPage,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: AnimatedTextKit(
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    TypewriterAnimatedText(
                        'Here is your new button!',
                        textAlign: TextAlign.center, textStyle: Theme.of(context).textTheme.titleMedium,
                        speed: const Duration(milliseconds: 100)
                    ),
                  ],
                  onTap: () {
                  },
                ),
              ),
            ),
            //Navigation button
            const Gap(40),
            Visibility(
              visible: !_showSelectionScreen,
                child:
                //IconButton(onPressed: navigate, icon: const Icon(Icons.arrow_circle_right_outlined),)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  clickable(
                    icon: Icons.cancel,
                    onTap: (){
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => project_space(
                          project_name: widget.projectName,
                          hostname: widget.hostname,
                          username: widget.username,
                          password: widget.password,
                        )),
                            (Route<dynamic> route) => false,
                      );
                    },
                  ),
                  clickable(icon: Icons.arrow_forward, onTap: navigate)
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}

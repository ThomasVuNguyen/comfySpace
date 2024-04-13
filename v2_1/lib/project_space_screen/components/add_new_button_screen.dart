import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/add_button.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/color_conversion.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/project_information.dart';
import 'package:v2_1/home_screen/components/set_user_info.dart';
import 'package:v2_1/project_space_screen/button_list/button_global/button_sort.dart';
import 'package:v2_1/project_space_screen/components/ButtonCommandCreatePage.dart';
import 'package:v2_1/project_space_screen/project_space.dart';
import 'package:v2_1/universal_widget/buttons.dart';

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
          if(
          //buttonThemeController.text.isEmpty ||
              buttonColorController.text.isEmpty){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Color cannot be empty')));
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

      if(buttonThemeController.text.isEmpty){
        buttonThemeController.text = 'froggie';
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
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Titles:
                Visibility(
                    visible: _pickCommands,
                    child: Text(
                        'Pick a button command',
                        style: Theme.of(context).textTheme.titleLarge
                            //?.copyWith(color: Theme.of(context).colorScheme.tertiary)
                      )),
                Visibility(
                    visible: _pickTheme,
                    child: Text(
                        'Pick a color',
                        style: Theme.of(context).textTheme.titleLarge
                      //?.copyWith(color: Theme.of(context).colorScheme.tertiary)
                    )),
                Visibility(
                    visible: _confirmationPage,
                    child: AnimatedTextKit(
                      isRepeatingAnimation: false,
                      animatedTexts: [
                        TypewriterAnimatedText(
                            'Your new button is created!',
                            textAlign: TextAlign.center, textStyle: Theme.of(context).textTheme.titleMedium,
                            speed: const Duration(milliseconds: 100)
                        ),
                        TypewriterAnimatedText(
                            'Click next to continue',
                            textAlign: TextAlign.center, textStyle: Theme.of(context).textTheme.titleMedium,
                            speed: const Duration(milliseconds: 100)
                        ),
                      ],
                      onTap: () {
                      },
                    ),
                ),
          
                //Page 1: Welcome screen
                Visibility(
                  visible: _showWelcomeScreen,
                    child: //Text('Welcome to buttons!')
                    AnimatedTextKit(
              isRepeatingAnimation: false,
              animatedTexts: [
                TypewriterAnimatedText(
                    'Let\s create a button!',
                    textAlign: TextAlign.center, textStyle: Theme.of(context).textTheme.titleMedium,
                    speed: const Duration(milliseconds: 100)
                ),
                TypewriterAnimatedText(
                    'Click next to continue',
                    textAlign: TextAlign.center, textStyle: Theme.of(context).textTheme.titleMedium,
                    speed: const Duration(milliseconds: 100)
                ),
              ],
              onTap: () {
              },
            ),
                ),
                Visibility(visible: _showWelcomeScreen, child: const Gap(20)),
                // button previews
                Builder(builder: (context) {
                  String btnName = 'name me, buddy';
                  String type = 'toggle';
                  int order = 1;
                  Map<String, String> function = {
                    'on': '',
                    'off': '',
                    'tap': '',
                    'up': '',
                    'down': '',
                    'left': '',
                    'right': ''
                  };
                  Color color = Theme.of(context).colorScheme.onBackground;
          
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
                      padding: EdgeInsets.all(20),
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
                Visibility(visible: _showWelcomeScreen, child: const Gap(20)),
          
                //Page 2: Pick button type & name
                Visibility(
                  visible: _pickButtonTypeAndName,
                    child: in_app_textfield(
                  controller: buttonNameController,
                  hintText: 'LED Control', obsureText: false, titleText: 'Name your button',
                )),
                Visibility(visible: _pickButtonTypeAndName, child: const Gap(20)),
                Visibility(
                    visible: _pickButtonTypeAndName,
                    child:
                  DropdownMenu(
                      textStyle: Theme.of(context).textTheme.titleMedium,
                      width: MediaQuery.of(context).size.width*2/3,
                      label: Text('Pick a button Type', style: Theme.of(context).textTheme.titleMedium,),
                      enableSearch: true,
                      //enableFilter: true,
                      controller: buttonTypeController,
                      dropdownMenuEntries: const [
                        DropdownMenuEntry(value: 'tap', label: 'Tap'),
                        DropdownMenuEntry(value: 'toggle', label: 'Toggle'),
                        DropdownMenuEntry(value: 'swipe', label: 'Swipe')
                      ],
                    )
                ),
                Visibility(
                    visible: _pickButtonTypeAndName,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                          'hint: Pick a gesture you resonate with!',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    )
                ),
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
                Visibility(visible: _pickButtonTypeAndName, child: const Gap(20)),
          
                //Page4: Pick theme & color
                Visibility(
                  visible: _pickTheme,
                    child: DropdownMenu(
                      textStyle: Theme.of(context).textTheme.titleMedium,
                      width: MediaQuery.of(context).size.width*2/3,
                      label: Text('Pick a color', style: Theme.of(context).textTheme.titleMedium,),
                      controller: buttonColorController,
                      enableSearch: true, //enableFilter: true,
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
                      initialSelection: 'froggie',
                      controller:buttonThemeController,
                      enableSearch: true, //enableFilter: true,
                      dropdownMenuEntries: const [
                        DropdownMenuEntry(value: 'froggie', label: 'Froggie'),
                        DropdownMenuEntry(value: 'classic', label: 'classic'),
                      ],
                    )
                ),
          
                //Page 5: Confirmation screen
                
                //Navigation Button
                const Gap(40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    /*IconButton(onPressed: (){
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
                      }, icon: const Icon(Icons.assignment_return)),*/
                    //IconButton(onPressed: () { navigate();}, icon: const Icon(Icons.arrow_right))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


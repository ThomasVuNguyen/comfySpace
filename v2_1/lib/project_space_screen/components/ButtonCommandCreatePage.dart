
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:v2_1/home_screen/components/set_user_info.dart';
//conditionally render a button command creation page
class ButtonCommandCreatePage extends StatefulWidget {
  const ButtonCommandCreatePage({super.key,
    required this.buttonType,

    required this.tapCommandTextController,

    required this.toggleOnCommandTextController,
    required this.toggleOffCommandTextController,

    required this.swipeUpCommandTextController,
    required this.swipeDownCommandTextController,
    required this.swipeLeftCommandTextController,
    required this.swipeRightCommandTextController,
    required this.swipeTapCommandTextController,

    this.buttonFunction = const {},


  });
  final String buttonType;
  //controller for tap button
  final TextEditingController tapCommandTextController;

  //controller for toggle buttons
  final TextEditingController toggleOnCommandTextController;
  final TextEditingController toggleOffCommandTextController;

  //controller for swipe buttons
  final TextEditingController swipeUpCommandTextController;
  final TextEditingController swipeDownCommandTextController;
  final TextEditingController swipeLeftCommandTextController;
  final TextEditingController swipeRightCommandTextController;
  final TextEditingController swipeTapCommandTextController;

  //store existing button data for editing buttons
  final Map<String, String> buttonFunction;
  @override
  State<ButtonCommandCreatePage> createState() => _ButtonCommandCreatePageState();
}

class _ButtonCommandCreatePageState extends State<ButtonCommandCreatePage> {

  @override
  void initState() {
    //if editing a button, pre-fill the fields
    if(widget.buttonType == 'tap' && widget.buttonFunction.isNotEmpty){
      widget.tapCommandTextController.text = widget.buttonFunction['tap']!;
    }
    else if(widget.buttonType == 'toggle' && widget.buttonFunction.isNotEmpty ){
      widget.toggleOnCommandTextController.text = widget.buttonFunction['on']!;
      widget.toggleOffCommandTextController.text = widget.buttonFunction['off']!;
    }
    else if(widget.buttonType == 'swipe' && widget.buttonFunction.isNotEmpty ){
      widget.swipeUpCommandTextController.text = widget.buttonFunction['up']!;
      widget.swipeDownCommandTextController.text = widget.buttonFunction['down']!;
      widget.swipeLeftCommandTextController.text = widget.buttonFunction['left']!;
      widget.swipeRightCommandTextController.text = widget.buttonFunction['right']!;
      widget.swipeTapCommandTextController.text = widget.buttonFunction['tap']!;
    }

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context){
      if(widget.buttonType == 'tap'){
        return in_app_textfield(
          controller: widget.tapCommandTextController,
          hintText: '', obsureText: false, titleText: 'Tap command',
        );
      }
      else if(widget.buttonType == 'toggle'){
        return Column(
          children: [
            in_app_textfield(
              controller: widget.toggleOnCommandTextController,
              hintText: '', obsureText: false, titleText: 'Toggle on command',
            ),
            Gap(20),
            in_app_textfield(
                controller: widget.toggleOffCommandTextController,
                hintText: '',
                obsureText: false,
                titleText: 'Toggle off command'),
          ],
        );
      }
      else if(widget.buttonType == 'swipe'){
        return Column(
          children: [
            in_app_textfield(
              controller: widget.swipeUpCommandTextController,
              hintText: '', obsureText: false, titleText: 'Swipe up command',
            ),
                in_app_textfield(
                  maxWidth: 100,
                  controller: widget.swipeLeftCommandTextController,
                  hintText: '', obsureText: false, titleText: 'Swipe left command',
                ),
                Gap(20),
                in_app_textfield(
                  maxWidth: 100,
                  controller: widget.swipeTapCommandTextController,
                  hintText: '', obsureText: false, titleText: 'Swipe tap command',
                ),
                Gap(20),
                in_app_textfield(
                  maxWidth: 100,
                  controller: widget.swipeRightCommandTextController,
                  hintText: '', obsureText: false, titleText: 'Swipe right command',
                ),
            Gap(20),
            in_app_textfield(
                controller: widget.swipeDownCommandTextController,
                hintText: '',
                obsureText: false,
                titleText: 'Swipe down command'),
          ],
        );
      }
      else{
        return Center(child: Text('Button type unknown ${widget.buttonType}'),);
      }
    });
  }
}

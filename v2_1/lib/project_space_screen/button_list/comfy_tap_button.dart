import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/project_information.dart';
import 'package:v2_1/project_space_screen/button_list/button_global/variables.dart';

import '../../home_screen/comfy_user_information_function/project_information.dart';

class comfy_tap_button extends StatefulWidget {
  const comfy_tap_button({super.key, required this.button});
  final comfy_button button;

  @override
  State<comfy_tap_button> createState() => _comfy_tap_buttonState();
}

class _comfy_tap_buttonState extends State<comfy_tap_button> {
  bool _status = false;

  void onClick(){
    HapticFeedback.heavyImpact();
    SystemSound.play(SystemSoundType.click);
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details){
        onClick();
        setState(
            () {
              _status = !_status;
            }
        );
      },
        onTapUp: (details) async {
          onClick();
          if(_status){
            print('tap up');
            await Future.delayed(Duration(milliseconds: 100));
            setState(() {
              _status =false;
            });
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xFFDAEED7),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: widget.button.color!
                        //Theme.of(context).colorScheme.onBackground
                            , width: 2)
                    ),

                  ),
                ),
                Container(
                  child: Builder(
                      builder: (context){
                        if(_status==true) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 25, right: 25, bottom: 45),
                            child: Image.asset('assets/froggie/tap-on.png',),
                          );
                        }
                        else{
                          return Padding(
                            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 45, top: 20),
                            child: Image.asset('assets/froggie/tap-off.png', fit: BoxFit.fill,),
                          );
                        }}
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    widget.button.name!,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ],
            )
        )
      );

  }
}

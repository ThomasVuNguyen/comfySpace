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
            await Future.delayed(Duration(milliseconds: 50));
            setState(() {
              _status =false;
            });
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          child: Stack(
            children: [
              Padding(
                padding: _status?
                const EdgeInsets.only(
                    top: 10, bottom: 10, left: 10, right: 10
                ): EdgeInsets.all(
                    20
                ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Theme.of(context).colorScheme.secondary,
                    ),
                  )
              ),
              Padding(
                padding: const EdgeInsets.all(
                  20
                ),
                child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                      color:Theme.of(context).colorScheme.onBackground
                  ),
                  borderRadius: button_border,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6)
                      )),
                      child: Center(
                        child: Text(
                          widget.button.name!,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ),
                    Container(height: 2, color: Colors.black,),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: widget.button.color,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(6),
                            bottomRight: Radius.circular(6)
                          )
                        ),
                      ),
                    )
                  ],
                ),
                            ),
              ),

            ]
          ),
        )
      );

  }
}

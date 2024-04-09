import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../home_screen/comfy_user_information_function/project_information.dart';
import 'button_global/variables.dart';

class comfy_swipe_button extends StatefulWidget {
  const comfy_swipe_button({super.key, required this.button});
  final comfy_button button;

  @override
  State<comfy_swipe_button> createState() => _comfy_swipe_buttonState();
}

class _comfy_swipe_buttonState extends State<comfy_swipe_button> {
  bool _status = false;
  late SSHClient sshClient;

  void onClick(){
    HapticFeedback.heavyImpact();
    SystemSound.play(SystemSoundType.click);
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
          onClick();
          setState(
                  () {
                _status = !_status;
              }
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          child: Stack(
              children: [
                Padding(
                    padding: EdgeInsets.all(20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Theme.of(context).colorScheme.secondary,
                      ),


                    )
                ),
                Padding(
                  padding: _status?
                  const EdgeInsets.only(
                      top: 30, bottom: 30, left: 30, right: 30
                  ): EdgeInsets.all(
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
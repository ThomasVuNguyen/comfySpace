import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/project_information.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/unsplash/generate_image.dart';
import 'package:v2_1/project_space_screen/button_list/button_global/variables.dart';

import '../../home_screen/comfy_user_information_function/project_information.dart';

class comfy_tap_button extends StatefulWidget {
  const comfy_tap_button({super.key, required this.button, required this.hostname, required this.staticIP, required this.username, required this.password});
  final comfy_button button; final String hostname; final String username; final String password; final String staticIP;

  @override
  State<comfy_tap_button> createState() => _comfy_tap_buttonState();
}

class _comfy_tap_buttonState extends State<comfy_tap_button> {
  bool _status = false;
  late SSHClient sshClient;

  @override
  void initState(){
    initClient();
    super.initState();
  }
  @override
  void dispose(){
    try{
      sshClient.close();
    } catch (e){

    }

    super.dispose();
  }

  @override
  void deactivate(){
    try{
      sshClient.close();
    } catch (e){

    }
    super.deactivate();
  }
  Future<void> initClient() async{
    for(String potentialHostName in [widget.staticIP.trim(), widget.hostname]){
      try{
        sshClient = SSHClient(
          await SSHSocket.connect(potentialHostName, 22),
          username: widget.username,
          onPasswordRequest: () => widget.password,
        );
        //attempt a connection
        await sshClient.execute('echo hi');
        print('ssh connection successfully created with hostname $potentialHostName');
        break;

      }
      catch (e){
        //if all hostname tested and not working, report!
        if(potentialHostName == widget.hostname){
          //SSH connection not made
          //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error connecting to $potentialHostName: $e}')));
        }
      }
    }
  }
  Future<void> onClick() async {
    HapticFeedback.heavyImpact();
    SystemSound.play(SystemSoundType.click);
    await sshClient.run(widget.button.function!['tap']!);
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) async{
        await onClick();
        setState(
            () {
              _status = !_status;
            }
        );
      },
        onTapUp: (details) async {
          await onClick();
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

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

import '../../home_screen/comfy_user_information_function/project_information.dart';
import 'button_global/variables.dart';

class comfy_swipe_button extends StatefulWidget {
  const comfy_swipe_button({super.key, required this.button,
    required this.hostname, required this.staticIP, required this.username, required this.password,
    this.swipeUpImg = 'assets/froggie/swipe up.png',  this.swipeDownImg = 'assets/froggie/swipe down.png',
    this.swipeLeftImg = 'assets/froggie/swipe left.png', this.swipeRightImg = 'assets/froggie/swipe right.png',
  });
  final comfy_button button; final String hostname; final String username; final String password; final String staticIP;
  final String swipeUpImg; final String swipeDownImg; final String swipeLeftImg; final String swipeRightImg;
  @override
  State<comfy_swipe_button> createState() => _comfy_swipe_buttonState();
}

class _comfy_swipe_buttonState extends State<comfy_swipe_button> {
  String _direction = 'tap'; int index = 0;
  // tap: 0, left: 1, right:2, down: 3, up: 4
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
        try{
          sshClient.close();
        } catch (e){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('error disposing: $e')));
        }
      }
      catch (e){
        //if all hostname tested and not working, report!
        if(potentialHostName == widget.hostname){
          //SSH not connected
          //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error connecting to $potentialHostName: $e}')));
        }
      }
    }
  }

  Future<void> onSwipe(String direction) async {
    HapticFeedback.heavyImpact();
    SystemSound.play(SystemSoundType.click);
    if(direction == 'up'){
      await sshClient.run(widget.button.function!['up']!);
    }
    else if(direction == 'down'){
      await sshClient.run(widget.button.function!['down']!);
    }
    else if(direction == 'left'){
      await sshClient.run(widget.button.function!['left']!);
    }
    else if(direction == 'right'){
      await sshClient.run(widget.button.function!['right']!);
    }
    else{
      await sshClient.run(widget.button.function!['tap']!);
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          _direction = 'tap';
        });
        await onSwipe(_direction);
      },
        onVerticalDragUpdate: (dragDetail){
          if(dragDetail.primaryDelta!<0){
            setState((){
              _direction = 'up';
              index=4;
            });
          }
          else if(dragDetail.primaryDelta!>0){
            setState(() {
              _direction = 'down';
              index=3;
            });
          }
        },
        onHorizontalDragUpdate: (dragDetail){
          if(dragDetail.primaryDelta!<0){
            setState((){
              _direction = 'left';
              index=1;
            });
          }
          else if(dragDetail.primaryDelta!>0){
            setState(() {
              _direction = 'right';
              index=2;
            });
          }
        },
        onVerticalDragEnd: (dragDetail) async{
          if(_direction == 'up' || _direction == 'down'){
            await onSwipe(_direction);
          }
        },
        onHorizontalDragEnd: (dragDetail) async{
          if(_direction == 'left' || _direction == 'right'){
            await onSwipe(_direction);
          }
        },
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 50),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xFFDAEED7),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: widget.button.color!, width: 2)
                    ),
                  ),
                ),
                Builder(
                    builder: (context){
                      if(_direction=='up') {
                        return Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25, bottom: 60),
                          child: Image.asset(widget.swipeUpImg,),
                        );
                      }
                      else if(_direction == 'down'){
                        return Padding(
                            padding: const EdgeInsets.only(left: 25, right: 25, bottom: 45),
                          child: Image.asset(widget.swipeDownImg),
                        );
                      }
                      else if(_direction == 'left'){
                        return Padding(
                            padding: const EdgeInsets.only(left: 25, right: 25, bottom: 45),
                          child: Image.asset(widget.swipeLeftImg),
                        );
                      }
                      else if(_direction == 'right'){
                        return Padding(
                            padding: const EdgeInsets.only(left: 25, right: 25, bottom: 45),
                          child: Image.asset(widget.swipeRightImg),
                        );
                      }
                      else{
                        return Padding(
                          padding: EdgeInsets.only(left:15, right: 15, top: 15, bottom: 45),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                RotatedBox(quarterTurns: 3, child: Icon(Iconsax.arrow_right),),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    RotatedBox(quarterTurns: 2, child: Icon(Iconsax.arrow_right),),
                                    Icon(Icons.pause_circle_outline, color: Theme.of(context).colorScheme.primary,size: 40,),
                                    Icon(Iconsax.arrow_right)
                                  ],
                                ),
                                Icon(Icons.swipe_down)
                                //RotatedBox(quarterTurns: 1, child: Icon(Iconsax.arrow_right),),
                              ],
                            ),
                          ),
                        );
                      }
                    }
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
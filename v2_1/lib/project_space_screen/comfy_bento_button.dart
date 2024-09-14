import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:v2_1/themes/app_color.dart';

import '../../home_screen/comfy_user_information_function/project_information.dart';

class comfy_bento_move_button extends StatefulWidget {
  const comfy_bento_move_button({
    super.key,
    required this.motor_id,
    required this.hostname,
    required this.staticIP,
    required this.port,
    required this.username,
    required this.password,
    this.swipeUpImg = 'assets/froggie/swipe up.png',
    this.swipeDownImg = 'assets/froggie/swipe down.png',
    this.swipeLeftImg = 'assets/froggie/swipe left.png',
    this.swipeRightImg = 'assets/froggie/swipe right.png',
  });
  final int motor_id;
  final String hostname;
  final String username;
  final String password;
  final String staticIP;
  final int port;
  final String swipeUpImg;
  final String swipeDownImg;
  final String swipeLeftImg;
  final String swipeRightImg;
  @override
  State<comfy_bento_move_button> createState() =>
      _comfy_bento_move_buttonState();
}

class _comfy_bento_move_buttonState extends State<comfy_bento_move_button> {
  int index = 0;
  // tap: 0, left: 1, right:2, down: 3, up: 4
  late SSHClient sshClient;

  @override
  void initState() {
    initClient();
    super.initState();
  }

  @override
  void dispose() {
    try {
      sshClient.close();
    } catch (e) {
      print('error closing ssh on dispose');
    }

    super.dispose();
  }

  @override
  void deactivate() {
    try {
      sshClient.close();
    } catch (e) {
      print('error closing ssh on deactivate');
    }
    super.deactivate();
  }

  Future<void> initClient() async {
    for (String potentialHostName in [
      widget.staticIP.trim(),
      widget.hostname
    ]) {
      try {
        sshClient = SSHClient(
          await SSHSocket.connect(potentialHostName, widget.port),
          username: widget.username,
          onPasswordRequest: () => widget.password,
        );
        //attempt a connection
        await sshClient.execute('echo hi');
        print(
            'ssh connection successfully created with hostname $potentialHostName');
        break;
      } catch (e) {
        //if all hostname tested and not working, report!
        if (potentialHostName == widget.hostname) {
          //SSH connection not made
          //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error connecting to $potentialHostName: $e}')));
        }
      }
    }
  }
/*
  Future<void> onSwipe(String direction) async {
    print('swipe');
    HapticFeedback.heavyImpact();
    SystemSound.play(SystemSoundType.click);
    if (direction == 'up') {
      //print(widget.button.function!['up']!);
      await sshClient.run(widget.button.function!['up']!);
    } else if (direction == 'down') {
      await sshClient.run(widget.button.function!['down']!);
    } else if (direction == 'left') {
      await sshClient.run(widget.button.function!['left']!);
    } else if (direction == 'right') {
      await sshClient.run(widget.button.function!['right']!);
    } else {
      await sshClient.run(widget.button.function!['tap']!);
    }
  }*/

  @override
  Widget build(BuildContext context) {
    Offset _position = Offset.zero;
    return GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _position += details.delta;
          });
          print('Current position: $_position');
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
                        color: const Color(0xFFDAEED7),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.black, width: 2)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Hi',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ],
            )));
  }
}

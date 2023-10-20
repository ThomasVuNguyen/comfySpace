import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/LoadingWidget.dart';
import '../components/custom_widgets.dart';
import '../main.dart';

String DCMotorSingleRun(String pin1, String pin2, String state1, String state2){
  return "python3 comfyScript/motor/DCmotor_single.py $pin1 $pin2 $state1 $state2 ";
}
class DCMotorSingle extends StatefulWidget {
  const DCMotorSingle({super.key, required this.name, required this.id, required this.pin1, required this.pin2, required this.hostname, required this.username, required this.password});
  final String name; final int id; final String pin1; final String pin2;
  final String hostname; final String username; final String password;
  @override
  State<DCMotorSingle> createState() => _DCMotorSingleState();
}

class _DCMotorSingleState extends State<DCMotorSingle> {
  bool SSHLoadingFinished = false;
  int rotationDirection = 1; //0 means counterclockwise, 1 means stop, 2 means clockwise
  final List<bool> _DCState = <bool>[true, false];
  late SSHClient client;
  int index = 0;
  String direction = 'pause'; //either pause, forward or backward
  List<Widget> motorIcon = [Icon(Icons.pause_circle_filled, size: 60,), Icon(Icons.arrow_upward, size: 60), Icon(Icons.arrow_downward, size:60)];
  List<Color> motorColor = [const Color.fromARGB(44, 164, 167, 189),Colors.red,Colors.red];
  @override
  void initState(){
    super.initState();
    initClient();
  }
  @override
  void dispose(){
    closeClient();
    client.close();
    super.dispose();
  }
  Future<void> initClient() async{
    client = SSHClient(
      await SSHSocket.connect(widget.hostname, 22),
      username: widget.username,
      onPasswordRequest: () => widget.password,
    );
    print("initClient username: ${client.username}");
    setState(() {SSHLoadingFinished = true;});
  }
  Future<void> closeClient() async{
    final shell = await client.shell();
    await shell.done;
    client.close();

  }
  Future<void> motorRun(int state1, int state2) async{
    HapticFeedback.selectionClick();
    String command = DCMotorSingleRun(widget.pin1, widget.pin2, state1.toString(),state2.toString());
    var motorRun = await client.run(command);
  }
  @override
  Widget build(BuildContext context) {
    if(SSHLoadingFinished == true){
      print(index);
      return Padding(
          padding: const EdgeInsets.all(buttonPadding),
          child: GestureDetector(
            onVerticalDragStart: (dragDetail){
            },
            onVerticalDragUpdate: (dragDetail){
              if(dragDetail.primaryDelta!<0){
                //dragged up
                direction = 'up';
                setState(() {index = 1;});
              }
              else if(dragDetail.primaryDelta!>0){
                //dragged down
                direction = 'down';
                setState(() {index = 2;});
              }
            },
            onVerticalDragEnd: (dragDetail){
              if(direction == 'up'){
                motorRun(1,0);
                print(direction);
                setState(() {index = 1;});
              }
              if(direction =='down'){
                motorRun(0,1);
                print(direction);
              }

            },
            onTap: (){
              direction = 'pause';
              motorRun(0,0);
              print('tap');
              setState(() {index = 0;});
            },

            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                const SizedBox(height: 4),
                Text(widget.name,style: GoogleFonts.poppins(color: textcolor, fontWeight: FontWeight.w400, fontSize: 18),),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(24.0),
                    //color: Colors.grey[900],
                    color: motorColor[index],
                  ),
                  child: Center(child: motorIcon[index]),
                ),
              ],
            ),
          )
      );}
    else{
      return const LoadingSpaceWidget();
    }
  }
}
import 'package:comfyssh_flutter/comfyScript/statemanagement.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../components/LoadingWidget.dart';
import '../components/custom_ui_components.dart';
import '../components/custom_widgets.dart';
import '../components/pop_up.dart';
import '../function.dart';
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
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(24.0),
                    //color: Colors.grey[900],
                    color: motorColor[index],
                  ),
                  child: Center(child: motorIcon[index]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${widget.name} ',style: GoogleFonts.poppins( fontWeight: FontWeight.w400, fontSize: 18),),
                      direction == "pause"? Icon(Icons.arrow_upward): SizedBox(height: 0, width: 0,),
                    ],
                  ),
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

class AddComfyDCMotor extends StatefulWidget {
  const AddComfyDCMotor({super.key, required this.spaceName});
  final String spaceName;
  @override
  State<AddComfyDCMotor> createState() => _AddComfyDCMotorState();
}

class _AddComfyDCMotorState extends State<AddComfyDCMotor> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SpaceEdit())
      ],
      child: ListTile(
          title: Text('DC Motor'),
          onTap: (){
            Scaffold.of(context).closeEndDrawer();
            late String pinOut; late String buttonName; late String middle; late String left; late String right; late String up; late String down;

            showDialog(context: context, builder: (BuildContext context){
              int buttonSizeX = 1; int buttonSizeY = 1; int buttonPosition = 1;
              late String pin1; late String pin2;
              return ButtonAlertDialog(
                title: 'DC Motor',
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      comfyTextField(text: 'button name', onChanged: (btnName){
                        buttonName = btnName;
                      }),
                      const SizedBox(height: 32, width: double.infinity,),
                      comfyTextField(text: 'pin1', onChanged: (pin){
                        pin1 = pin;
                      },
                        keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                      const SizedBox(height: 32, width: double.infinity,),
                      comfyTextField(text: 'pin2', onChanged: (pin){
                        pin2 = pin;
                      },
                        keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                      const SizedBox(height: 32, width: double.infinity,),
                      const IconDuckCredit(iconLink: 'https://iconduck.com/icons/190062/dc-motor', iconName: 'DC Motor')
                    ],
                  ),
                ),
                actions: <Widget>[
                  comfyActionButton(
                    onPressed: (){
                      String stepperPinList = "$pin1 $pin2";
                      addButton('comfySpace.db', widget.spaceName, buttonName, buttonSizeX, buttonSizeY, buttonPosition, stepperPinList,'DCMotor');
                      Provider.of<SpaceEdit>(context, listen: false).ChangeSpaceEditState();
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            });
          }
      ),
    );
  }
}
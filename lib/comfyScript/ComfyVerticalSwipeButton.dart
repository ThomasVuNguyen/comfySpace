import 'package:comfyssh_flutter/comfyScript/statemanagement.dart';
import 'package:comfyssh_flutter/components/LoadingWidget.dart';
import 'package:comfyssh_flutter/components/custom_widgets.dart';
import 'package:comfyssh_flutter/states/CounterModel.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../components/pop_up.dart';
import '../function.dart';
import '../main.dart';

class ComfyVerticalButton extends StatefulWidget {
  const ComfyVerticalButton({super.key, required this.name, required this.hostname, required this.username, required this.password, required this.up, required this.down, required this.middle});
  final String name; final String hostname; final String username; final String password;
  final String up; final String down; final String middle;

  @override
  State<ComfyVerticalButton> createState() => _ComfyVerticalButtonState();
}

class _ComfyVerticalButtonState extends State<ComfyVerticalButton> {
  bool SSHLoadingFinished=false;
  String direction = 'middle';
  late SSHClient client;
  int index = 1;
  List<Widget> buttonIcon = [const Icon(Icons.arrow_upward, size: 60), const Icon(Icons.pause_circle_filled, size: 60), const Icon(Icons.arrow_downward, size: 60)];
  List<Color> buttonColor = [Colors.red,const Color.fromARGB(44, 164, 167, 189),Colors.red];

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
    print("initClient username: ${client.username} for ${widget.name}");
    setState(() {
      SSHLoadingFinished = true;
    });

  }
  Future<void> UpFunction() async{
    HapticFeedback.selectionClick();
    var UpFunc = await client.run(widget.up);
  }
  Future<void> DownFunction() async{
    HapticFeedback.selectionClick();
    var DownFunc = await client.run(widget.down);
  }
  Future<void> MiddleFunction() async{
    HapticFeedback.selectionClick();
    var MiddleFunc = await client.run(widget.middle);
  }
  Future<void> closeClient() async{
    final shell = await client.shell();
    await shell.done;
    client.close();
  }
  @override
  Widget build(BuildContext context) {
      return (SSHLoadingFinished == false) ?LoadingSpaceWidget():
          Padding(
            padding: const EdgeInsets.all(buttonPadding),
            child: GestureDetector(
              onVerticalDragUpdate: (dragDetail){
                if(dragDetail.primaryDelta!<0){
                  direction = 'up';
                  setState((){
                    index=0;
                  });
                }
                else if(dragDetail.primaryDelta!>0){
                  direction = 'down';
                  setState(() {
                    index=2;
                  });
                }
              },
              onVerticalDragEnd: (dragDetail){
                if(direction =='up'){
                  UpFunction();
                  print(direction);
                }
                else if(direction =='down'){
                  DownFunction();
                  print(direction);
                }
              },
              onTap: (){
                direction = 'middle';
                MiddleFunction();
                setState(() {
                  index=1;
                });
              },
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(24.0),
                      color: buttonColor[index],
                    ),
                    child: Center(child: buttonIcon[index]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${widget.name} ',style: GoogleFonts.poppins( fontWeight: FontWeight.w400, fontSize: 18)),
                        direction == "middle"? Icon(Icons.arrow_upward) : SizedBox(height: 0, width: 0,),
                      ],
                    ),
                  ),
                ],
              )
            ),
          );

  }
}

class AddComfyVerticalSwipeButton extends StatefulWidget {
  const AddComfyVerticalSwipeButton({super.key, required this.spaceName});
  final String spaceName;
  @override
  State<AddComfyVerticalSwipeButton> createState() => _AddComfyVerticalSwipeButtonState();
}

class _AddComfyVerticalSwipeButtonState extends State<AddComfyVerticalSwipeButton> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SpaceEdit())
      ],
      child: ListTile(
          title: Text('Vertical'),
          onTap: (){
            Scaffold.of(context).closeEndDrawer();
            late String pinOut; late String buttonName;
            showDialog(context: context, builder: (BuildContext context){
              late String buttonName; late String up; late String middle; late String down;
              int buttonSizeX = 1; int buttonSizeY =1 ; int buttonPosition = 1;
              return ButtonAlertDialog(
                title: 'Vertical Gesture Button',
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      comfyTextField(text: 'button name', onChanged: (btnName){
                        buttonName = btnName;
                      }),
                      const SizedBox(height: 32, width: double.infinity,),
                      comfyTextField(
                        keyboardType: TextInputType.multiline,
                        text: 'Up Function', onChanged: (txt){
                        up = txt;
                      },
                      ),
                      const SizedBox(height: 32, width: double.infinity,),
                      comfyTextField(
                        keyboardType: TextInputType.multiline,
                        text: 'Middle Func', onChanged: (txt){
                        middle = txt;
                      },
                      ),
                      const SizedBox(height: 32, width: double.infinity,),
                      comfyTextField(
                        keyboardType: TextInputType.multiline,
                        text: 'Down Func', onChanged: (txt){
                        down = txt;
                      },
                      ),
                      const SizedBox(height: 32, width: double.infinity,),
                      //const IconDuckCredit(iconLink: 'https://iconduck.com/icons/190062/dc-motor', iconName: 'DC Motor')
                    ],
                  ),
                ),
                actions: <Widget>[
                  comfyActionButton(
                    onPressed: (){
                      addButton('comfySpace.db', widget.spaceName, buttonName, buttonSizeX, buttonSizeY, buttonPosition,up + ConnectionCharacter + middle + ConnectionCharacter + down,'ComfyVerticalButton');
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

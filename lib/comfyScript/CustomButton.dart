import 'package:comfyssh_flutter/comfyScript/ComfyToggleButton.dart';
import 'package:comfyssh_flutter/comfyScript/statemanagement.dart';
import 'package:comfyssh_flutter/components/pop_up.dart';
import 'package:comfyssh_flutter/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../function.dart';

/*
This is a button with as many gestures possible as the user wants, meaning the database needs to be flexible
SQL data structure:

type#command#type#command
where:
type: type of gesture (swipe up, down, etc)
command: associated command
#: connection character - may god bless this never to change

this allows for implicit database in a String

Type List:
onTap
onSwipeUp
onSwipeDown
onSwipeLeft
onSwipeRight
onDoubleTap
onZoomOut
onZoomIn
onDrag

 */
class CustomComfyGestureButton extends StatefulWidget {
  const CustomComfyGestureButton({super.key, required this.name,
  required this.hostname, required this.username, required this.password,
  required this.OverallCommand});

  final String name; final String hostname; final String username; final String password;
  final String OverallCommand;

  @override
  State<CustomComfyGestureButton> createState() => _CustomComfyGestureButtonState();
}

class _CustomComfyGestureButtonState extends State<CustomComfyGestureButton> {
  Map<String, String> CommandExtracted = {};
  int index = 0; String direction = 'tap';
  List<Icon> buttonIcon = [const Icon(Icons.pause_circle_filled, size: 60), const Icon(Icons.arrow_upward, size: 60),  const Icon(Icons.arrow_downward, size: 60)];
  List<Color> buttonColor = [Colors.red, Colors.yellow, Colors.blue];
  @override
  void initState(){
    super.initState();
    CommandExtracted = CustomCommandExtraction(widget.OverallCommand);
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(CommandExtracted['onTap']!=null ){
          print(CommandExtracted['onTap']);
          setState(() {
            index = 0;
          });
        }
      },
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              color: buttonColor[index]
            ),
            child: Center(child: buttonIcon[index],),
          )
        ],
      )
    );
  }
}

class AddCustomComfyGestureButton extends StatefulWidget {
  const AddCustomComfyGestureButton({super.key, required this.spaceName});
  final String spaceName;
  @override
  State<AddCustomComfyGestureButton> createState() => _AddCustomComfyGestureButtonState();
}

class _AddCustomComfyGestureButtonState extends State<AddCustomComfyGestureButton> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => SpaceEdit())
    ],
        child: ListTile(
          title: Text('Custom Gesture',style: Theme.of(context).textTheme.titleMedium,),
          onTap: (){
            showDialog(context: context, builder: (BuildContext context){
              late String buttonName; String OverallCommand = '';
              String onSwipeLeft =''; String onSwipeRight = ''; String onTap = '';
              return ButtonAlertDialog(title: 'Custom Gesture Button',
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
                    text: 'Middle Func', onChanged: (txt){
                    onTap = txt;
                  },
                  ),
                  const SizedBox(height: 32, width: double.infinity,),
                  comfyTextField(
                    keyboardType: TextInputType.multiline,
                    text: 'Left Func', onChanged: (txt){
                    onSwipeLeft = txt;
                  },
                  ),
                  const SizedBox(height: 32, width: double.infinity,),
                  comfyTextField(
                    keyboardType: TextInputType.multiline,
                    text: 'Right Func', onChanged: (txt){
                    onSwipeRight = txt;
                  },
                  )],
                  ),
                ),
                  actions: <Widget>[
                    comfyActionButton(
                      onPressed: (){
                        if(onTap!=null && onTap!=''){
                          OverallCommand = OverallCommand + 'onTap'+ ConnectionCharacter + onTap + ConnectionCharacter;
                        }
                        if(onSwipeRight!=null && onSwipeRight!=''){
                          OverallCommand = OverallCommand + 'onSwipeRight'+ ConnectionCharacter + onSwipeRight + ConnectionCharacter;
                        }
                        if(onSwipeLeft!=null && onSwipeLeft!=''){
                          OverallCommand = OverallCommand + 'onSwipeLeft'+ ConnectionCharacter + onSwipeLeft + ConnectionCharacter;
                        }
                        //Delete redundant connection character at the end
                        OverallCommand = OverallCommand.substring(0, OverallCommand.length - ConnectionCharacter.length);
                        print(OverallCommand);
                        addButton('comfySpace.db', widget.spaceName, buttonName, buttonSizeX, buttonSizeY, buttonPosition, OverallCommand,'ComfyCustomGestureButton');
                        Provider.of<SpaceEdit>(context, listen: false).ChangeSpaceEditState();
                        Navigator.pop(context);
                      },
                    )
                  ],);
            });
          },
        ),
    );
  }
}

Map<String, String> CustomCommandExtraction(String OverallCommand){
  List<String> CommandList = CommandExtract(OverallCommand);
  Map<String,String> CommandExtracted = {};
  for (int i = 0; i<CommandList.length-1; i=i+2){
    CommandExtracted[CommandList[i]] = CommandList[i+1];
  }
  return CommandExtracted;
}

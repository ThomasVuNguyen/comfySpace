import 'package:comfyssh_flutter/comfyScript/statemanagement.dart';
import 'package:comfyssh_flutter/components/LoadingWidget.dart';
import 'package:comfyssh_flutter/components/custom_widgets.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../components/pop_up.dart';
import '../function.dart';
import '../main.dart';


class ComfyHorizontalButton extends StatefulWidget {
  const ComfyHorizontalButton({super.key, required this.name, required this.hostname, required this.username, required this.password, required this.left, required this.right, required this.middle});
  final String name; final String hostname; final String username; final String password;
  final String left; final String right; final String middle;

  @override
  State<ComfyHorizontalButton> createState() => _ComfyHorizontalButtonState();
}

class _ComfyHorizontalButtonState extends State<ComfyHorizontalButton> {
  bool SSHLoadingFinished=false;
  String direction = 'middle';
  late SSHClient client;
  int index = 1;
  List<Widget> buttonIcon = [const Icon(Icons.arrow_left, size: 60), const Icon(Icons.pause_circle_filled, size: 60), const Icon(Icons.arrow_right, size:60)];
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
    print("initClient username: ${client.username}");
    setState(() {SSHLoadingFinished = true;});
  }
  Future<void> LeftFunction() async{
    HapticFeedback.selectionClick();
    var LeftFunc = await client.run(widget.left);
  }
  Future<void> RightFunction() async{
    HapticFeedback.selectionClick();
    var RightFunc = await client.run(widget.right);
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
    if(SSHLoadingFinished ==true){
      return Padding(
        padding: const EdgeInsets.all(buttonPadding),
        child: GestureDetector(
          onHorizontalDragUpdate: (dragDetail){
            if(dragDetail.primaryDelta!<0){
              direction = 'left';
              setState((){
                index=0;
              });
            }
            else if(dragDetail.primaryDelta!>0){
              direction = 'right';
              setState(() {
                index=2;
              });
            }
          },
          onHorizontalDragEnd: (dragDetail){
            if(direction =='right'){
              RightFunction();
              print(direction);
            }
            else if(direction =='left'){
              LeftFunction();
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
                child: Center(child: buttonIcon[index],),
              ),
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${widget.name} ',style: GoogleFonts.poppins( fontWeight: FontWeight.w400, fontSize: 18),),
                    direction == "middle"? const Icon(Icons.arrow_right): const SizedBox(height: 0, width: 0,),
                  ],
                ),
              ),

            ],
          )
        ),
      );
    }
    else{
      return const LoadingSpaceWidget();
    }
  }
}

class AddComfyHorizontalSwipeButton extends StatefulWidget {
  const AddComfyHorizontalSwipeButton({super.key, required this.spaceName});
  final String spaceName;
  @override
  State<AddComfyHorizontalSwipeButton> createState() => _AddComfyHorizontalSwipeButtonState();
}

class _AddComfyHorizontalSwipeButtonState extends State<AddComfyHorizontalSwipeButton> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SpaceEdit())
      ],
      child: ListTile(
          title: Text('Horizontal', style: Theme.of(context).textTheme.titleMedium,),
          onTap: (){
            Scaffold.of(context).closeEndDrawer();
            late String pinOut; late String buttonName; late String left; late String right; late String middle;
            int buttonSizeX = 1 ; int buttonSizeY = 1; int buttonPosition =1;
            showDialog(context: context, builder: (BuildContext context){
              return ButtonAlertDialog(
                title: 'Horizontal Gesture Button',
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
                        text: 'Left Function', onChanged: (txt){
                        left = txt;
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
                        text: 'Right Func', onChanged: (txt){
                        right = txt;
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
                      addButton('comfySpace.db', widget.spaceName, buttonName, buttonSizeX, buttonSizeY, buttonPosition,left + ConnectionCharacter + middle + ConnectionCharacter + right,'ComfyHorizontalButton');
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

import 'package:comfyssh_flutter/components/LoadingWidget.dart';
import 'package:comfyssh_flutter/components/custom_widgets.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  List<Widget> buttonIcon = [const Icon(Icons.arrow_upward, size: 60, color: Colors.cyan,), const Icon(Icons.pause_circle_filled, size: 60, color: Colors.white,), const Icon(Icons.arrow_downward, size:60, color: Colors.cyanAccent,)];
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
    if(SSHLoadingFinished ==true){
      return Padding(
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
          child: Padding(
            padding: EdgeInsets.all(buttonPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity, alignment: AlignmentDirectional.center,
                  color: buttonColor[index],
                  child: Text(
                    widget.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                ),
                Container(height: 2.0, color: Colors.red,),
                Expanded(child: Container(
                  width: double.infinity,
                  color: buttonColor[index],
                  child: buttonIcon[index],
                ))
              ],
            ),
          ),
          ),
        );
    }
    else{
      return const LoadingSpaceWidget();
    }
  }
}

import 'package:comfyssh_flutter/components/LoadingWidget.dart';
import 'package:comfyssh_flutter/components/custom_widgets.dart';
import 'package:comfyssh_flutter/states/CounterModel.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ComfyFullGestureButton extends StatefulWidget {
  const ComfyFullGestureButton({super.key, required this.name, required this.hostname, required this.username, required this.password, required this.up, required this.down, required this.middle,required this.left, required this.right});
  final String name; final String hostname; final String username; final String password;
  final String up; final String down; final String middle; final String left; final String right;

  @override
  State<ComfyFullGestureButton> createState() => _ComfyFullGestureButtonState();
}
// Gesture index: 0->4: middle, left, right, up, down
class _ComfyFullGestureButtonState extends State<ComfyFullGestureButton> {
  bool SSHLoadingFinished=false;
  String direction = 'middle';
  late SSHClient client;
  int index = 0;
  List<Widget> buttonIcon = [const Icon(Icons.pause_circle_filled, size: 60), const Icon(Icons.arrow_left, size: 60), const Icon(Icons.arrow_right, size: 60), const Icon(Icons.arrow_upward, size: 60),  const Icon(Icons.arrow_downward, size: 60)];
  List<Color> buttonColor = [const Color.fromARGB(44, 164, 167, 189),Colors.red,Colors.red,Colors.red,Colors.red];

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
  Future<void> LeftFunction() async{
    HapticFeedback.selectionClick();
    var UpFunc = await client.run(widget.left);
  }
  Future<void> RightFunction() async{
    HapticFeedback.selectionClick();
    var UpFunc = await client.run(widget.right);
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
    final counter = context.read<CounterModel>();
    counter.increment();
    return (SSHLoadingFinished == false) ?LoadingSpaceWidget():
    Padding(
      padding: const EdgeInsets.all(buttonPadding),
      child: GestureDetector(
          onVerticalDragUpdate: (dragDetail){
            if(dragDetail.primaryDelta!<0){
              direction = 'up';
              setState((){
                index=3;
              });
            }
            else if(dragDetail.primaryDelta!>0){
              direction = 'down';
              setState(() {
                index=4;
              });
            }
          },
          onHorizontalDragUpdate: (dragDetail){
            if(dragDetail.primaryDelta!<0){
              direction = 'left';
              setState((){
                index=1;
              });
            }
            else if(dragDetail.primaryDelta!>0){
              direction = 'right';
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
              index=0;
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

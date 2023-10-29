import 'package:comfyssh_flutter/components/LoadingWidget.dart';
import 'package:comfyssh_flutter/components/custom_widgets.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../states/CounterModel.dart';

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
    final counter = context.read<CounterModel>();
    counter.decrement();
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
      final counter = context.read<CounterModel>();
      counter.increment();
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
                padding: EdgeInsets.only(top:8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${widget.name} ',style: GoogleFonts.poppins( fontWeight: FontWeight.w400, fontSize: 18),),
                    direction == "middle"? Icon(Icons.arrow_right): SizedBox(height: 0, width: 0,),
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

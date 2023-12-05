import 'package:comfyssh_flutter/comfyScript/statemanagement.dart';
import 'package:comfyssh_flutter/main.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:xterm/xterm.dart';

import '../components/LoadingWidget.dart';
import '../components/custom_widgets.dart';
import '../components/pop_up.dart';
import '../function.dart';

List<String> CommandExtract(String command) {
  List<String> CommandList = command.split(ConnectionCharacter);
  return CommandList;
}

class ComfyToggleButton extends StatefulWidget {
  const ComfyToggleButton({super.key, required this.commandOn, required this.commandOff, required this.name, required this.hostname, required this.username, required this.password, required this.terminal});
  final String name;
  final String commandOn; final String commandOff;
  final String hostname; final String username; final String password;
  final Terminal terminal;
  @override
  State<ComfyToggleButton> createState() => _ComfyToggleButtonState();
}

class _ComfyToggleButtonState extends State<ComfyToggleButton> {
  bool toggleState=false; bool SSHLoadingFinished = false;
  late SSHClient client;
  @override
  void initState(){
    super.initState();
    initClient();
  }
  @override
  void dispose(){
    super.dispose();
    closeClient();
    print("closed");
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
  @override
  Widget build(BuildContext context) {
    if(SSHLoadingFinished == true){
      return GestureDetector(
        onTap: () async {
          setState((){
            toggleState = !toggleState;
            print(toggleState.toString());
          });
          if (toggleState == true){
            widget.terminal.write('\r\n${widget.commandOff} ');
            var command = await client.run(widget.commandOff);
          }
          else{
            widget.terminal.write('\r\n${widget.commandOn} ');
            var command = await client.run(widget.commandOn);
          }

          SystemSound.play(SystemSoundType.click);

        },
        child: Padding(
          padding: const EdgeInsets.all(buttonPadding),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(24.0),
                  color: toggleState? Colors.white :Colors.black,
                ),
                child: Center(child: toggleState? const Icon(Icons.toggle_on, size: 60,color: Colors.black,) :const Icon(Icons.toggle_off, size: 60,color: Colors.white,),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('${widget.name} ',style: GoogleFonts.poppins( fontWeight: FontWeight.w400, fontSize: 18, color:!toggleState? Colors.white :Colors.black, )),
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

class AddComfyToggleButton extends StatefulWidget {
  const AddComfyToggleButton({super.key, required this.spaceName});
  final String spaceName;
  @override
  State<AddComfyToggleButton> createState() => _AddComfyToggleButtonState();
}

class _AddComfyToggleButtonState extends State<AddComfyToggleButton> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SpaceEdit())
      ],
      child: ListTile(
          title: Text('Toggle', style: Theme.of(context).textTheme.titleMedium,),
          onTap: (){
            Scaffold.of(context).closeEndDrawer();
            late String pinOut; late String buttonName;
            showDialog(context: context, builder: (BuildContext context){
              String buttonType = 'ComfyToggleButton';
              buttonSizeY = 1;
              buttonSizeX=1;
              buttonPosition=1;
              late String CommandOn; late String CommandOff;
              return ButtonAlertDialog(
                  title: 'Toggle Button',
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        comfyTextField(onChanged: (btnName){
                          buttonName = btnName;
                        }, text: 'button name'),
                        const SizedBox(height: 32, width: double.infinity,),
                        comfyTextField(onChanged: (btnCommand){
                          CommandOn = btnCommand;
                        }, text: 'command #1',
                          keyboardType: TextInputType.multiline,),
                        const SizedBox(height: 32, width: double.infinity,),
                        comfyTextField(onChanged: (btnCommand){
                          CommandOff = btnCommand;
                        }, text: 'command #2',
                          keyboardType: TextInputType.multiline,),

                      ],
                    ),
                  ),
                  actions: [
                    comfyActionButton(
                      onPressed: (){
                        addButton('comfySpace.db', widget.spaceName, buttonName, buttonSizeX, buttonSizeY, buttonPosition, CommandOn + ConnectionCharacter + CommandOff, buttonType);
                        Provider.of<SpaceEdit>(context, listen: false).ChangeSpaceEditState();
                        Navigator.pop(context);

                      },
                    ),
                  ]);
            });
          }
      ),
    );
  }
}
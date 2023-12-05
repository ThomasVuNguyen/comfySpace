import 'dart:convert';

import 'package:comfyssh_flutter/comfyScript/statemanagement.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:xterm/core.dart';

import '../components/LoadingWidget.dart';
import '../components/custom_ui_components.dart';
import '../components/custom_widgets.dart';
import '../components/pop_up.dart';
import '../function.dart';

Future<String> readInput(SSHClient client, String command) async {
  await Future.delayed(const Duration(seconds: 1));
  final distance = await client.run(command);
  return utf8.decode(distance);
}

Stream<String> readInputStream(SSHClient client, String command) async* {
  while(true){
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final distance = await client.run(command);
    yield utf8.decode(distance);
  }

}


class CustomInputButton extends StatefulWidget {
  const CustomInputButton({super.key, required this.name, required this.hostname, required this.username, required this.password, required this.commandIn, required this.terminal});
  final String name; final String hostname; final String username; final String password; final String commandIn; final Terminal terminal;
  @override
  State<CustomInputButton> createState() => _CustomInputButtonState();
}

class _CustomInputButtonState extends State<CustomInputButton> {
  late final terminal = Terminal();
  bool SSHLoaded = false; bool toggleState = false; late SSHClient client;
  @override
  void initState(){
    print(widget.commandIn);
    super.initState();
    initClient();
  }
  @override
  void dispose(){
    super.dispose();
    closeClient();
  }
  Future<void> initClient() async{
    client = SSHClient(
      await SSHSocket.connect(widget.hostname, 22),
      username: widget.username,
      onPasswordRequest: () => widget.password,
    );
    print("initClient username: ${client.username}");
    setState(() {SSHLoaded = true;});
  }

  Future<void> closeClient() async{
    final shell = await client.shell();
    await shell.done;
    client.close();

  }
  Future<void> sendCommand() async{
    var command = await client.run(widget.commandIn);
  }
  @override
  Widget build(BuildContext context) {
    if (SSHLoaded == true){
      return StreamBuilder(
          stream: readInputStream(client, widget.commandIn),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot,){
            if(snapshot.hasData){
              return Padding(padding: const EdgeInsets.all(buttonPadding),
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(24.0), color: Colors.grey[900]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25.0),
                      child: Stack(
                          alignment: AlignmentDirectional.topCenter,
                          children:[
                            const SizedBox(height: 4),
                            Text(widget.name,style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 18),),
                            Center(child: Text(snapshot.data!, style: const TextStyle(color: Colors.orange, fontSize: 18))),
                          ]
                      ),
                    ),
                  )
              );
            }
            else{
              return const LoadingSpaceWidget();
            }
          });
    }
    else{
      return const LoadingSpaceWidget();
    }
  }
}

class AddComfyDataButton extends StatefulWidget {
  const AddComfyDataButton({super.key, required this.spaceName});
  final String spaceName;

  @override
  State<AddComfyDataButton> createState() => _AddComfyDataButtonState();
}

class _AddComfyDataButtonState extends State<AddComfyDataButton> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SpaceEdit())
      ],
      child: ListTile(
          title: Text('Data', style: Theme.of(context).textTheme.titleMedium,),
          onTap: (){
            Scaffold.of(context).closeEndDrawer();
            late String pinOut; late String buttonName; late String middle; late String left; late String right; late String up; late String down;
            int buttonSizeX = 1; int buttonSizeY = 1; int buttonPosition = 1;
            showDialog(context: context, builder: (BuildContext context){
              String buttonType = 'ComfyData';
              int buttonSizeY = 1;
              int buttonSizeX=1;
              int buttonPosition=1;
              late String buttonCommand;
              return ButtonAlertDialog(
                  title: 'Data Button',
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        comfyTextField(onChanged: (btnName){
                          buttonName = btnName;
                        }, text: 'button name'),
                        const SizedBox(height: 32, width: double.infinity,),
                        comfyTextField(onChanged: (btnCommand){
                          buttonCommand = btnCommand;
                        }, text: 'command',
                          keyboardType: TextInputType.multiline,
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    comfyActionButton(
                      onPressed: (){
                        addButton('comfySpace.db', widget.spaceName, buttonName, buttonSizeX, buttonSizeY, buttonPosition, buttonCommand, 'ComfyData');
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

class AddComfyDistanceSensor extends StatefulWidget {
  const AddComfyDistanceSensor({super.key, required this.spaceName});
  final String spaceName;

  @override
  State<AddComfyDistanceSensor> createState() => _AddComfyDistanceSensorState();
}

class _AddComfyDistanceSensorState extends State<AddComfyDistanceSensor> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SpaceEdit())
      ],
      child: ListTile(
          title: Text('Distance Sensor', style: Theme.of(context).textTheme.titleMedium,),
          onTap: (){
            Scaffold.of(context).closeEndDrawer();
            late String pinOut; late String buttonName; late String middle; late String left; late String right; late String up; late String down;
            showDialog(context: context, builder: (BuildContext context){
              int buttonSizeX = 1; int buttonSizeY = 1; int buttonPosition = 1;
              late String trig; late String echo;
              return ButtonAlertDialog(
                title: "Distance sensor",
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      comfyTextField(text: 'button name', onChanged: (btnName){
                        buttonName = btnName;
                      }),
                      const SizedBox(height: 32, width: double.infinity,),

                      comfyTextField(text: 'trigger pin',
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onChanged: (pin){
                            trig = pin;
                          }),
                      const SizedBox(height: 32, width: double.infinity,),

                      comfyTextField(text: 'echo pin',
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onChanged: (pin){
                            echo = pin;
                          }),
                      const SizedBox(height: 32, width: double.infinity,),

                      const IconDuckCredit(iconLink: 'https://iconduck.com/icons/190115/ultrasonic-distance-sensor', iconName: 'Sensor'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  comfyActionButton(
                    onPressed: (){
                      String HCSR04PinList = '$trig $echo';
                      addButton('comfySpace.db', widget.spaceName, buttonName, buttonSizeX, buttonSizeY, buttonPosition, HCSR04PinList, 'HCSR04');
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
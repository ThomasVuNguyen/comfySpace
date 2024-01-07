import 'package:comfyssh_flutter/comfyScript/ComfyToggleButton.dart';
import 'package:comfyssh_flutter/comfyScript/statemanagement.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:xterm/xterm.dart';

import '../components/LoadingWidget.dart';
import '../components/custom_ui_components.dart';
import '../components/custom_widgets.dart';
import '../components/pop_up.dart';
import '../function.dart';
import '../main.dart';

String toggleLED(String pinOut, bool isToggled){
  if(isToggled == true){
    print("true");
    //return 'raspi-gpio set $pinOut op && raspi-gpio set $pinOut dh';
    return'python3 comfyScript/LED/led.py $pinOut 1';
  }
  else{
    //return 'raspi-gpio set $pinOut op && raspi-gpio set $pinOut dl';
    return'python3 comfyScript/LED/led.py $pinOut 0';
  }
}

class LedToggle extends StatefulWidget {
  const LedToggle({super.key, required this.spaceName, required this.name, required this.pin, required this.id, required this.hostname, required this.username, required this.password, required this.terminal});
  final String name;
  final String pin;
  final int id;
  final String hostname; final String username; final String password; final String spaceName;
  final Terminal terminal;
  @override
  State<LedToggle> createState() => _LedToggleState();
}

class _LedToggleState extends State<LedToggle> {
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
    return ComfyToggleButton(
        commandOn: toggleLED(widget.pin.toString(), false),
        commandOff: toggleLED(widget.pin.toString(), true),
        name: widget.name,
        hostname: widget.hostname,
        username: widget.username,
        password: widget.password,
        terminal: widget.terminal,
      isCustom: true,
      CustomWidgetOff: Icons.dark_mode,
      CustomWidgetOn: Icons.light,
    );
  }
}

class AddLEDButton extends StatefulWidget {
  const AddLEDButton({super.key, required this.spaceName});
  final String spaceName;
  @override
  State<AddLEDButton> createState() => _AddLEDButtonState();
}

class _AddLEDButtonState extends State<AddLEDButton> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SpaceEdit())
      ],
      child: ListTile(
          title: Text('LED', style: Theme.of(context).textTheme.titleMedium,),
          onTap: (){
            Scaffold.of(context).closeEndDrawer();
            late String pinOut;
            showDialog(context: context, builder: (BuildContext context){
              return ButtonAlertDialog(
                title: 'LED toggle',
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      comfyTextField(text: 'button name', onChanged: (btnName){
                        buttonName = btnName;
                      }),
                      const SizedBox(height: 32, width: double.infinity,),
                      comfyTextField(text: 'pin number',
                        onChanged: (pinNum){pinOut = pinNum;},
                        keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                      const IconDuckCredit(iconLink: 'https://iconduck.com/icons/190075/led-unit', iconName: 'LED' )
                    ],
                  ),
                ),
                actions: <Widget>[
                  comfyActionButton(onPressed: (){
                    addButton('comfySpace.db', widget.spaceName, buttonName, 1, 1, 1, pinOut,'LED');
                    Navigator.pop(context);
                    Provider.of<SpaceEdit>(context, listen: false).ChangeSpaceEditState();

                  },)
                ],
              );
            });
          }
      ),
    );
  }
}

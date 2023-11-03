import 'package:comfyssh_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../function.dart';


class Credit extends StatelessWidget {
  const Credit({super.key});
  Future<void> comfySpaceDocumentation() async{
    final Uri docUrl = Uri.parse('https://tungnguyen.me/');
    if (!await launchUrl(docUrl,mode: LaunchMode.externalApplication)){
      throw Exception('cannot launch documentation');
    }
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Credits', textAlign: TextAlign.center,),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Thank you for using comfySpace\r\n', textAlign: TextAlign.center,),
            Image.asset('assets/DuckHop.gif', height: 40, gaplessPlayback: true,),
            Text('\r\nProudly made by', textAlign: TextAlign.center,),
            TextButton(
                onPressed: (){
                  comfySpaceDocumentation();
                },
                child: Text('\r\nThomas Nguyen', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontWeight: FontWeight.w400,fontSize: 18.0, color: Colors.white,decoration: TextDecoration.underline,),),),
            Text('\r\n*more features coming* ', textAlign: TextAlign.center,style: GoogleFonts.poppins(fontWeight: FontWeight.w400,fontSize: 14.0, color: Colors.grey)),
            Text('\r\n*more features coming* ', textAlign: TextAlign.center,style: GoogleFonts.poppins(fontWeight: FontWeight.w400,fontSize: 14.0, color: Colors.grey)),

          ],
        ),
      ),
    );

  }
}

class AddingButtonDial extends StatefulWidget {
  const AddingButtonDial({super.key, required this.databaseName, required this.spaceName});
  final String databaseName; final String spaceName;
  @override
  State<AddingButtonDial> createState() => _AddingButtonDialState();
}

class _AddingButtonDialState extends State<AddingButtonDial> {
  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.menu,
      activeIcon: Icons.close,
      visible: true,
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      onOpen: (){},onClose: (){},
      children: [
        SpeedDialChild(
            child: const Icon(Icons.dashboard_customize),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            label: "custom", labelStyle: const TextStyle(fontSize: 18),
            onTap: (){
              showDialog(context: context, builder: (BuildContext context){
                String buttonType = 'custom';
                buttonSizeY = 1;
                buttonSizeX=1;
                buttonPosition=1;
                return AlertDialog(
                  content: Column(
                    children: [
                      TextField(
                        onChanged: (btnName){
                          buttonName = btnName;
                        },
                        decoration: const InputDecoration(
                          hintText: 'name',
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                      TextField(
                        onChanged: (btnCommand){
                          buttonCommand = btnCommand;
                        },
                        decoration: const InputDecoration(
                          hintText: 'command',
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(onPressed: (){
                      addButton(widget.databaseName, widget.spaceName, buttonName, buttonSizeX, buttonSizeY, buttonPosition, buttonCommand, 'custom');
                      Future.delayed(const Duration(milliseconds: 100), (){
                        setState(() {
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>  const comfySpace()),);
                        });
                      });
                      Navigator.pop(context);

                    }, child: Text("Add button"))
                  ],
                );
              });
            }
        ),
        SpeedDialChild(
            child: const Icon(Icons.sunny),
            onTap: (){
              late String pinOut;
              showDialog(context: context, builder: (BuildContext context){
                return AlertDialog(
                  content: Column(
                    children: [
                      TextField(
                        onChanged: (btnName){
                          buttonName = btnName;
                        },),
                      TextField(
                        decoration: const InputDecoration(labelText: 'Pin Number'),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (pinNum){
                          pinOut = pinNum;
                        },
                      )
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(onPressed: (){
                      addButton(widget.databaseName, widget.spaceName, buttonName, buttonSizeX, buttonSizeY, buttonPosition, pinOut,'LED');
                      Navigator.pop(context);
                      setState(() {});
                    },
                        child: const Text("LED")
                    )
                  ],
                );
              });
            }
        ),
        /*SpeedDialChild(
                child: Icon(Icons.refresh),
                onTap: (){
                  late String servoPin;
                  showDialog(context: context, builder: (BuildContext context){
                    return AlertDialog(
                      content: Column(
                        children: [
                          TextField(
                            onChanged: (btnName){
                              buttonName = btnName;
                            },),
                          TextField(
                            decoration: const InputDecoration(labelText: 'Pin Number'),
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            onChanged: (pinNum){
                              servoPin = pinNum;
                            },
                          )
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(onPressed: (){
                          addButton('comfySpace.db', widget.spaceName, buttonName, buttonSizeX, buttonSizeY, buttonPosition, servoPin,'servo');
                          Navigator.pop(context);
                          setState(() {});
                        },
                            child: const Text("servo")
                        )
                      ],
                    );
                  });
                }

            ),*/
        SpeedDialChild(
            child: Icon(Icons.stairs),
            onTap: (){
              late String pin1; late String pin2; late String pin3; late String pin4;
              showDialog(context: context, builder: (BuildContext context){
                return AlertDialog(
                  content: Column(
                    children: [
                      TextField(
                        onChanged: (btnName){
                          buttonName = btnName;
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      TextField(
                        decoration: const InputDecoration(labelText: 'pin1'),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (pin){
                          pin1 = pin;
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      TextField(
                        decoration: const InputDecoration(labelText: 'pin2'),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (pin){
                          pin2 = pin;
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      TextField(
                        decoration: const InputDecoration(labelText: 'pin3'),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (pin){
                          pin3 = pin;
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      TextField(
                        decoration: const InputDecoration(labelText: 'pin4'),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (pin){
                          pin4 = pin;
                        },
                        textInputAction: TextInputAction.next,
                      )
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(onPressed: (){
                      String stepperPinList = "$pin1 $pin2 $pin3 $pin4";
                      addButton(widget.databaseName, widget.spaceName, buttonName, buttonSizeX, buttonSizeY, buttonPosition, stepperPinList,'stepperMotor');
                      Navigator.pop(context);
                      setState(() {});
                    },
                        child: const Text("servo")
                    )
                  ],
                );
              });
            }
        ),
        SpeedDialChild(
            child: Icon(Icons.sensors),
            onTap: (){
              late String trig; late String echo;
              showDialog(context: context, builder: (BuildContext context){
                return AlertDialog(
                  content: Column(
                    children: [
                      TextField(
                        onChanged: (btnName){
                          buttonName = btnName;
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      TextField(
                        decoration: const InputDecoration(labelText: 'trig'),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (pin){
                          trig = pin;
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      TextField(
                        decoration: const InputDecoration(labelText: 'echo'),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (pin){
                          echo = pin;
                        },
                        textInputAction: TextInputAction.next,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: (){
                        String HCSR04PinList = '$trig $echo';
                        addButton(widget.databaseName, widget.spaceName, buttonName, buttonSizeX, buttonSizeY, buttonPosition, HCSR04PinList, 'HCSR04');
                        Navigator.pop(context);
                        setState(() {});
                      }, child: Text("Add distance sensor"),
                    )
                  ],
                );
              });
            }
        )
      ],
    );
  }
}

class Icon8Credit extends StatelessWidget {
  const Icon8Credit({super.key, required this.iconLink, required this.iconName});
  final String iconLink; final String iconName;
  Future<void> launchIcon8() async{
    final Uri icon8URL = Uri.parse('https://icons8.com/');
    if(!await launchUrl(icon8URL)){
      throw Exception('could not launch $icon8URL');
    }
  }
  Future<void> launchIcon() async{
    final Uri iconURL = Uri.parse(iconLink);
    if(!await launchUrl(iconURL)){
      throw Exception('could not launch $iconURL');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              child: Text(iconName, style: TextStyle(decoration: TextDecoration.underline,),),
              onTap: () => launchIcon(),
            ),
            Text(" icon by "),
            InkWell(
              child: const Text("Icon8", style: TextStyle(decoration: TextDecoration.underline,),),
              onTap: () => launchIcon8(),
            )
          ],
        ),
      ],
    );
  }
}

class IconDuckCredit extends StatelessWidget {
  const IconDuckCredit({super.key, required this.iconLink, required this.iconName});
  final String iconLink; final String iconName;
  Future<void> launchIcon8() async{
    final Uri icon8URL = Uri.parse('https://icons8.com/');
    if(!await launchUrl(icon8URL)){
      throw Exception('could not launch $icon8URL');
    }
  }
  Future<void> launchIcon() async{
    final Uri iconURL = Uri.parse(iconLink);
    if(!await launchUrl(iconURL)){
      throw Exception('could not launch $iconURL');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              child: Text(iconName, style: TextStyle(decoration: TextDecoration.underline,),),
              onTap: () => launchIcon(),
            ),
            Text(" icon by "),
            InkWell(
              child: const Text("IconDuck", style: TextStyle(decoration: TextDecoration.underline,),),
              onTap: () => launchIcon8(),
            )
          ],
        ),
      ],
    );
  }
}

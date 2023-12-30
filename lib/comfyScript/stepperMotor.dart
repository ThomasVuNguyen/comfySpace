import 'package:comfyssh_flutter/comfyScript/ComfyHorizontalSwipeButton.dart';
import 'package:comfyssh_flutter/comfyScript/statemanagement.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../components/LoadingWidget.dart';
import '../components/custom_ui_components.dart';
import '../components/custom_widgets.dart';
import '../components/pop_up.dart';
import '../function.dart';

String stepperMotor(String pin1, String pin2, String pin3, String pin4, String stepperState){
    return "python3 comfyScript/stepper/stepper.py $pin1 $pin2 $pin3 $pin4 $stepperState ";
}

class StepperMotor extends StatefulWidget {
    const StepperMotor({super.key, required this.name, required this.id, required this.pin1, required this.pin2, required this.pin3, required this.pin4, required this.hostname, required this.username, required this.password});
    final String name; final int id; final String pin1; final String pin2; final String pin3; final String pin4;
    final String hostname; final String username; final String password;
    @override
    State<StepperMotor> createState() => _StepperMotorState();
}

class _StepperMotorState extends State<StepperMotor> {
    bool SSHLoadingFinished = false;
    int rotationDirection = 1; //0 means counterclockwise, 1 means stop, 2 means clockwise
    final List<bool> _stepperState = <bool>[false, true, false];
    String direction = 'pause';
    late SSHClient client;
    int index = 0;
    List<Widget> motorIcon = [const Icon(Icons.pause_circle_filled, size: 60,), const Icon(Icons.arrow_right, size: 60), const Icon(Icons.arrow_left, size:60)];
    List<Color> motorColor = [const Color.fromARGB(44, 164, 167, 189),Colors.red,Colors.red];
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
    Future<void> closeClient() async{
        final shell = await client.shell();
        await shell.done;
        client.close();
    }
    Future<void> motorRun(int stepperState) async{
        HapticFeedback.selectionClick();
        String command = stepperMotor(widget.pin1, widget.pin2, widget.pin3, widget.pin4, stepperState.toString());
        var motorRun = await client.run(command);
        print('stepper state is $stepperState');
    }
    @override
    Widget build(BuildContext context) {
        return ComfyHorizontalButton(
            name: widget.name,
            hostname: widget.hostname, username: widget.username, password: widget.password,
            left: stepperMotor(widget.pin1, widget.pin2, widget.pin3, widget.pin4, '1'),
            right: stepperMotor(widget.pin1, widget.pin2, widget.pin3, widget.pin4, '-1'),
            middle: stepperMotor(widget.pin1, widget.pin2, widget.pin3, widget.pin4, '0'),);
    }
}

class AddComfyStepperMotor extends StatefulWidget {
    const AddComfyStepperMotor({super.key, required this.spaceName});
    final String spaceName;
    @override
    State<AddComfyStepperMotor> createState() => _AddComfyStepperMotorState();
}

class _AddComfyStepperMotorState extends State<AddComfyStepperMotor> {
    @override
    Widget build(BuildContext context) {
        return MultiProvider(
            providers: [
                ChangeNotifierProvider(create: (context) => SpaceEdit())
            ],
            child: ListTile(
                title: Text('Stepper Motor', style: Theme.of(context).textTheme.titleMedium,),
                onTap: (){
                    Scaffold.of(context).closeEndDrawer();
                    late String pinOut; late String buttonName; late String middle; late String left; late String right; late String up; late String down;

                    showDialog(context: context, builder: (BuildContext context){
                        int buttonSizeX = 1; int buttonSizeY = 1; int buttonPosition = 1;
                        late String pin1; late String pin2; late String pin3; late String pin4;
                        return ButtonAlertDialog(
                            title: 'Stepper Motor',
                            content: SingleChildScrollView(
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                        comfyTextField(text: 'button name', onChanged: (btnName){
                                            buttonName = btnName;
                                        }),
                                        const SizedBox(height: 32, width: double.infinity,),
                                        comfyTextField(text: 'pin1', onChanged: (pin){
                                            pin1 = pin;
                                        },
                                            keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        ),
                                        const SizedBox(height: 32, width: double.infinity,),
                                        comfyTextField(text: 'pin2', onChanged: (pin){
                                            pin2 = pin;
                                        },
                                            keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        ),
                                        const SizedBox(height: 32, width: double.infinity,),
                                        comfyTextField(text: 'pin3', onChanged: (pin){
                                            pin3 = pin;
                                        },
                                            keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        ),
                                        const SizedBox(height: 32, width: double.infinity,),
                                        comfyTextField(text: 'pin4', onChanged: (pin){
                                            pin4 = pin;
                                        },
                                            keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        ),
                                        const SizedBox(height: 32, width: double.infinity,),
                                        const IconDuckCredit(iconLink: 'https://iconduck.com/icons/190110/stepper-motor', iconName: 'Stepper Motor')
                                    ],
                                ),
                            ),
                            actions: <Widget>[
                                comfyActionButton(
                                    onPressed: (){
                                        String stepperPinList = "$pin1 $pin2 $pin3 $pin4";
                                        addButton('comfySpace.db', widget.spaceName, buttonName, buttonSizeX, buttonSizeY, buttonPosition, stepperPinList,'stepperMotor');
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
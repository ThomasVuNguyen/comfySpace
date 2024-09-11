import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/project_information.dart';
import 'package:v2_1/project_space_screen/button_list/comfy_ai_chat_button.dart';
import 'package:v2_1/project_space_screen/button_list/comfy_swipe_button.dart';
import 'package:v2_1/project_space_screen/button_list/comfy_tap_button.dart';
import 'package:v2_1/project_space_screen/button_list/comfy_toggle_button.dart';
import 'package:v2_1/project_space_screen/components/button_edit_and_delete_page.dart';

class button_sort extends StatefulWidget {
  const button_sort({super.key, required this.button, required this.projectName,
    required this.hostname, required this.staticIP, required this.port, required this.username, required this.password,
    required this.systemInstances
  });
  final comfy_button button; final String projectName;
  final String hostname; final String staticIP; final int port; final String username; final String password;
  final Map<String, dynamic> systemInstances;
  @override
  State<button_sort> createState() => _button_sortState();
}

class _button_sortState extends State<button_sort> {
  //late SSHClient _sshClient;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<SSHClient> initClient() async{
    late SSHClient sshClient;
    for(String potentialHostName in [widget.staticIP, widget.hostname]){
      try{
        sshClient = SSHClient(
          await SSHSocket.connect(potentialHostName, widget.port),
          username: widget.username,
          onPasswordRequest: () => widget.password,
        );
        //attempt a connection
        await sshClient.execute('echo hi');
        print('ssh connection successfully created with hostname $potentialHostName');
        break;

      }
      catch (e){
        //SSH error not connected
        //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error connecting to $potentialHostName: $e}')));
      }
    }
    return sshClient;
  }
  @override
  Widget build(BuildContext context) {
    print('system instance of ${widget.systemInstances.toString()}');
    return Stack(
      alignment: Alignment.topRight,
      children: [
                Builder(builder: (context){
                  switch (widget.button.type){
                    case 'tap':
                      return comfy_tap_button(
                        button: widget.button,
                        hostname: widget.hostname, staticIP: widget.staticIP, port: widget.port, username: widget.username, password: widget.password,);
                    case 'toggle':
                      return comfy_toggle_button(button: widget.button, hostname: widget.hostname, staticIP: widget.staticIP, port: widget.port, username: widget.username, password: widget.password,);
                    case 'swipe':
                      return comfy_swipe_button(button: widget.button, hostname: widget.hostname, staticIP: widget.staticIP, port: widget.port, username: widget.username, password: widget.password,);
                    case 'ai-chat':
                      return comfy_ai_chat_button(button: widget.button, hostname: widget.hostname, staticIP: widget.staticIP, port: widget.port, username: widget.username, password: widget.password);
                    default:
                      return Text('unidentified ${widget.button.type}');
                  }
                }),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            height: 25, width: 25,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.onSurface, width: 2),
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primaryContainer,
              //borderRadius: BorderRadius.circular(20)
            ),
              child: Center(
                child: IconButton(
                  iconSize: 0,
                    onPressed: (){
                  Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) => ButtonEditAndDeletePage(
                      projectName: widget.projectName, button: widget.button,
                      hostname: widget.hostname, port: widget.port,
                      username: widget.username, password: widget.password,
                    )),
                        (Route<dynamic> route) => false,
                  );
                }, icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.onPrimaryContainer,)),
              )),
        ),
      ],
    );


  }
}

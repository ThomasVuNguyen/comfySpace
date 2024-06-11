import 'package:flutter/material.dart';
import 'package:v2_1/chat_ui/chat_ui.dart';

class SSHInfoPage extends StatelessWidget {
  const SSHInfoPage({super.key, required this.project_name, required this.project_description, required this.imgURL});
  final String project_name; final String project_description; final String imgURL;
  @override
  Widget build(BuildContext context) {
    return chatPage(
        questions: const {
          'hostname': ['Now that you have finished setting up, let\'s enter the IP address:'],
          'username': ['Enter your username:'],
          'password': ['Lastly, enter your password. Don\'t worry, we will keep it safe, pinky promise!']
        },
        answers: {
          'project_name': project_name,
          'project_description': project_description,
          'imgURL': imgURL
        },
        title: 'Enter SSH Credentials',
        pageName: 'ssh_credentials');
  }
}

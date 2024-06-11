
import 'package:flutter/material.dart';
import 'package:v2_1/chat_ui/chat_ui.dart';


String imgURLPlaceHolder = '';

class create_new_project extends StatefulWidget {
  const create_new_project({super.key});

  @override
  State<create_new_project> createState() => _create_new_projectState();
}

class _create_new_projectState extends State<create_new_project> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SafeArea(
          child: chatPage(
            questions: {
              'project_name': ['Hi there! Let\'s create a project together', 'Pick a cool name for your project!', 'Example: Rumble Robot, Chatty Bot, Dope Drone, etc.'],
              'project_description':['In one short sentence, describe what you\'re building!', 'Example: A traversal remote-controlled car with a camera mounted']
            },
            answers: {}, title: 'Create a robotic project',
            pageName: 'create_new_project_pick_name',
          )
        ),
      ),
    );
  }
}





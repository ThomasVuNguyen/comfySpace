import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/edit_button.dart';
import 'package:v2_1/home_screen/components/set_user_info.dart';

class create_new_project extends StatefulWidget {
  const create_new_project({super.key});

  @override
  State<create_new_project> createState() => _create_new_projectState();
}

class _create_new_projectState extends State<create_new_project> {
  final projectNameController = TextEditingController();
  final projectDescriptionController = TextEditingController();
  final hostnameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _pageOneVisible = true; bool _pageTwoVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Page 1: Project name & description
            Visibility(
              visible: _pageOneVisible,
              child: in_app_textfield(
                  controller: projectNameController,
                  hintText: 'Robbie the Robot',
                  obsureText: false,
                  titleText: 'Project Name'),
            ),
            Gap(20),
            Visibility(
              visible: _pageOneVisible,
              child: in_app_textfield(
                  controller: projectDescriptionController,
                  hintText: 'A robot to help clean my work desk',
                  obsureText: false,
                  titleText: 'Description'),
            ),

            //Page 2: Host information
            Visibility(
              visible: _pageTwoVisible,
              child: in_app_textfield(
                  controller: hostnameController,
                  hintText: 'raspberrypi.local',
                  obsureText: false,
                  titleText: 'Hostname'),
            ),
            Gap(20),
            Visibility(
              visible: _pageTwoVisible,
              child: in_app_textfield(
                  controller: usernameController,
                  hintText: '',
                  obsureText: false,
                  titleText: 'Username'),
            ),
            Gap(20),
            Visibility(
              visible: _pageTwoVisible,
              child: in_app_textfield(
                  controller: passwordController,
                  hintText: '',
                  obsureText: true,
                  titleText: 'Password'),
            ),
            Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(onPressed:(){ Navigator.pop(context); }, icon: const Icon(Icons.back_hand)),
                TextButton(
                    onPressed: (){
                      if(_pageOneVisible == false && _pageTwoVisible == true){
                        AddNewProject(
                          context,
                          projectNameController.text,
                          projectDescriptionController.text,
                          hostnameController.text,
                          usernameController.text,
                          passwordController.text
                        );
                      }
                      else{
                        setState(() {
                          _pageOneVisible = !_pageOneVisible; _pageTwoVisible = !_pageOneVisible;
                        });
                      }
                      },
                    child: const Text('hey'))
              ],
            )
          ],
        ),
      ),
    );
  }
}

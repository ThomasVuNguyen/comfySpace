import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:v2_1/comfyauth/authentication/components/text_field.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/beginner_project/add_project_suggestion.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/sendEmail.dart';
import 'package:v2_1/home_screen/components/set_user_info.dart';
import 'package:v2_1/universal_widget/buttons.dart';
import 'package:v2_1/universal_widget/talking_head.dart';

class beginnerProjectResponse extends StatelessWidget {
  const beginnerProjectResponse({super.key,
    required this.project_name, required this.project_description, required this.imgURL});
  final String project_name; final String project_description; final String imgURL;
  @override
  Widget build(BuildContext context) {
    TextEditingController noteTextController = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              talkingHead(text: 'Step 1, visualize your idea, is complete! A comfy team member will reach out within 48 hours. In the meantime, write down any extra note you like!'),

              in_app_textfield(
                  controller: noteTextController,
                  hintText: 'The cost should be minimal and build time is less than 2 hours',
                  obsureText: false,
                  titleText: 'Note',
                multiline: true,),
              Gap(40),
              clickable_text(
                  text: 'Finish',
                  onTap: () async{
                    Navigator.push(context, MaterialPageRoute(builder: (context) => thankYouNote()));
                    await AddNewBeginnerProject(context, project_name, project_description, imgURL, noteTextController.text);
                    await sendEmailAboutBeginnerProject(project_name, project_description, noteTextController.text);
                  }

              )
            ],
          ),
        ),
      ),
    );
  }
}

class thankYouNote extends StatelessWidget {
  const thankYouNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Thanks'),);
  }
}

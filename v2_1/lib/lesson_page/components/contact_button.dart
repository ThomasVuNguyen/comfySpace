import 'package:flutter/material.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/sendEmail.dart';
import 'package:v2_1/home_screen/components/set_user_info.dart';
import 'package:v2_1/universal_widget/buttons.dart';

class contact_button extends StatelessWidget {
  const contact_button({super.key, required this.text, required this.lessonName});
  final String text; final String lessonName;
  @override
  Widget build(BuildContext context) {
    var commentController = TextEditingController();
    return clickable_text(
        text: text,
        onTap: () {
          showDialog(context: context, builder: (context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  in_app_textfield(
                    multiline: true,
                      controller: commentController,
                      hintText: 'Share with us your opinion!',
                      obsureText: false,
                      titleText: 'Send us a message'
                  )
                ],
              ),
              actions: [
                clickable(
                    icon: Icons.email_outlined,
                    onTap: () async{
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Thanks for sending us a message!')));
                      await sendEmailAboutLesson(lessonName, commentController.text);
                    })
              ],
            );
          });
        }
    );
  }
}

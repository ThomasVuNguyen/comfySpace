
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'instruction_text.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({super.key,
    required this.project_name, required this.project_description, required this.imgURL,
    required this.hostname, required this.username, required this.password,
    required this.imgPath, required this.text, this.nextButton = const Gap(0)
  });
  final String project_name; final String project_description; final String imgURL;
  final String hostname; final String username; final String password;
  final String imgPath; final String text; final Widget nextButton;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(imgPath),
            instructionTitle(text: text),
            nextButton
          ],
        ),
      ),
    );
  }
}
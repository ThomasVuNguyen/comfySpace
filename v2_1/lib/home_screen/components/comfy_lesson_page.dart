import 'package:flutter/material.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/lesson_function.dart';

class ComfyLessonPage extends StatelessWidget {
  const ComfyLessonPage({super.key, required this.lesson});
  final comfy_lesson lesson;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lesson.title!),),
      body: Column(
      ),
    );
  }
}

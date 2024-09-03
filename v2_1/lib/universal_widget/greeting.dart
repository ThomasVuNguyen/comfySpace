import 'dart:math';

import 'package:flutter/material.dart';
import 'package:v2_1/themes/app_color.dart';

class randomGreeting extends StatelessWidget {
  const randomGreeting({super.key, this.name =''});
  final String name;
  @override
  Widget build(BuildContext context) {
    List<String> greetingList = [
      'Salut',
      'Ciao',
      'Hi',
      'Hello',
      'Greetings',
      'Howdy',
      'Konnichiwa',
      //'How\'s it going'
    ];
    int widgetIndex = Random().nextInt(greetingList.length);
    return Text(
      '${greetingList[widgetIndex]}! $name',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.black
    ));
  }
}

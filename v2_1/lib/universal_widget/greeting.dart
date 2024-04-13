import 'dart:math';

import 'package:flutter/material.dart';

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
      'How\'s it going'
    ];
    int _widgetIndex = Random().nextInt(greetingList.length);
    return Text(
      '${greetingList[_widgetIndex]}, $name',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.tertiary
    ));
  }
}

import 'package:flutter/material.dart';

class instructionTitle extends StatelessWidget {
  const instructionTitle({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}

class instructionBody extends StatelessWidget {
  const instructionBody({super.key, required this.text});
final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}


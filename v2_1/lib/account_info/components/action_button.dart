import 'package:flutter/material.dart';
import 'package:slidable_button/slidable_button.dart';

class account_action_button extends StatefulWidget {
  const account_action_button(
      {super.key,
      required this.color,
      required this.text,
      required this.function});
  final String text;
  final Color color;
  final Function() function;
  @override
  State<account_action_button> createState() => _account_action_buttonState();
}

class _account_action_buttonState extends State<account_action_button> {
  @override
  Widget build(BuildContext context) {
    return HorizontalSlidableButton(
      width: MediaQuery.of(context).size.width / 2,
      buttonWidth: 60.0,
      color: widget.color.withOpacity(0.5),
      buttonColor: Theme.of(context).primaryColor,
      dismissible: false,
      label: const Center(child: Text('Slide Me')),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Left'),
            Text('Right'),
          ],
        ),
      ),
      onChanged: (position) {
        setState(() async {
          if (position == SlidableButtonPosition.end) {
            widget.function;
          } else {}
        });
      },
    );
  }
}

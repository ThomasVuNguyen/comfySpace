import 'package:flutter/material.dart';

class information_field extends StatelessWidget {
  const information_field({super.key, required this.title, required this.info});
  final String title; final String info;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: FractionallySizedBox(
              widthFactor: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(title,
                  style: Theme.of(context).textTheme.labelLarge,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
          ),
          Flexible(
            child: FractionallySizedBox(
              widthFactor: 1,
              child: Padding(
                padding: const EdgeInsets.only(right: 0),
                child: Text(info,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.secondary),
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

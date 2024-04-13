import 'package:flutter/material.dart';

class userExperienceCard extends StatelessWidget {
  const userExperienceCard({
    super.key, required this.title, required this.subtitle, required this.img
  });
  final String title; final String subtitle; final String img;
  @override
  Widget build(BuildContext context) {
    return Container(
      /*constraints: BoxConstraints(
        maxWidth: 1000, maxHeight: 1000
      ),*/
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2)
      ),
      //MediaQuery.of(context).size.width*2/3,

      //MediaQuery.of(context).size.height/2,
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary)
          ),
          Image.asset(img),
          Text(subtitle, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.primary)),
        ],
      ),
    );
  }
}

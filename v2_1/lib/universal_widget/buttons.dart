import 'package:flutter/material.dart';

class clickable extends StatelessWidget {
  const clickable({super.key, required this.icon, required this.onTap});
  final IconData icon; final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50, height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.tertiaryContainer,
          //border: Border.all(color: Theme.of(context).colorScheme.onBackground)
        ),
        child: Icon(icon, color: Theme.of(context).colorScheme.onTertiaryContainer)
      ),
    );
  }
}

class clickable_text extends StatelessWidget {
  const clickable_text({super.key, required this.text, required this.onTap, this.color = null, this.textColor = null});
  final String text; final Function() onTap; final Color? color; final Color? textColor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color: (color == null)?
            Colors.transparent:
                color
            ,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                width: 2.0,
                color: (textColor == null)?
                Theme.of(context).colorScheme.primary:  textColor!
            )
        ),
        child: Text(
          text,
          style: (textColor == null)?
          Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.tertiary):
          Theme.of(context).textTheme.labelLarge!.copyWith(color: textColor)
          ,
        ),
      ),
    );
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: (color == null)?
            Theme.of(context).colorScheme.tertiaryContainer:
            color,
            //border: Border.all(color: Theme.of(context).colorScheme.onBackground)
          ),
          child: Text(
              text,
              style: (textColor == null)?
              Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.tertiary):
              Theme.of(context).textTheme.titleMedium?.copyWith(color: textColor)
          )
      ),
    );
  }
}


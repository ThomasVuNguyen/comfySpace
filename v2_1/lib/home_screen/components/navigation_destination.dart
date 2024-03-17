import 'package:flutter/material.dart';

class navigation_destination extends StatelessWidget {
  const navigation_destination({super.key, required this.icon, required this.label});
  final String label; final Icon icon;
  @override
  Widget build(BuildContext context) {
    return NavigationDestination(
        icon: icon,
        label: label,

    );
  }
}

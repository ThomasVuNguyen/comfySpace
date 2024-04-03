import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({super.key, required this.assetPath, required this.color});
  final String assetPath; final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16)
      ),
      height:60, width: 60,
      child: Center(child: Image.asset(assetPath, height: 24,)),
    );
  }
}

class FloatingButtonIcon extends StatelessWidget {
  const FloatingButtonIcon({super.key, required this.icon, required this.bgcolor, required this.iconColor});
  final Color bgcolor; final Color iconColor; final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: bgcolor,
          borderRadius: BorderRadius.circular(16)
      ),
      height:60, width:60,
      child: Center(child: Icon(icon, size: 24,color: iconColor,))
    );
  }
}

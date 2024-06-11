import 'package:flutter/material.dart';

class avatar_icon extends StatelessWidget {
  const avatar_icon({super.key, this.size = 35});
  final double size;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Image.asset('assets/froggie/froggie-basic.png', height: size,),
    );
  }
}

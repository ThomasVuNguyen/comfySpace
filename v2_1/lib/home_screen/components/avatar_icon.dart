import 'package:flutter/material.dart';

class avatar_icon extends StatelessWidget {
  const avatar_icon({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.network('https://blog.prototion.com/content/images/2021/09/peep-1.png', height: 50,);
  }
}

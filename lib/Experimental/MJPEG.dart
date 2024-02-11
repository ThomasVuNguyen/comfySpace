import 'package:flutter/cupertino.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'dart:io';

class MjpegPlayerCF extends StatelessWidget {
  const MjpegPlayerCF({super.key});

  @override
  Widget build(BuildContext context) {
    return Mjpeg(
      stream: 'http://rover.local:8000',
    );
  }
}

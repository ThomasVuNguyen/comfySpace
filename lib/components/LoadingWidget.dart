import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class LoadingWaveDots extends StatelessWidget {
  const LoadingWaveDots({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.waveDots(color: Colors.teal, size: 20.0);
  }
}

class LoadingHalfTriangle extends StatelessWidget {
  const LoadingHalfTriangle({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.halfTriangleDot(color: Colors.teal, size: 20.0);
  }
}

class LoadingSpaceWidget extends StatelessWidget {
  const LoadingSpaceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: const LoadingHalfTriangle(),
      ),
    );
  }
}

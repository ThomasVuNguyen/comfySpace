import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class talkingHead extends StatelessWidget {
  const talkingHead({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
                'assets/froggie/froggie-basic.png',
              width: 50,
              height: 50,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 10,
              bottom: 30
            ),
            child: Container(
              width: MediaQuery.of(context).size.width - 80,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )
              ),
              padding: const EdgeInsets.all(16),
              child: AnimatedTextKit(
                  totalRepeatCount: 1,
                  animatedTexts: [
                    TypewriterAnimatedText(
                        text,
                        speed: const Duration(milliseconds: 80),
                        textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSecondaryContainer
                        )
                    ),
                  ]),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:v2_1/home_screen/home_screen.dart';
import 'package:v2_1/universal_widget/buttons.dart';

class beginnerProjectMessage extends StatelessWidget {
  const beginnerProjectMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary
            ]
          )
        ),
        child: SafeArea(
            child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1000, maxHeight: 500),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).colorScheme.secondaryContainer
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center , crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 264),
                            child: Text('Project Status',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
                            )),
                        const Gap(20),
                        ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 264),
                            child: Text(
                                'Your project is currently being reviewed by the Comfy Team. We will be in touch less than 48 hours!',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
                            )),
                        const Gap(20),
                        ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 264),
                            child: Text(
                                'In the mean time, perhaps you would like to read some of our articles?',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
                            )),
                        const Gap(20),
                        Image.asset(
                          filterQuality: FilterQuality.high,
                            'assets/notion_style/friendly_thomas.png',
                          scale: 0.8,
                        ),
                        const Gap(20),
                        clickable_text(text: 'Read', onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen(pageIndex: 1,)));
                        })
                      ],
                    ),
                  ),
                )
            )),
      ),
    );
  }
}

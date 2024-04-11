import 'package:animated_introduction/animated_introduction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:gap/gap.dart';
import 'package:v2_1/comfyauth/authentication/LoginOrRegister.dart';

class overall_summary_screen extends StatelessWidget {
  const overall_summary_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(
      finishButtonText: 'Get started!',
      finishButtonStyle: FinishButtonStyle(
        focusColor: Theme.of(context).colorScheme.primary,
        splashColor: Theme.of(context).colorScheme.primary,
        hoverColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        foregroundColor:  Theme.of(context).colorScheme.onBackground,
      ),
      hasSkip: true,
        totalPage: 3,
        headerBackgroundColor: Theme.of(context).colorScheme.onBackground,
        background: [
          Container(color: Theme.of(context).colorScheme.background),
          Container(color: Theme.of(context).colorScheme.background),
          Container(color: Theme.of(context).colorScheme.background)
        ],
        speed: 1,
        pageBodies: [
          WelcomePage(
              img: Image.asset('assets/comfy_logo_no_background.png', width: 220,),
              title: 'Comfy Space',
              subtext: 'A comfortable robotic experience for creatives'),
          WelcomePage(
              img: Image.asset('assets/froggie/frog_side_by_side.png'),
              title: 'For robotic beginners',
              subtext: 'Let us know your idea, Comfy will provide suggestions regardless of knowledge level'),
          WelcomePage(
              img: Image.asset('assets/froggie/froggie_happy.png'),
              title: 'For robotic veterans',
              subtext: 'Comfy provides tools to simplify your development & make final product nicer'),
        ],
        onFinish: (){
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginOrRegister())
      );
    },

    );

  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key, required this.img, required this.title, required this.subtext});
  final Widget img; final String title; final String subtext;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Animate(
        effects: const [FadeEffect(), ScaleEffect()],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              img,
              const Gap(60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 65),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Theme.of(context).colorScheme.tertiary),
                  textAlign: TextAlign.center,
                ),
              ),
              const Gap(20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 65),
                child: Text(
                  subtext,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.tertiary),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

    /*
    return AnimatedIntroduction(
      activeDotColor: Theme.of(context).colorScheme.primaryContainer,
      textColor: Theme.of(context).colorScheme.primaryContainer,
      containerBg: Theme.of(context).colorScheme.primaryContainer,
        doneText: 'Get started',
        slides: [
          SingleIntroScreen(
            title: 'Welcome to the Comfy Space !',
            description: 'Comfortable robotics for creatives',
            imageAsset: 'assets/froggie/tap-on.png',
            textStyle: Theme.of(context).textTheme.titleMedium,
          ),
          SingleIntroScreen(
            title: 'For beginners to robotics',
            description: 'To help you bring your vision to life, comfy provides quick lessons & suggestions. Just tell us what your idea is!',
            imageAsset: 'assets/froggie/tap-on.png',
              textStyle: Theme.of(context).textTheme.titleMedium,
              imageWithBubble: false,
              mainCircleBgColor: Colors.red,
              sideDotsBgColor: Colors.red
          ),
          SingleIntroScreen(
            title: 'For robotic veteran',
            description: 'Comfy has tools to make your development simpler & final project more polished!',
            imageAsset: 'assets/froggie/tap-on.png',
              textStyle: Theme.of(context).textTheme.titleMedium,
              imageWithBubble: false,
              mainCircleBgColor: Colors.red,
              sideDotsBgColor: Colors.red
          ),
        ],
        onDone: (){Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginOrRegister())
        );}
    );*/
    /*Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Describe what we do'),
          TextButton(
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginOrRegister())
                );
              },
              child: Text('next')
          )
        ],
      ),
    );*/



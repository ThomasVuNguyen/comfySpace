import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/user_information.dart';

import '../themes/app_color.dart';
import '../universal_widget/greeting.dart';

class welcome_page extends StatelessWidget {
  const welcome_page({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: get_user_information(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  randomGreeting(
                    name: snapshot.data!.name!,
                  ),
                  Text('Welcome to ComfySpace',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: AppColors.black)),
                  Gap(12),
                  Text(
                      'This is a hub for you to learn about the exciting world of robotics, and even build one for yourself!',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: AppColors.black)),
                  Gap(12),
                  Text('Here are a few things to get started with, have fun!',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: AppColors.black)),
                  Gap(32),
                  GestureDetector(
                      onTap: () {
                        launchUrl(Uri.parse('https://comfyspace.tech/build'));
                      },
                      child: Image.asset(
                          'assets/home_screen/comfy_build_block.png')),
                  Gap(20),
                  GestureDetector(
                      onTap: () {
                        launchUrl(Uri.parse('https://comfyspace.tech/learn'));
                      },
                      child: Image.asset(
                          'assets/home_screen/comfy_academy_block.png')),
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }
}

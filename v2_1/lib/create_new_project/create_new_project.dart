import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:unsplash_client/unsplash_client.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:v2_1/chat_ui/chat_ui.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/edit_button.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/unsplash/generate_image.dart';
import 'package:v2_1/home_screen/components/project_list.dart';
import 'package:v2_1/home_screen/components/set_user_info.dart';
import 'package:v2_1/home_screen/components/user_experience_card.dart';
import 'package:v2_1/home_screen/home_screen.dart';
import 'package:v2_1/project_space_screen/function/static_ip_function.dart';
import 'package:v2_1/universal_widget/buttons.dart';
import 'package:v2_1/universal_widget/random_widget_loading.dart';
import 'package:v2_1/universal_widget/talking_head.dart';

import '../home_screen/comfy_user_information_function/beginner_project/add_project_suggestion.dart';
import '../home_screen/comfy_user_information_function/sendEmail.dart';

String imgURLPlaceHolder = '';

class create_new_project extends StatefulWidget {
  const create_new_project({super.key});

  @override
  State<create_new_project> createState() => _create_new_projectState();
}

class _create_new_projectState extends State<create_new_project> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: chatPage(
            questions: {
              'project_name': ['Hi there! Let\'s create a project together', 'Pick a cool name for your project!', 'Example: Rumble Robot, Chatty Bot, Dope Drone, etc.'],
              'project_description':['In one short sentence, describe what you\'re building!', 'Example: A traversal remote-controlled car with a camera mounted']
            },
            answers: {}, title: 'Create a robotic project',
            pageName: 'create_new_project_pick_name',
          )
        ),
      ),
    );
  }
}





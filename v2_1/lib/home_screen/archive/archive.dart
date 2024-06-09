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
import 'package:v2_1/home_screen/comfy_user_information_function/edit_button.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/unsplash/generate_image.dart';
import 'package:v2_1/home_screen/components/project_list.dart';
import 'package:v2_1/home_screen/components/set_user_info.dart';
import 'package:v2_1/home_screen/components/user_experience_card.dart';
import 'package:v2_1/home_screen/home_screen.dart';
import 'package:v2_1/project_space_screen/function/static_ip_function.dart';
import 'package:v2_1/universal_widget/buttons.dart';
import 'package:v2_1/universal_widget/random_widget_loading.dart';

import '../comfy_user_information_function/add_project.dart';
import '../comfy_user_information_function/sendEmail.dart';

class create_new_project_archive extends StatefulWidget {
  const create_new_project_archive({super.key});

  @override
  State<create_new_project_archive> createState() => _create_new_project_archiveState();
}

class _create_new_project_archiveState extends State<create_new_project_archive> {
  String imgURLPlaceHolder = '';
  final projectNameController = TextEditingController();
  final projectDescriptionController = TextEditingController();

  List<String> userExperienceLevelList = ['beginner', 'masterful'];
  List<String> userExperienceDescriptionList = [
    'You have a great idea and just needs help with putting together - hardware & software.',
    'You have an idea and have a good general understanding of Raspberry PI, SSH, and electronics.'
  ];
  List<String> userExperienceImageList = [
    'assets/froggie/swipe up.png',
    'assets/froggie/froggie_happy.png'
  ];
  int userExperienceIndex = 0;

  final ideaDescriptionController = TextEditingController();

  final hostnameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool _pageProjectNameAndDescription = true;
  bool _pagePicImage = false;
  bool _pageHostInformation = false;
  bool _pageProjectCardPreview = false;
  bool _pageFiveVisible = false;

  bool _pageExperienceQuestion = false;
  bool _pageIdeaInformation = false;

  Future<void> navigate() async {
    if(_pageProjectNameAndDescription == true){
      if(projectNameController.text == '' || projectDescriptionController.text == ''){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Project name & description cannot be empty')));
      }
      else{
        setState(() {
          _pageProjectNameAndDescription = !_pageProjectNameAndDescription;
          _pagePicImage = true;
          _pageHostInformation = false;
          _pageProjectCardPreview = false;
          _pageFiveVisible = false;
        });
      }
    }
    else if(_pagePicImage == true){
      setState(() {
        _pageProjectNameAndDescription = false;
        _pagePicImage = false;
        _pageExperienceQuestion = true;
        _pageIdeaInformation = false;
        _pageHostInformation = false;
        _pageProjectCardPreview = false;
        _pageFiveVisible = false;
      });
    }
    else if(_pageExperienceQuestion == true) {
      if (userExperienceIndex == 0) {
        setState(() {
          _pageProjectNameAndDescription = false;
          _pagePicImage = false;
          _pageExperienceQuestion = false;
          _pageIdeaInformation = true;
          _pageHostInformation = false;
          _pageProjectCardPreview = false;
          _pageFiveVisible = false;
        });
      }
      else {
        setState(() {
          _pageProjectNameAndDescription = false;
          _pagePicImage = false;
          _pageExperienceQuestion = false;
          _pageIdeaInformation = false;
          _pageHostInformation = true;
          _pageProjectCardPreview = false;
          _pageFiveVisible = false;
        });
      }
    }
    else if(_pageIdeaInformation == true){
      await AddNewProject(
          context,
          projectNameController.text,
          projectDescriptionController.text,
          'pending beginner project',
          ideaDescriptionController.text,
          'pending beginner project',
          imgURLPlaceHolder);
      await AddNewBeginnerProject(
        context,
        projectNameController.text,
        projectDescriptionController.text,
        imgURLPlaceHolder,
        ideaDescriptionController.text,
      );
      try{
        await sendEmailAboutBeginnerProject(
            projectNameController.text,
            projectDescriptionController.text,
            ideaDescriptionController.text
        );
      } catch (e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('email sending failed')));
      }

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
    else if(_pageHostInformation == true){
      setState(() {
        _pageProjectNameAndDescription = false;
        _pagePicImage = false;
        _pageHostInformation = false;
        _pageProjectCardPreview = true;
        _pageFiveVisible = false;
      });
    }
    /*else if(_pageFourVisible == true){
                            try{
                              print('acquiring static ip');
                              await acquireStaticIP(hostnameController.text, usernameController.text, passwordController.text).timeout(Duration(seconds: 5));
                              setState(() {
                                _pageOneVisible = false;
                                _pageTwoVisible = false;
                                _pageThreeVisible = false;
                                _pageFourVisible = !_pageFourVisible;
                                _pageFiveVisible = true;
                              });
                            } on TimeoutException{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Timeout finding the Raspberry Pi on network')));
                              print('time out acquiring static ip');
                              setState(() {
                                _pageOneVisible = false;
                                _pageTwoVisible = false;
                                _pageThreeVisible = false;
                                _pageFourVisible = !_pageFourVisible;
                                _pageFiveVisible = true;
                              });
                            }
                            catch (e){
                              print('error acquiring static ip: $e');
                              setState(() {
                                _pageOneVisible = false;
                                _pageTwoVisible = false;
                                _pageThreeVisible = false;
                                _pageFourVisible = !_pageFourVisible;
                                _pageFiveVisible = true;
                              });
                            }


                          }*/
    else if(
    //_pageFiveVisible == true
    _pageProjectCardPreview == true
    ){
      AddNewProject(
          context,
          projectNameController.text,
          projectDescriptionController.text,
          hostnameController.text,
          usernameController.text,
          passwordController.text,
          imgURLPlaceHolder
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Page 1: Project name & description
                Visibility(
                    visible: _pageProjectNameAndDescription,
                    child: Text(
                        'What would you call this project?',
                        style: Theme.of(context).textTheme.titleMedium
                    )
                ),
                Visibility(
                    visible: _pageProjectNameAndDescription,
                    child: Gap(20)),

                Visibility(
                    visible: _pageProjectNameAndDescription,
                    child: Image.asset('assets/froggie/create_project_pick_name.png')),

                Visibility(
                    visible: _pageHostInformation,
                    child: Text('Enter host information', style: Theme.of(context).textTheme.titleMedium)
                ),

                Gap(20),
                Visibility(
                  visible: _pageProjectNameAndDescription,
                  child: in_app_textfield(
                      controller: projectNameController,
                      hintText: 'Robbie the Robot',
                      obsureText: false,
                      titleText: 'Project Name'),
                ),
                Gap(20),
                Visibility(
                  visible: _pageProjectNameAndDescription,
                  child: in_app_textfield(
                      controller: projectDescriptionController,
                      hintText: 'A robot to help clean my work desk',
                      obsureText: false,
                      titleText: 'Description'),
                ),
                //Page 2: generate image

                Visibility(
                    visible: _pagePicImage,
                    child: Text('Pick an image!', style: Theme.of(context).textTheme.titleMedium)
                ),

                Visibility(
                  visible: _pagePicImage,
                  child: Text('Placeholder')
                  //coverImageGenerator(query: projectNameController.text,),
                ),
                Visibility(visible: _pagePicImage, child: Gap(20)),
                Visibility(visible: _pagePicImage, child: Text(
                  '*Image generated based on Project Name by Unsplash',
                  style: Theme.of(context).textTheme.titleSmall,
                )),

                //Page 2.5: Experience level question
                Visibility(
                    visible: _pageExperienceQuestion,
                    child: Text(
                        'How would you describe yourself ?',
                        style: Theme.of(context).textTheme.titleMedium
                    )
                ),
                Visibility(child: Gap(40), visible: _pageExperienceQuestion,),
                Visibility(
                  visible: _pageExperienceQuestion,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
                    child: Swiper(
                      //pagination: SwiperPagination(),
                      control: const SwiperControl(),
                      itemCount: userExperienceLevelList.length,
                      viewportFraction: 0.8,
                      scale: 0.9,
                      itemBuilder: (context, index){
                        return userExperienceCard(
                            title: userExperienceLevelList[index],
                            subtitle: userExperienceDescriptionList[index],
                            img: userExperienceImageList[index]);
                      },
                      onIndexChanged: (index){
                        userExperienceIndex = index;
                        print('user experience ${userExperienceLevelList[index]}');
                      },
                    ),
                  ),
                ),

                //Page 3: Project description

                Visibility(
                  visible: _pageIdeaInformation,
                  child: AnimatedTextKit(
                    isRepeatingAnimation: false,
                    animatedTexts: [
                      TypewriterAnimatedText(
                          'Is there anything else you would like to add?',
                          textAlign: TextAlign.center, textStyle: Theme.of(context).textTheme.titleMedium,
                          speed: const Duration(milliseconds: 100)
                      ),
                      TypewriterAnimatedText(
                          'Such as a functionality you like or favorite color, feel free to share anything!',
                          textAlign: TextAlign.center, textStyle: Theme.of(context).textTheme.titleMedium,
                          speed: const Duration(milliseconds: 100)
                      ),
                    ],

                  ),

                ),
                Visibility(
                    visible: _pageIdeaInformation,
                    child: Gap(40)),
                Visibility(
                  visible: _pageIdeaInformation,
                  child: in_app_textfield(
                      controller: ideaDescriptionController,
                      multiline: true,
                      hintText: 'I would like it to be portable, environmentally-friendly, and green please. Thank you!',
                      obsureText: false,
                      titleText: ''),
                ),

                //Page 3: Host information
                Gap(20),
                Visibility(
                    visible: _pageHostInformation,
                    child: Image.asset('assets/raspberrypi_4.png')
                ),
                Gap(20),
                Visibility(
                  visible: _pageHostInformation,
                  child: in_app_textfield(
                      controller: hostnameController,
                      hintText: 'raspberrypi.local',
                      obsureText: false,
                      titleText: 'Hostname'),
                ),
                Gap(20),
                Visibility(
                  visible: _pageHostInformation,
                  child: in_app_textfield(
                      controller: usernameController,
                      hintText: '',
                      obsureText: false,
                      titleText: 'Username'),
                ),
                Gap(20),
                Visibility(
                  visible: _pageHostInformation,
                  child: in_app_textfield(
                      controller: passwordController,
                      hintText: '',
                      obsureText: true,
                      titleText: 'Password'),
                ),
                Visibility(
                    visible: _pageHostInformation,
                    child: const Gap(20)
                ),
                Visibility(
                    visible: _pageHostInformation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      child: Text(
                        'If you don\'t have it nor know what this is, it\'s ok just to skip ahead!',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    )
                ),

                //Page 4: Detecting your raspberry pi
                Visibility(
                  visible: _pageProjectCardPreview,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: AnimatedTextKit(
                      isRepeatingAnimation: false,
                      animatedTexts: [
                        TypewriterAnimatedText(
                            'Here is your project card, in the future, you can click on it to open!',
                            textAlign: TextAlign.center, textStyle: Theme.of(context).textTheme.titleMedium,
                            speed: const Duration(milliseconds: 100)
                        ),
                      ],
                      onTap: () {
                      },
                    ),
                  ),
                  //Text('loading animation here')
                ),
                Visibility(
                    visible: _pageProjectCardPreview,
                    child: IgnorePointer(
                      child: project_card(
                        project_name: projectNameController.text,
                        project_description: projectDescriptionController.text,
                        hostname: '', username: '', password: '',
                        imgURL: imgURLPlaceHolder,
                      ),
                    )
                  //Text('loading animation here')
                ),


                //Page 5: Scanning result
                Visibility(
                    visible: _pageFiveVisible,
                    child: Text('Scanning result here')),
                Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: clickable(
                          icon: Icons.arrow_back,
                          onTap: (){Navigator.pop(context);}),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: clickable(
                          icon: Icons.arrow_forward,
                          onTap: navigate
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
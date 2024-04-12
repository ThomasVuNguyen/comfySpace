import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:unsplash_client/unsplash_client.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/edit_button.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/unsplash/generate_image.dart';
import 'package:v2_1/home_screen/components/project_list.dart';
import 'package:v2_1/home_screen/components/set_user_info.dart';
import 'package:v2_1/home_screen/home_screen.dart';
import 'package:v2_1/project_space_screen/function/static_ip_function.dart';
import 'package:v2_1/universal_widget/buttons.dart';
import 'package:v2_1/universal_widget/random_widget_loading.dart';

String imgURLPlaceHolder = '';
class create_new_project extends StatefulWidget {
  const create_new_project({super.key});

  @override
  State<create_new_project> createState() => _create_new_projectState();
}

class _create_new_projectState extends State<create_new_project> {
  final projectNameController = TextEditingController();
  final projectDescriptionController = TextEditingController();
  final hostnameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _pageOneVisible = true;
  bool _pageTwoVisible = false;
  bool _pageThreeVisible = false;
  bool _pageFourVisible = false;
  bool _pageFiveVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Page 1: Project name & description

              Visibility(
                visible: _pageOneVisible,
                  child: Image.asset('assets/froggie/create_project_pick_name.png')),

              Visibility(
                  visible: _pageTwoVisible,
                  child: Text('Pick an image!', style: Theme.of(context).textTheme.titleMedium)
              ),

              Visibility(
                  visible: _pageThreeVisible,
                  child: Text('Enter host information', style: Theme.of(context).textTheme.titleMedium)
              ),

              Gap(20),
              Visibility(
                visible: _pageOneVisible,
                child: in_app_textfield(
                    controller: projectNameController,
                    hintText: 'Robbie the Robot',
                    obsureText: false,
                    titleText: 'Project Name'),
              ),
              Gap(20),
              Visibility(
                visible: _pageOneVisible,
                child: in_app_textfield(
                    controller: projectDescriptionController,
                    hintText: 'A robot to help clean my work desk',
                    obsureText: false,
                    titleText: 'Description'),
              ),
              //Page 2: generate image
              Visibility(
                visible: _pageTwoVisible,
                  child: coverImageGenerator(query: projectNameController.text,),
              ),
              //Page 3: Host information

              Gap(20),
              Visibility(
                visible: _pageThreeVisible,
                  child: Image.asset('assets/raspberrypi_4.png')
              ),
              Gap(20),
              Visibility(
                visible: _pageThreeVisible,
                child: in_app_textfield(
                    controller: hostnameController,
                    hintText: 'raspberrypi.local',
                    obsureText: false,
                    titleText: 'Hostname'),
              ),
              Gap(20),
              Visibility(
                visible: _pageThreeVisible,
                child: in_app_textfield(
                    controller: usernameController,
                    hintText: '',
                    obsureText: false,
                    titleText: 'Username'),
              ),
              Gap(20),
              Visibility(
                visible: _pageThreeVisible,
                child: in_app_textfield(
                    controller: passwordController,
                    hintText: '',
                    obsureText: true,
                    titleText: 'Password'),
              ),
              //Page 4: Detecting your raspberry pi
              Visibility(
                  visible: _pageFourVisible,
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
                visible: _pageFourVisible,
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
                      onTap: () async {
                        if(_pageOneVisible == true){
                          if(projectNameController.text == '' || projectDescriptionController.text == ''){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Project name & description cannot be empty')));
                          }
                          else{
                            setState(() {
                              _pageOneVisible = !_pageOneVisible;
                              _pageTwoVisible = true;
                              _pageThreeVisible = false;
                              _pageFourVisible = false;
                              _pageFiveVisible = false;
                            });
                          }
          
                        }
                        else if(_pageTwoVisible == true){
                          setState(() {
                            _pageOneVisible = false;
                            _pageTwoVisible = !_pageTwoVisible;
                            _pageThreeVisible = true;
                            _pageFourVisible = false;
                            _pageFiveVisible = false;
                          });
                        }
                        else if(_pageThreeVisible == true){
                          setState(() {
                            _pageOneVisible = false;
                            _pageTwoVisible = false;
                            _pageThreeVisible = !_pageThreeVisible;
                            _pageFourVisible = true;
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
                        _pageFourVisible == true
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
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class coverImageGenerator extends StatefulWidget {
  const coverImageGenerator({super.key, required this.query});
  final String query;
  @override
  State<coverImageGenerator> createState() => _coverImageGeneratorState();
}

class _coverImageGeneratorState extends State<coverImageGenerator> {
  @override
  void initState() {
    print('unsplash reload');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 500,
      ),
      child:
      Stack(
        alignment: Alignment.topRight,
        children: [
          FutureBuilder(
              future: search_image(widget.query), 
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  List<String> imgURL = [];
                  imgURLPlaceHolder = snapshot.data![0].urls.full.toString();
                  for (int i = 0; i< snapshot.data!.length; i++){
                    imgURL.add(snapshot.data![i].urls.full.toString());
                  }
                  return Container(
                    width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height/3,
                    child: Swiper(
                      onIndexChanged: (index){
                        print(index);
                        imgURLPlaceHolder = imgURL[index];
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return Image.network(
                          imgURL[index],
                          fit: BoxFit.fitWidth,
                        );
                      },
                      itemCount: imgURL.length,
                      viewportFraction: 0.8,
                      scale: 0.9,
                    ),
                  );
                  return AspectRatio(
                    aspectRatio: 2/1,
                      child: Image.network(snapshot.data![0].urls.full.toString(),
                        fit: BoxFit.cover,
                      ));
                }
                else{
                  return const randomLoadingWidget();
                }
              }

          ),
          /*Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              //borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: Colors.transparent
              //Theme.of(context).colorScheme.onBackground,
              //border: Border.all(color: Theme.of(context).colorScheme.background, width: 1)
            ),
            child: IconButton(onPressed: (){
              setState(() {
              });}, icon:Icon(Icons.refresh, color: Theme.of(context).colorScheme.background,)))*/

        ],
      ),
    );
  }
}

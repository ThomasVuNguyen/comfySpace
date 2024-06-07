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

import '../comfy_user_information_function/beginner_project/add_project_suggestion.dart';
import '../comfy_user_information_function/sendEmail.dart';

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


class pickProjectImage extends StatefulWidget {
  const pickProjectImage({super.key, 
  required this.project_name, required this.project_description});
  final String project_name; final String project_description;
  @override
  State<pickProjectImage> createState() => _pickProjectImageState();
}

class _pickProjectImageState extends State<pickProjectImage> {
  @override
  void initState() {
    if (kDebugMode) {
      print('unsplash reload');
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Future<List<Photo>> photoSearch = search_image(widget.project_name);
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 500,
          ),
          child:
          Stack(
            alignment: Alignment.topRight,
            children: [
              FutureBuilder(
                  future: photoSearch,
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.done){
                      List<String> imgURL = [];
                      List<String> imgAuthor = [];
                      imgURLPlaceHolder = snapshot.data![0].urls.full.toString();
                      for (int i = 0; i< snapshot.data!.length; i++){
                        imgURL.add(snapshot.data![i].urls.full.toString());
                        imgAuthor.add(snapshot.data![i].user.name);
                      }
                      List<Photo> photoList = snapshot.data!;
                      return ListView.builder(
                        itemCount: photoList.length,
                          itemBuilder: (context, index){
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                                  border: Border.all(
                                      color: Theme.of(context).colorScheme.outline
                                  ),
                                  color: Theme.of(context).colorScheme.surface
                              ),

                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(11)),
                                    child: Image.network(
                                        photoList[index].urls.regular.toString(),
                                        fit: BoxFit.fitWidth
                                    ),
                                  ),
                                  GestureDetector(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(11)),
                                        color: Colors.white,
                                      ),
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(photoList[index].user.name),
                                    ),
                                    onTap: () async{
                                      await launchUrl(photoList[index].user.links.html);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                          }
                      );
                      /*return Container(
                        width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height/3,
                        child: Swiper(
                          pagination: SwiperPagination(),
                          control: SwiperControl(),
                          onIndexChanged: (index){
                            imgURLPlaceHolder = imgURL[index];
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Image.network(
                                  imgURL[index],
                                  fit: BoxFit.contain,
                                ),
                                Text(imgAuthor[index]),
                              ],
                            );
                          },
                          itemCount: imgURL.length,
                          //viewportFraction: 0.8,
                          //scale: 0.9,
                        ),
                      );*/
                    }
                    else{
                      return const randomLoadingWidget();
                    }
                  }

              ),

            ],
          ),
        ),
      ),
    );
  }
}


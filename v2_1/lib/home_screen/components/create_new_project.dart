import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:unsplash_client/unsplash_client.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/edit_button.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/unsplash/generate_image.dart';
import 'package:v2_1/home_screen/components/set_user_info.dart';
import 'package:v2_1/home_screen/home_screen.dart';

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Page 1: Project name & description
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
                child: Text('loading animation here')),

            //Page 5: Scanning result
            Visibility(
              visible: _pageFiveVisible,
                child: Text('Scanning result here')),

            Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(onPressed:(){ Navigator.pop(context); }, icon: const Icon(Icons.back_hand)),
                IconButton(
                    onPressed: (){
                      if(_pageOneVisible == true){
                        setState(() {
                          _pageOneVisible = !_pageOneVisible;
                          _pageTwoVisible = true;
                          _pageThreeVisible = false;
                          _pageFourVisible = false;
                          _pageFiveVisible = false;
                        });
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
                      else if(_pageFourVisible == true){
                        setState(() {
                          _pageOneVisible = false;
                          _pageTwoVisible = false;
                          _pageThreeVisible = false;
                          _pageFourVisible = !_pageFourVisible;
                          _pageFiveVisible = true;
                        });

                      }
                      else if(_pageFiveVisible == true){
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
                    icon: Icon(Icons.forward),)
              ],
            )
          ],
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
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          FutureBuilder(
              future: search_image(widget.query), 
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  imgURLPlaceHolder = snapshot.data![0].urls.full.toString();
                  return AspectRatio(
                    aspectRatio: 2/1,
                      child: Image.network(snapshot.data![0].urls.full.toString(),
                        fit: BoxFit.cover,
                      ));
                }
                else{
                  return CircularProgressIndicator();
                }
              }

          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              //borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: Colors.transparent
              //Theme.of(context).colorScheme.onBackground,
              //border: Border.all(color: Theme.of(context).colorScheme.background, width: 1)
            ),
            child: IconButton(onPressed: (){
              setState(() {
              });}, icon:Icon(Icons.refresh, color: Theme.of(context).colorScheme.background,)))

        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:v2_1/beginner_project_support/beginner_project_message.dart';
import 'package:v2_1/create_new_project/components/beginner_project_response.dart';
import 'package:v2_1/create_new_project/components/raspi_setup.dart';
import 'package:v2_1/universal_widget/talking_head.dart';

class experiencePicker extends StatelessWidget {
  const experiencePicker({super.key, required this.project_name, required this.project_description, required this.imgURL});
  final String project_name; final String project_description; final String imgURL;
  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> experienceDescription = [
      {'title': 'Beginner',
        'description': 'You are new to robotics. The terms Raspberry Pi, SSH, and DC Motor all sound foreign to you. You will get custom help from the Comfy team!',
        'img': 'https://images.unsplash.com/photo-1603354351149-e97b9124020d?q=80&w=2370&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
      },
      {'title': 'Practitioner',
        'description': 'You have experience with the craft of robotics. Raspberry Pi, SSH, and DC Motor all sound familiar to you. Comfy will help assist you at becoming even better!',
        'img': 'https://plus.unsplash.com/premium_photo-1663091699742-70ca6f835197?q=80&w=2372&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
      }
    ];
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              talkingHead(text: 'Great! Now that the project information is done, let\'s pick your experience level.'),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: experienceDescription.length,
                  itemBuilder: (context, index){
                return GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
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
                                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(11)),
                      child: Image.network(
                          experienceDescription[index]['img']!,
                          fit: BoxFit.fitWidth
                      ),
                    ),
                                  ),
                                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(11)),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      experienceDescription[index]['description']!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                                  ),
                                  Positioned(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(11)),
                                        color: Colors.white,
                                      ),
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        experienceDescription[index]['title']!,
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ),
                                    right: 0,
                                    top: 0,
                                  )


                                ],
                              ),
                            ),
                  ),
          onTap: (){
            //push to RaspberryPi Setup page or we-will-support page
            if(index == 0){
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  beginnerProjectResponse(project_name: project_name, project_description: project_description, imgURL: imgURL)));
            }
            if(index == 1){
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  raspberryPiSetup(
                    project_name: project_name,
                    project_description: project_description,
                    imgURL: imgURL,
                  )
              ));
            }
          },
                );
              }
              )
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:unsplash_client/unsplash_client.dart';
import 'package:v2_1/beginner_project_support/beginner_project_message.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/delete_project.dart';
import 'package:v2_1/universal_widget/random_widget_loading.dart';

import '../../project_space_screen/project_space.dart';
import '../comfy_user_information_function/project_information.dart';
import '../comfy_user_information_function/unsplash/generate_image.dart';

class project_list extends StatefulWidget {
  const project_list({super.key});

  @override
  State<project_list> createState() => _project_listState();
}

class _project_listState extends State<project_list> {
  var get_project = get_project_list_information();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: get_project,
        builder: (context, snapshot) {
          final projectList = snapshot.data;
          if (snapshot.connectionState != ConnectionState.done) {
            return const CircularProgressIndicator();
          }
          //If there's no project
          else if (snapshot.hasData == false) {
            return AnimatedTextKit(
              isRepeatingAnimation: false,
              animatedTexts: [
                TypewriterAnimatedText(
                    'Press the + button below to create a project!',
                    textAlign: TextAlign.center,
                    textStyle: Theme.of(context).textTheme.titleMedium,
                    speed: const Duration(milliseconds: 100)),
              ],
              onTap: () {},
            );
          } else {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: projectList!.length,
                itemBuilder: (context, index) {
                  if (kDebugMode) {
                    print('index is $index');
                  }
                  return project_card(
                    project_name: projectList[index].name,
                    project_description: projectList[index].description,
                    hostname: projectList[index].hostname,
                    port: projectList[index].port,
                    username: projectList[index].username,
                    password: projectList[index].password,
                    imgURL: projectList[index].imgURL,
                    type: projectList[index].type!,
                  );
                });
          }
        },
      ),
    );
  }
}

class project_card extends StatefulWidget {
  const project_card(
      {super.key,
      required this.project_name,
      required this.port,
      required this.project_description,
      required this.hostname,
      required this.username,
      required this.password,
      required this.imgURL,
      this.type = 'none'});
  final String? project_name;
  final String? project_description;
  final String? hostname;
  final int? port;
  final String? username;
  final String? password;
  final String? imgURL;
  final String type;
  @override
  State<project_card> createState() => _project_cardState();
}

class _project_cardState extends State<project_card> {
  @override
  void initState() {
    super.initState();
  }

  void openProjectSpace() {
    if (widget.hostname != '') {
      print('opening project space');
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => project_space(
                project_name: widget.project_name!,
                hostname: widget.hostname!,
                port: widget.port!,
                username: widget.username!,
                password: widget.password!,
                raspberryPiInit: true,
                type: widget.type,
              )));
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const beginnerProjectMessage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openProjectSpace,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  border:
                      Border.all(color: Theme.of(context).colorScheme.outline),
                  color: Theme.of(context).colorScheme.surface),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(11)),
                  child: Stack(alignment: Alignment.bottomLeft, children: [
                    AspectRatio(
                        aspectRatio: 2 / 1,
                        child: Image.network(
                          widget.imgURL!,
                          loadingBuilder: (context, child, loadingProgess) {
                            if (loadingProgess == null) {
                              return child;
                            } else {
                              return const Center(child: randomLoadingWidget());
                            }
                          },
                          errorBuilder: (context, object, stack) {
                            return const Center(child: randomLoadingWidget());
                          },
                          fit: BoxFit.cover,
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.project_name!,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        color: Theme.of(context).colorScheme.primary,
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await delete_project_prompt(widget.project_name!,
                              widget.project_description!, context);
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        color: Theme.of(context).colorScheme.onPrimary,
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: openProjectSpace,
                      ),
                    )
                  ])),
            ),
          ),
        ),
      ),
    );
  }
}
/*
class add_project_card extends StatefulWidget {
  const add_project_card({super.key, required this.title, required this.subtitle});
  final String title; final String subtitle;
  @override
  State<add_project_card> createState() => _add_project_cardState();
}

class _add_project_cardState extends State<add_project_card> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => create_new_project()));
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Theme.of(context).colorScheme.primaryContainer,
                       Theme.of(context).colorScheme.tertiaryContainer
                    ]
                )
              ),
              child: DottedBorder(
                color: Theme.of(context).colorScheme.outline,
                borderType: BorderType.RRect,
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
                radius: const Radius.circular(12),
                strokeWidth: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(height: 50, alignment: Alignment.center,
                          child: Text(
                            widget.title,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
                            textAlign: TextAlign.center,
                          )
                      ),
                    ),
                    Gap(10),
                    Center(
                      child: Container(
                          height: 30, alignment: Alignment.center,
                          child: Text(widget.subtitle, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onTertiaryContainer))
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}*/


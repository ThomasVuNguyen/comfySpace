import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rive/rive.dart';
import 'package:v2_1/comfyauth/authentication/components/signout.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/delete_project.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/edit_button.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/user_information.dart';
import 'package:v2_1/home_screen/components/set_user_info.dart';
import 'package:v2_1/home_screen/home_screen.dart';

import '../../project_space_screen/project_space.dart';
import '../comfy_user_information_function/project_information.dart';
import 'create_new_project.dart';

class project_list extends StatefulWidget {
  const project_list({super.key});

  @override
  State<project_list> createState() => _project_listState();
}

class _project_listState extends State<project_list> {
  var get_project = get_project_list_information();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height*.7,
        child: Center(
          child: FutureBuilder(
            future: get_project,
            builder: (context, snapshot){
              final project_list = snapshot.data;
              if(snapshot.connectionState != ConnectionState.done){
                return CircularProgressIndicator();
              }
              else if(snapshot.hasData == false){
                return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 500),
                    child: add_project_card(title: 'Fancy a project?', subtitle:  '~ click here to create one ~' ));
              }
              else{
                /*
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio:3/2,
                      crossAxisCount: (kIsWeb==true)? MediaQuery.of(context).size.width~/500 :1
                        //
                    ),
                    itemCount: project_list!.length + 1,
                    itemBuilder: (context, index){
                      if(index==project_list.length){
                        return add_project_card();
                      }
                      else{
                        return project_card(
                          project_name: project_list[index].name,
                          project_description: project_list[index].description,
                          hostname: project_list[index].hostname,
                          username: project_list[index].username,
                          password: project_list[index].password,
                        );
                      }
                    }
                );*/
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: project_list!.length+1,
                      itemBuilder: (context, index){
                      if (kDebugMode) {
                        print('index is $index');
                      }
                      if(index == project_list.length){
                        return add_project_card(title: 'Add a new project', subtitle: 'whatever your heart desrires');
                      }
                      else{
                        return project_card(
                          project_name: project_list[index].name,
                          project_description: project_list[index].description,
                          hostname: project_list[index].hostname,
                          username: project_list[index].username,
                          password: project_list[index].password,
                          imgURL: project_list[index].imgURL,
                        );
                      }



                      }
                  );
              }

            }
                ,),
            ),
      ),
    );
  }
}

class project_card extends StatefulWidget {
  const project_card({super.key, required this.project_name, required this.project_description,
    required this.hostname, required this.username, required this.password, required this.imgURL});
  final String? project_name; final String? project_description;
  final String? hostname; final String? username; final String? password;
  final String? imgURL;
  @override
  State<project_card> createState() => _project_cardState();
}

class _project_cardState extends State<project_card> {

  void openProjectSpace(){

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => project_space(
        project_name: widget.project_name!,
      hostname: widget.hostname!, username: widget.username!, password: widget.password!,
    )));
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openProjectSpace,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant
              ),
                color: Theme.of(context).colorScheme.surface
              ),
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(11), topRight: Radius.circular(11)
              ),
                      child: AspectRatio(
                        aspectRatio: 2/1,
                          child: Image.network(
                            widget.imgURL!,
                            loadingBuilder: (context, child, loadingProgess){
                              if(loadingProgess == null){
                                return child;
                              }
                              else{
                                return Center(child: CircularProgressIndicator(),);
                              }
                            },
                          fit: BoxFit.cover,))),
                  Container(height: 60, alignment: Alignment.center,
                      child: Text(widget.project_name!, style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Theme.of(context).colorScheme.tertiary),)),
                  Container(
                    height: 30, alignment: Alignment.center,
                      child: Text(widget.project_description!, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.tertiary))),
                  ExpansionTile(
                      title: Center(child: Text('more')),
                    children: [
                      Center(
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Text('Hostname'), Text('username'), Text('password'),
                              ],
                            ),
                            Gap(50),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.hostname!),
                                Text(widget.username!),
                                Text(widget.password!),
                              ],
                            ),
                            Gap(50),
                            IconButton(onPressed: (){}, icon: Icon(Icons.edit)),
                            Gap(20),
                            IconButton(onPressed: () async{
                                await delete_project(widget.project_name!, widget.project_description!, context);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                            }, icon: Icon(Icons.delete))
                          ],
                        ),
                      )

                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
        constraints: const BoxConstraints(maxWidth: 1000),
        child: GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => create_new_project()));
          },

          child: Padding(
            padding: const EdgeInsets.all(16),
            child: DottedBorder(
              color: Theme.of(context).colorScheme.outlineVariant,
              borderType: BorderType.RRect,
              padding: EdgeInsets.all(40),
              radius: Radius.circular(12),
              strokeWidth: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(height: 50, alignment: Alignment.center,
                      child: Text(widget.title, style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Theme.of(context).colorScheme.tertiary),)),
                  Container(
                      height: 30, alignment: Alignment.center,
                      child: Text(widget.subtitle, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.tertiary))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*
void create_project_prompt(BuildContext context){
  final projectNameController = TextEditingController();
  final projectDescriptionController = TextEditingController();
  final hostnameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  showDialog(context: context, builder: (context){
    return AlertDialog(
      content: Column(
        children: [
          in_app_textfield(
              controller: projectNameController,
              hintText: 'Robbie the Robot',
              obsureText: false,
              titleText: 'Project Name'),
          Gap(20),
          in_app_textfield(
              controller: projectDescriptionController,
              hintText: 'A robot to help clean my work desk',
              obsureText: false,
              titleText: 'Description'),
          Gap(20),
          in_app_textfield(
              controller: hostnameController,
              hintText: 'Robbie the Robot',
              obsureText: false,
              titleText: 'title'),
          Gap(20),
        ],
      ),
      actions: [
        TextButton(onPressed: (){
          AddNewProject();
          Navigator.pop(context);
        }, child: Text('add'))
      ],
    );
  });
}
*/

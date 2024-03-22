import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:v2_1/comfyauth/authentication/components/signout.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/user_information.dart';

import '../../project_space_screen/project_space.dart';
import '../comfy_user_information_function/project_information.dart';

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
              else{
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: project_list?.length,
                      itemBuilder: (context, index){
                      return project_card(
                        project_name: project_list?[index].name,
                        project_description: project_list?[index].description,
                        hostname: project_list?[index].hostname,
                        username: project_list?[index].username,
                        password: project_list?[index].password,
                      );
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
    required this.hostname, required this.username, required this.password});
  final String? project_name; final String? project_description;
  final String? hostname; final String? username; final String? password;
  @override
  State<project_card> createState() => _project_cardState();
}

class _project_cardState extends State<project_card> {

  void openProjectSpace(){

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => project_space(project_name: widget.project_name!)));
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openProjectSpace,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          constraints: BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant
          ),
            color: Theme.of(context).colorScheme.surface
          ),
          padding: EdgeInsets.only(bottom: 30),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(11), topRight: Radius.circular(11)
          ),
                  child: Image.network('https://images.unsplash.com/photo-1571769267292-e24dfadebbdc?q=80&w=1490&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D')),
              Container(height: 60, alignment: Alignment.center,
                  child: Text(widget.project_name!, style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Theme.of(context).colorScheme.tertiary),)),
              Container(
                height: 30, alignment: Alignment.center,
                  child: Text(widget.project_description!, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.tertiary))),
            ],
          ),
        ),
      ),
    );
  }
}

class add_project_card extends StatelessWidget {
  const add_project_card({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                child: Text('Create a project', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Theme.of(context).colorScheme.tertiary),)),
            Container(
                height: 30, alignment: Alignment.center,
                child: Text('~ let your creativity fly ~', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.tertiary))),
          ],
        ),
      ),
    );
  }
}


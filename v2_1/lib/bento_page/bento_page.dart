import 'package:flutter/material.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/bento_bot/bento_information.dart';
import 'package:v2_1/home_screen/components/project_list.dart';

class BentoPage extends StatefulWidget {
  const BentoPage({super.key});

  @override
  State<BentoPage> createState() => _BentoPageState();
}

class _BentoPageState extends State<BentoPage> {
  var bento_projects = get_bento_project_list_information();
  @override
  Widget build(BuildContext context) {
    return Center(
        child: FutureBuilder(
            future: bento_projects,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const CircularProgressIndicator();
              } else {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final projectList = snapshot.data;
                      return project_card(
                        project_name: projectList?[index].name,
                        project_description: projectList?[index].description,
                        hostname: projectList?[index].hostname,
                        port: projectList?[index].port,
                        username: projectList?[index].username,
                        password: projectList?[index].password,
                        imgURL: projectList?[index].imgURL,
                        type: projectList![index].type!,
                      );
                    });
              }
            }));
  }
}

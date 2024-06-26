import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/add_project.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/sendEmail.dart';
import 'package:v2_1/home_screen/home_screen.dart';
import 'package:v2_1/universal_widget/buttons.dart';

import '../../project_space_screen/function/static_ip_function.dart';
import '../../universal_widget/verification_page.dart';

class SSHInitialScan extends StatelessWidget {
  const SSHInitialScan({super.key,
  required this.project_name, required this.project_description, required this.imgURL,
    required this.hostname, required this.username, required this.password
  });
  final String project_name; final String project_description; final String imgURL;
  final String hostname; final String username; final String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: InitialSSHScan(hostname, username, password),
            builder: (context, snapshot){
              //if scanning is in progress
              if(snapshot.connectionState != ConnectionState.done){
                return VerificationPage(
                  project_name: project_name,
                  project_description: project_description,
                  imgURL: imgURL,
                  hostname: hostname,
                  username: username,
                  password: password,
                  imgPath: 'assets/tutorials/roman_loading.webp',
                  text: 'Scanning for your Raspberry Pi',
                );
              }
              //if scanning is done
              else{
                print('ssh result is ${snapshot.data}');
                //if scan result yields failed
                if(snapshot.data == null){
                  return VerificationPage(
                    project_name: project_name,
                    project_description: project_description,
                    imgURL: imgURL,
                    hostname: hostname,
                    username: username,
                    password: password,
                    imgPath: 'assets/tutorials/failKid.webp',
                    text: 'Scanning failed',
                    nextButton: clickable_text(
                      text: 'Return home',
                      onTap: () async{
                        await sendEmailGeneral('$project_name failed at scanning');
                        await AddNewProject(context, project_name, project_description, hostname, username, password, imgURL);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                      },
                    ),
                  );

                }
                //if scan result yields success
                else{
                  return FutureBuilder(
                      future: acquireStaticIP(hostname, username, password),
                      builder: (context, snapshot){
                        if(snapshot.connectionState == ConnectionState.done){
                          return VerificationPage(
                            project_name: project_name,
                            project_description: project_description,
                            imgURL: imgURL,
                            hostname: hostname,
                            username: username,
                            password: password,
                            imgPath: 'assets/tutorials/successKid.webp',
                            text: 'Raspberry Pi found!',
                            nextButton: clickable_text(
                              text: 'Finish', onTap: () async{
                                await AddNewProject(context, project_name, project_description, hostname, username, password, imgURL);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen(pageIndex: 1,)));
                            },
                            ),
                          );
                        }
                        else{
                          return VerificationPage(
                            project_name: project_name,
                            project_description: project_description,
                            imgURL: imgURL,
                            hostname: hostname,
                            username: username,
                            password: password,
                            imgPath: 'assets/tutorials/roman_loading.webp',
                            text: 'Almost there',
                          );
                        }
                      }
                  );


                }
              }
            }
        ),
      ),
    );
  }
}

Future<String?> InitialSSHScan(String hostname, String username, String password) async{

  final socket = await SSHSocket.connect(hostname, 22);
  try{
    final client = SSHClient(
      socket,
      username: username,
      onPasswordRequest: () => password,
      onAuthenticated: (){

      },
      printDebug: (String? info){
        print('ssh initial scan debug: $info');
      },
        printTrace: (String? info){
      print('ssh initial scan trace: $info');
    }
    );
    print('ssh scan finished');
    return 'success';
  } catch (e){
    print('error on initial ssh scan: $e');
  }
  return null;


}



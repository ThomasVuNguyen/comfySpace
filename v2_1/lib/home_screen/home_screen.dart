

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:v2_1/create_new_project/components/experience_picker.dart';
import 'package:v2_1/create_new_project/components/raspi_setup.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/user_information.dart';
import 'package:v2_1/home_screen/components/account_info.dart';
import 'package:v2_1/home_screen/components/add_project_button.dart';
import 'package:v2_1/home_screen/components/avatar_icon.dart';
import 'package:v2_1/home_screen/components/learning_space.dart';
import 'package:v2_1/home_screen/components/project_list.dart';
import 'package:v2_1/home_screen/components/set_user_info.dart';
import 'package:v2_1/universal_widget/buttons.dart';
import 'package:v2_1/universal_widget/greeting.dart';
import 'package:v2_1/universal_widget/random_widget_loading.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.pageIndex = 0});
  final int pageIndex;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var user_info;
  int _selectedPageIndex = 0;
  @override
  void initState() {
    if(widget.pageIndex == 1){
      _selectedPageIndex = 1;
    }
    user_info = get_user_information();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<user_information>(
        future: user_info,
        builder: (BuildContext context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            var user = snapshot.data;
            List<Widget> home_screen_list = [
              project_list(),
              learning_space(),
              account_info(name: user?.name, tagline: user?.tagline,)
            ];
              return Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    title: Builder(
                      builder: (context){
                        if(user?.name == null){
                          return Row(
                            children: [
                              const randomGreeting(),
                              clickable_text(text: 'Pick a username!', onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const set_user_info()),
                                );
                              })
                            ],
                          );
                          return Text('Greetings, ${user?.name}');
                        }
                        else{
                          return randomGreeting(name: user!.name!,);
                        }
                      },
                    ),
                    //
                    actions: [
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => raspberryPiSetup(project_name: '', project_description: '', imgURL: '')));
                          /*setState(() {
                            _selectedPageIndex = 2;
                          });*/
                        },
                          child: const avatar_icon()
                      )
                    ],
                  ),
                  body: home_screen_list[_selectedPageIndex],
                  bottomNavigationBar: NavigationBarTheme(
                    data: NavigationBarThemeData(
                        height: 80,
                        labelTextStyle: WidgetStateProperty.all(
                            Theme.of(context).textTheme.labelMedium
                        )
                    ),
                    child: NavigationBar(
                      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      //Theme.of(context).colorScheme.primaryContainer,
                      selectedIndex: _selectedPageIndex,
                      destinations: [
                        NavigationDestination(
                            icon: Icon(Icons.build), label: 'Projects', selectedIcon: Icon(Icons.handyman),
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.library_books), label: 'Academy', selectedIcon: Icon(Icons.local_library),
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.self_improvement), label: 'You', selectedIcon: Icon(Icons.accessibility_new),
                        ),
                      ],
                      onDestinationSelected: (selectedIndex){
                        setState(() {
                          _selectedPageIndex = selectedIndex;
                        });
                      },
                    ),
                  ),
                floatingActionButton: (_selectedPageIndex==0)? 
                    addProjectButton()
                    : null,
              );
          }
          else if(snapshot.connectionState == ConnectionState.waiting){
            if (kDebugMode) {
              print('loading user info');
            }
            return const Center(child: randomLoadingWidget());
          }
          else{
            print(snapshot.connectionState.toString());
            return Center(child: Text(snapshot.connectionState.toString()));
          }
        }
    );
  }
}


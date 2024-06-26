

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:v2_1/comfy_share_screen/comfy_share.dart';
import 'package:v2_1/create_new_project/components/ssh_scan.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/user_information.dart';
import 'package:v2_1/account_info/account_info.dart';
import 'package:v2_1/home_screen/components/add_project_button.dart';
import 'package:v2_1/home_screen/components/avatar_icon.dart';
import 'package:v2_1/home_screen/components/learning_space.dart';
import 'package:v2_1/home_screen/components/project_list.dart';
import 'package:v2_1/home_screen/components/set_user_info.dart';
import 'package:v2_1/universal_widget/buttons.dart';
import 'package:v2_1/universal_widget/greeting.dart';
import 'package:v2_1/universal_widget/random_widget_loading.dart';

import 'comfy_user_information_function/project_information.dart';


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
            List<Widget> homeScreenList = [
              const learning_space(),
              const project_list(),
              const comfyShareScreen()
              //account_info(name: user?.name, tagline: user?.tagline,)
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          account_info(name: user?.name, tagline: user?.tagline)
                          ));
                        },
                          child: const avatar_icon()
                      )
                    ],
                  ),
                  body: homeScreenList[_selectedPageIndex],
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
                      destinations: const [
                        NavigationDestination(
                          icon: Icon(Icons.library_books), label: 'Learn', selectedIcon: Icon(Icons.local_library),
                        ),
                        NavigationDestination(
                            icon: Icon(Icons.build), label: 'Build', selectedIcon: Icon(Icons.handyman),
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.library_books), label: 'Share', selectedIcon: Icon(Icons.local_library),
                        ),
                      ],
                      onDestinationSelected: (selectedIndex){
                        setState(() {
                          _selectedPageIndex = selectedIndex;
                        });
                      },
                    ),
                  ),
                floatingActionButton: (_selectedPageIndex==1)?
                const addProjectButton()
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
            if (kDebugMode) {
              print(snapshot.connectionState.toString());
            }
            return Center(child: Text(snapshot.connectionState.toString()));
          }
        }
    );
  }
}


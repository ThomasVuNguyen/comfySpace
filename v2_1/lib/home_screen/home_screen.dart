
import 'package:flutter/material.dart';
import 'package:v2_1/home_screen/comfy_user_information_function/user_information.dart';
import 'package:v2_1/home_screen/components/account_info.dart';
import 'package:v2_1/home_screen/components/avatar_icon.dart';
import 'package:v2_1/home_screen/components/learning_space.dart';
import 'package:v2_1/home_screen/components/project_list.dart';

import '../comfyauth/authentication/components/signout.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var user_info;
  @override
  void initState() {
    user_info = get_user_information();
    super.initState();
  }
  int _selectedPageIndex = 0;
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
              floatingActionButton: TextButton(
                onPressed: () async { get_project_information(); },
                child: Text('List projects'),),

                appBar: AppBar(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  title: Text('Greetings, ${user?.name}'),
                  actions: [
                    avatar_icon()
                  ],
                ),
                body: home_screen_list[_selectedPageIndex],
                bottomNavigationBar: NavigationBarTheme(
                  data: NavigationBarThemeData(
                      height: 80,
                      labelTextStyle: MaterialStateProperty.all(
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
                        icon: Icon(Icons.home), label: 'Home', selectedIcon: Icon(Icons.house),
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.library_books), label: 'Learn', selectedIcon: Icon(Icons.local_library),
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
                )
            );
          }
          else{
            return const Center(child: CircularProgressIndicator());
          }

        }
    );
  }
}


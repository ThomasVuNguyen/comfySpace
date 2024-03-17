import 'package:flutter/material.dart';
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
  int _selectedPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text('Greetng, -Username-'),
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
          destinations: [
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
}

List<Widget> home_screen_list = [
  project_list(),
  learning_space(),
  account_info()
];
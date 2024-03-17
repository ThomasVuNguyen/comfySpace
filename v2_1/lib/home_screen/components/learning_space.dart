import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v2_1/comfyauth/authentication/components/signout.dart';
import 'package:v2_1/home_screen/components/project_list.dart';

class learning_space extends StatelessWidget {
  const learning_space({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2, child: Scaffold(
      appBar: TabBar(
        tabs: [
          Text('Learn'),
          Text('Projects'),
        ],
      ),
        body:
        TabBarView(
          clipBehavior: Clip.none,
            children: [
          learning_tab(),
          community_project_tab()
        ])

            ));
  }
}

class learning_card extends StatelessWidget {
  const learning_card({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        color: Theme.of(context).colorScheme.surfaceVariant,
        height: 90,
        child: ListTile(
          leading: Image.network('https://images.unsplash.com/photo-1631553127988-36343ac5bb0c?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
          title: Text('The brain', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface),),
          subtitle: Text('The tiny computer that controls it all', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ),
      ),
    );
  }
}

class learning_tab extends StatelessWidget {
  const learning_tab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          learning_card(),
          learning_card(),learning_card(),learning_card(),learning_card(),learning_card(),learning_card(),learning_card(),learning_card(),
        ],
      ),
    );
  }
}

class community_project_tab extends StatelessWidget {
  const community_project_tab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          project_card(),
          project_card(),project_card(),
        ],
      ),
    );
  }
}

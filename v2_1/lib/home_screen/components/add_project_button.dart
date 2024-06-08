import 'package:flutter/material.dart';

import '../../create_new_project/create_new_project.dart';

class addProjectButton extends StatelessWidget {
  const addProjectButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: Icon(Icons.add,color: Theme.of(context).colorScheme.onPrimaryContainer,),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const create_new_project()));
        });
  }
}

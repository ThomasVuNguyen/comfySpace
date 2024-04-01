import 'package:flutter/material.dart';
import 'package:v2_1/comfyauth/authentication/LoginOrRegister.dart';

class overall_summary_screen extends StatelessWidget {
  const overall_summary_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Describe what we do'),
          TextButton(
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginOrRegister())
                );
              },
              child: Text('next')
          )
        ],
      ),
    );
  }
}

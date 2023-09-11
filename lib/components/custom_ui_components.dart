import 'package:comfyssh_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../function.dart';


class Credit extends StatelessWidget {
  const Credit({super.key});
  Future<void> comfySpaceDocumentation() async{
    final Uri docUrl = Uri.parse('https://comfystudio.tech/');
    if (!await launchUrl(docUrl)){
      throw Exception('cannot launch documentation');
    }
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Credits'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Thank you for using comfySpace'),
            TextButton(
                onPressed: (){
                  comfySpaceDocumentation();
                },
                child: Text("Documentation")),
            Text('Give feedback, report bug, and suggest a feature'),
            Text('Icon free space dog icon by Rafiico Creative'),

          ],
        ),
      ),
    );

  }
}

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

/*class aboutUs extends StatelessWidget {
  const aboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    print("loading markdown");
    return FutureBuilder(
      future: DefaultAssetBundle.of(context).loadString('assets/comfyWeb/buttonGuide.md'),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){
        if(snapshot.hasData){
          return Center(child: Markdown(data: snapshot.data!));
        }
        else{
          return Center(
            child: Markdown(data: 'hi')
          );
        }
      },

    );
  }
} */

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialButton(
        onPressed: () async {
          final Uri url = Uri.parse('https://comfystudio.tech/');
          if (!await launchUrl(url,  mode: LaunchMode.externalApplication)) {
          throw Exception('Could not launch $url');
          }
        },
        color: Colors.blue,
        child: Text("Documentation", style: GoogleFonts.poppins(fontSize: 18, color: bgcolor)),
      ),
    );
  }
}


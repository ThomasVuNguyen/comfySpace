import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';


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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/DuckHop.gif', height: 40, gaplessPlayback: true,),
          Center(
            child: Text(
              '\r\nLearn to use ComfySpace below!\r\n',
              style: GoogleFonts.poppins( fontWeight: FontWeight.w500, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          MaterialButton(
            onPressed: () async {
              final Uri url = Uri.parse('https://comfystudio.tech/');
              if (!await launchUrl(url,  mode: LaunchMode.externalApplication)) {
                throw Exception('Could not launch $url');
              }
            },
            color: Colors.blue,
            child: Text("Open Documentation", style: GoogleFonts.poppins(fontSize: 18)),
          ),
          Center(
            child: Text(
              '\r\n',
              style: GoogleFonts.poppins( fontWeight: FontWeight.w500, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(onPressed: () async{
                final Uri url = Uri.parse('https://www.youtube.com/channel/UC4bEbmW14EdoZ4rVvv_gR-w');
                if (!await launchUrl(url,  mode: LaunchMode.externalApplication)) {
                  throw Exception('Could not launch $url');
                }
              }, child: Image.asset('assets/youtube.png', width: 40,)),

              TextButton(onPressed: () async{
                final Uri url = Uri.parse('https://twitter.com/comfysp');
                if (!await launchUrl(url,  mode: LaunchMode.externalApplication)) {
                  throw Exception('Could not launch $url');
                }
              }, child: Image.asset('assets/twitter.png', width: 40,)),

              TextButton(onPressed: () async{
                final Uri url = Uri.parse('https://bsky.app/profile/cfsp.bsky.social');
                if (!await launchUrl(url,  mode: LaunchMode.externalApplication)) {
                  throw Exception('Could not launch $url');
                }
              }, child: Image.asset('assets/Bluesky.png', width: 40,)),

              TextButton(onPressed: () async{
                final Uri url = Uri.parse('https://www.instagram.com/comfy.rpi/');
                if (!await launchUrl(url,  mode: LaunchMode.externalApplication)) {
                  throw Exception('Could not launch $url');
                }
              }, child: Image.asset('assets/instagram.png', width: 40,)),

              TextButton(onPressed: () async{
                final Uri url = Uri.parse('https://discord.com/invite/R7TEXPCs');
                if (!await launchUrl(url,  mode: LaunchMode.externalApplication)) {
                  throw Exception('Could not launch $url');
                }
              }, child: Image.asset('assets/discord.png', width: 40,)),
            ],
          )
        ],
      ),
    );

  }
}



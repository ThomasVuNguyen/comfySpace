import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wiredash/wiredash.dart';

import '../main.dart';

class IdeaSuggestionPage extends StatelessWidget {
  const IdeaSuggestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/duck.gif', height: 40, gaplessPlayback: true,),
          Text(
            '\r\nThank you for using Comfy Space\r\n',
            style: GoogleFonts.poppins( fontWeight: FontWeight.w500, fontSize: 18)
          ),
          Center(
            child: Text(
                'If you have a bug to report or an idea suggestion, let us know!\r\n',
                style: GoogleFonts.poppins( fontWeight: FontWeight.w500, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          MaterialButton(
            onPressed: (){
              Wiredash.of(context).show(inheritMaterialTheme: true);
            },
            color: Colors.blue,
            child: Text("Suggest an idea!", style: GoogleFonts.poppins(fontSize: 18, color: bgcolor)),
          ),
        ],
      ),
    );
  }
}

class WiredashIdeaPage extends StatelessWidget {
  const WiredashIdeaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wiredash(
      projectId: 'comfy-space-suggestion-bo04w4e',
      secret: 'tFVPfkMoISZKN9cF8dl2_RGM4Trtmh-9',
      feedbackOptions: WiredashFeedbackOptions(
        email: EmailPrompt.hidden,
      ) ,
      child: IdeaSuggestionPage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wiredash/wiredash.dart';

import '../main.dart';

class IdeaSuggestionPage extends StatelessWidget {
  const IdeaSuggestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Feel free to ',style: GoogleFonts.poppins(color: textcolor, fontWeight: FontWeight.w500, fontSize: 18),),
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
    return Wiredash(
      projectId: 'comfy-space-suggestion-bo04w4e',
      secret: 'tFVPfkMoISZKN9cF8dl2_RGM4Trtmh-9',
      feedbackOptions: WiredashFeedbackOptions(
        email: EmailPrompt.hidden,
      ) ,
      child: IdeaSuggestionPage(),
    );
  }
}

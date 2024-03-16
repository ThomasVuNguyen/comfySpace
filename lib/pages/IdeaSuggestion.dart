import 'package:comfyssh_flutter/comfyScript/ComfyRotatingKnob.dart';
import 'package:comfyssh_flutter/comfyVoice/ComfyVoice.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main.dart';

class IdeaSuggestionPage extends StatelessWidget {
  const IdeaSuggestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
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
          ExperimentalWidgets()
        ],
      ),
    );
  }
}

class ExperimentalWidgets extends StatefulWidget {
  const ExperimentalWidgets({super.key});

  @override
  State<ExperimentalWidgets> createState() => _ExperimentalWidgetsState();
}

class _ExperimentalWidgetsState extends State<ExperimentalWidgets> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            'Here are some experimental widgets!\r\n',
            style: GoogleFonts.poppins( fontWeight: FontWeight.w500, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
        ComfyRotatingKnob(),
        //ComfyVoice()
      ],
    );
  }
}

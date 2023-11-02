import 'package:comfyssh_flutter/components/pop_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wiredash/wiredash.dart';

import '../main.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/DuckHop.gif', height: 40, gaplessPlayback: true,),
          Text(
              '\r\nSuch an empty space...\r\n',
              style: GoogleFonts.poppins( fontWeight: FontWeight.w500, fontSize: 18)
          ),
          Center(
            child: Text(
              'If you want, suggest a SETTING below!\r\n',
              style: GoogleFonts.poppins( fontWeight: FontWeight.w500, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          MaterialButton(
            onPressed: (){
              Wiredash.of(context).show(inheritMaterialTheme: true);
            },
            color: Colors.blue,
            child: Text("Suggest a setting!", style: GoogleFonts.poppins(fontSize: 18, color: bgcolor)),
          ),
        ],
      ),
    );
  }
}

class WiredashSettingPage extends StatelessWidget {
  const WiredashSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Wiredash(
      projectId: 'comfy-space-suggestion-bo04w4e',
      secret: 'tFVPfkMoISZKN9cF8dl2_RGM4Trtmh-9',
      feedbackOptions: WiredashFeedbackOptions(
        email: EmailPrompt.hidden,
      ) ,
      child: SettingPage(),
    );
  }
}

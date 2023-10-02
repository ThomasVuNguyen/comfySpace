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
      child: Row(
            mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Feel free to ',style: GoogleFonts.poppins(color: textcolor, fontWeight: FontWeight.w500, fontSize: 18),),
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

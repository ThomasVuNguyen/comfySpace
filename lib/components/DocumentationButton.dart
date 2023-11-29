import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ButtonDocumentation extends StatelessWidget {
  const ButtonDocumentation({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () async {
        final Uri url = Uri.parse('https://comfystudio.tech/docs/Add%20buttons');
        if (!await launchUrl(url,  mode: LaunchMode.externalApplication)) {
          throw Exception('Could not launch $url');
        }
      },
      color: Theme.of(context).colorScheme.onSecondaryContainer,
      child: Text("Doc.", style: GoogleFonts.poppins(fontSize: 14, color: Theme.of(context).colorScheme.primary,)),
    );

  }
}
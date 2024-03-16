
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class SettingPage extends StatefulWidget {
  SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  List<bool> ExperimentalState = [true, false];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ToggleButtons(children: [
            Text('Stable'),
            Text('Experimental'),
          ], isSelected: ExperimentalState,
            onPressed: (int index){
            setState(() {
              ExperimentalState[index] = true;
              ExperimentalState[1-index] = false;
            });
            },
          ),
          Center(
            child: Text(
              'If you want, suggest a SETTING below!\r\n',
              style: GoogleFonts.poppins( fontWeight: FontWeight.w500, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}


Future<void> SetupExperimentalToggleVariable() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getBool('Experimental') == null){
    await prefs.setBool('Experimental', false);
  }
}

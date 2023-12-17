import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExperimentalToggleModel extends ChangeNotifier{
  bool _Experimental = false;
  bool get Experimental => _Experimental;
  Future<void> setup() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('Experimental') == null){
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('Experimental', false);
      _Experimental = (await prefs.getBool('Experimental'))!;
    }
    else{
      _Experimental = (await prefs.getBool('Experimental'))!;
    }
    }
  Future<void> toggle() async {
    _Experimental = !_Experimental;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _Experimental = await prefs.setBool('Experimental', _Experimental);
    notifyListeners();
  }

}
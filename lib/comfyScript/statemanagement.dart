import 'package:flutter/material.dart';

class SpaceEdit extends ChangeNotifier{
  String EditSpaceState;
  SpaceEdit({
    this.EditSpaceState = "",
});

  void ChangeSpaceEditState() {
    EditSpaceState = "";
    notifyListeners();
  }
}



import 'package:flutter/material.dart';

class ButtonAdditionModel extends ChangeNotifier{
  String AddFinished;
  ButtonAdditionModel({
    this.AddFinished = "",
});
  void ChangeAdditionState() {
    AddFinished = "";
    notifyListeners();
  }
}
//Normally, addFinished is false. After button is added, it becomes True and notifies spacePage to reload


//Well at least that WAS the plan

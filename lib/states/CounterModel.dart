import 'package:flutter/material.dart';

class CounterModel extends ChangeNotifier{
  int _count=0;
  int get count => _count;
  void increment(){
    _count++;
    print("countermodel is $_count");
    notifyListeners();
  }
  void decrement(){
    _count--;
    notifyListeners();
  }
}
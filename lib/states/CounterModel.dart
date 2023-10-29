import 'package:flutter/material.dart';

class CounterModel extends ChangeNotifier{
  int _count=0;
  int get count => _count;
  void increment(){
    _count++;
    print('number of SSH buttons loaded$_count');
    notifyListeners();
  }
  void decrement(){
    _count--;
    print(_count);
    notifyListeners();
  }
  void reset(){
    _count=0;
    print('reset');
    notifyListeners();
  }
}
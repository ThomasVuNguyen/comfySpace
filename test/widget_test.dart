import 'package:flutter/services.dart';

void sendCtrl(){
  const LogicalKeyboardKey key =  LogicalKeyboardKey(0x002000001f0);
  PhysicalKeyboardKey? physicalKey = PhysicalKeyboardKey.controlLeft;
  simulateKeyUpEvent(key) {
    // TODO: implement simulateKeyUpEvent
    throw UnimplementedError();
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

// ref.watch(loadingState.notifier)
final loadingState = StateProvider<int>((ref) {
  return 0;
});
//when loading a space, each button inititates a SSH connection, this listens to the total number of button with SSH connection loaded

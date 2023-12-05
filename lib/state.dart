import 'package:flutter_riverpod/flutter_riverpod.dart';

// ref.watch(loadingState.notifier)
final loadingState = StateProvider<int>((ref) {
  return 0;
});
//when loading a space, each button inititates a SSH connection, this listens to the total number of button with SSH connection loaded

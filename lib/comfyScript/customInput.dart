import 'dart:convert';

import 'package:dartssh2/dartssh2.dart';

Future<String> readInput(SSHClient client, String command) async {
  await Future.delayed(const Duration(seconds: 1));
  final distance = await client.run(command);
  return utf8.decode(distance);
}

Stream<String> readInputStream(SSHClient client, String command) async* {
  while(true){
    await Future<void>.delayed(Duration(milliseconds: 400));
    final distance = await client.run(command);
    yield utf8.decode(distance);
  }

}
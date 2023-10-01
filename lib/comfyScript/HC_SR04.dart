import 'dart:convert';

import 'package:dartssh2/dartssh2.dart';

Future<String> readDistance(SSHClient client, String trig, String echo) async {
  await Future.delayed(const Duration(seconds: 1));
  final distance = await client.run('python3 comfyScript/distance_sensor/HC-SR04.py $trig $echo 1');
  return utf8.decode(distance);
}

Stream<String> readDistanceStream(SSHClient client, String trig, String echo) async* {
  while(true){
    await Future<void>.delayed(const Duration(seconds: 1));
    final distance = await client.run('python3 comfyScript/distance_sensor/HC-SR04.py $trig $echo 1');
    print('python3 comfyScript/distance_sensor/HC-SR04.py $trig $echo 1');
    yield utf8.decode(distance);
  }
}
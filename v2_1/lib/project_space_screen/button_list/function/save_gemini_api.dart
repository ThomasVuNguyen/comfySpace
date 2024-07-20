import 'dart:convert';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';

Future<String> SaveGeminiAPI(String hostname, String username, String password, String apiKey, BuildContext context) async {
  
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saving API key to Raspberry Pi')));
  late SSHClient sshClient;
  bool finished = false;
  String ai_message = '';
  for(String potentialHostName in [hostname]){
    try{
      sshClient = SSHClient(
          await SSHSocket.connect(potentialHostName, 22), username: username, onPasswordRequest: () => password,
  );
  //attempt a connection
  await sshClient.execute('comfy gemini_setup $apiKey');
  var respond = await sshClient.run('comfy gemini_run hello');
  ai_message = utf8.decode(respond);
  finished = true;
  break;
  }
  catch (e){
      print('error');
  }
  }
  if(finished == true){
    print(ai_message);
    return 'Setup finished!';
  }
  else{
    return 'Setup failed';
  }
}
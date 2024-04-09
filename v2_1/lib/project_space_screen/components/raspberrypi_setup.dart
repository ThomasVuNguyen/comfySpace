import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:v2_1/project_space_screen/function/static_ip_function.dart';

Future<void> setUpRaspberryPi(BuildContext context, String hostname, String username, String password) async{
  double beginningTime = DateTime.now().microsecondsSinceEpoch/1000000;
  String? staticIP = await getStaticIp(hostname);
  double staticIPacquiredTime = DateTime.now().microsecondsSinceEpoch/1000000;
  late SSHClient sshClient;
  for(String potentialHostName in [staticIP!, hostname]){
    try{
      sshClient = SSHClient(
        await SSHSocket.connect(potentialHostName, 22),
        username: username,
        onPasswordRequest: () => password,
      );
      double sshSetupTime = DateTime.now().microsecondsSinceEpoch/1000000;

      var DownloadRepo = await sshClient.run('git clone https://github.com/ThomasVuNguyen/comfyScript.git');
      double downloadRepoTime = DateTime.now().microsecondsSinceEpoch/1000000;

      var updateRepo = await sshClient.run('cd comfyScript && git pull');
      double updateRepoTime = DateTime.now().microsecondsSinceEpoch/1000000;

      var installTmux = await sshClient.run('echo $password | sudo apt install tmux');
      double installTmuxTime = DateTime.now().microsecondsSinceEpoch/1000000;

      var comfyExeCheck = await sshClient.run('echo $password | sudo [ -f /usr/bin/comfy ] && echo "1" || echo "0"');
      int comfyExeCheckString = int.parse(utf8.decode(comfyExeCheck));
      if (comfyExeCheckString==0){
        print('creating comfy command');
        var makeExecutable = await sshClient.run('echo $password | sudo cp comfyScript/bash/comfy /usr/bin/comfy');
        var assignchmod = await sshClient.run('echo $password | sudo chmod +x /usr/bin/comfy');
        print('comfy command created');
      }
      double comfyExeTime = DateTime.now().microsecondsSinceEpoch/1000000;

      print('ssh connection successfully created with hostname $potentialHostName');
      int endTime = DateTime.now().microsecondsSinceEpoch;
      print('total time for initializing $hostname is ${endTime - beginningTime}');
      print('breakdown:');
      print('static IP aquiring time: ${staticIPacquiredTime - beginningTime}s');
      print('ssh initializing time: ${sshSetupTime - staticIPacquiredTime}s');
      print('download repo time: ${downloadRepoTime - sshSetupTime}s');
      print('update repo time: ${updateRepoTime - downloadRepoTime}s');
      print('install tmux time: ${installTmuxTime - downloadRepoTime}s');
      print('install comfy exe time: ${comfyExeTime - installTmuxTime}s');
      break;

    }
    catch (e){
      //if all hostname tested and not working, report!
      if(potentialHostName == hostname){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error connecting to $potentialHostName: $e}')));
      }
    }
  }
}
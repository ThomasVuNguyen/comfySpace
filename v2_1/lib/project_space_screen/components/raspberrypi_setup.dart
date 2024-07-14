import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:v2_1/project_space_screen/function/static_ip_function.dart';

Future<void> setUpRaspberryPi(BuildContext context, String hostname, String username, String password) async{
  print('running raspberry pi setup');
  bool sshAvailable = true;
  late SSHClient sshClient;
  if(kIsWeb == false){
    double beginningTime = DateTime.now().microsecondsSinceEpoch/1000000;
    String? static = await getStaticIp(hostname);
    late String staticIP;
    if(static == null){
      staticIP = '1.3.0.6';
    }
    else{
      staticIP = static;
    }
    double staticIPacquiredTime = DateTime.now().microsecondsSinceEpoch/1000000;

    for(String potentialHostName in [staticIP.trim(), hostname]){
      try{
        sshClient = SSHClient(
          await SSHSocket.connect(potentialHostName, 22, timeout: const Duration(seconds: 5)),
          username: username,
          onPasswordRequest: () => password,
        );
        double sshSetupTime = DateTime.now().microsecondsSinceEpoch/1000000;

        var DownloadRepo = await sshClient.run('git clone https://github.com/ThomasVuNguyen/comfyScript.git');
        double downloadRepoTime = DateTime.now().microsecondsSinceEpoch/1000000;

        var updateRepo = await sshClient.run('cd comfyScript && git pull');
        double updateRepoTime = DateTime.now().microsecondsSinceEpoch/1000000;

        var tmuxCheck = await sshClient.run('which tmux');
        String tmuxCheckString = utf8.decode(tmuxCheck);
        print('tmux: ${tmuxCheckString.length}');
        if(tmuxCheckString.isEmpty){
          if (kDebugMode) {
            print('installing tmux');
          }
          var installTmux = await sshClient.run('echo $password | sudo apt -y install tmux');
        }
        double installTmuxTime = DateTime.now().microsecondsSinceEpoch/1000000;

        var comfyExeCheck = await sshClient.run('which comfy');
        String comfyExeCheckString = utf8.decode(comfyExeCheck);
        if (comfyExeCheckString==''){
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
        if (kDebugMode) {
          print('hostname $potentialHostName error: $e');
        }
      }
    }
    sshClient.close();
  }
  print('raspberry pi setup complete');

}
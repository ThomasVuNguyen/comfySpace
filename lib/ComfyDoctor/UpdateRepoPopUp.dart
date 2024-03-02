//predecesso of comfyScript/updateRepo.dart

import 'dart:convert';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


Future<void> showUpdateRepoDialog(BuildContext context, String hostname, String username, String password) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Don't close"),
        content: Text("Getting your Raspberry Pi ready..."),
      );
    },
  );
  await updateRepoRoot(hostname, username, password);
    Navigator.of(context).pop();

}

Future<void> updateRepoRoot(String hostname, String username, String password) async{
  var startSSHTime = DateTime.now().microsecondsSinceEpoch;
  SSHClient client = SSHClient(
    await SSHSocket.connect(hostname, 22),
    username: username,
    onPasswordRequest: () => password,
  );
  var endSSHTime = DateTime.now().microsecondsSinceEpoch;

  var comfyExeCheck = await client.run('echo $password | sudo [ -f /usr/bin/comfy ] && echo "1" || echo "0"');
  int comfyExeCheckString = int.parse(utf8.decode(comfyExeCheck));
  print('command check complete');
  var comfyExeCheckTime = DateTime.now().microsecondsSinceEpoch;

  var FolderCheck = await client.run('echo $password | sudo [ -d comfyScript ] && echo "1" || echo "0"');
  int FolderCheckString = int.parse(utf8.decode(FolderCheck));
  print('folder check is ${(FolderCheckString==0).toString()}');
  print('folder check complete');
  var comfyFolderCheckTime = DateTime.now().microsecondsSinceEpoch;

  if (FolderCheckString==0){
    print('cloning comfscript');
    var DownloadRepo = await client.run('git clone https://github.com/ThomasVuNguyen/comfyScript.git');
    print('cloning done');
  }
  else{
    print('updating comfyscript');
    var updateRepo = await client.run('cd comfyScript && git pull');
    print('comfyscript updated');
  }
  var downloadRepoTime = DateTime.now().microsecondsSinceEpoch;

  if (comfyExeCheckString==0){
    print('creating comfy command');
    var makeExecutable = await client.run('echo $password | sudo cp comfyScript/bash/comfy /usr/bin/comfy');
    var assignchmod = await client.run('echo $password | sudo chmod +x /usr/bin/comfy');
    print('comfy command created');
  }
  var createExeTime = DateTime.now().microsecondsSinceEpoch;

  print('checking tmux install');
  var CheckTmux = await client.run('echo $password | sudo [ -f /usr/bin/tmux ] && echo "1" || echo "0"');
  if (int.parse(utf8.decode(CheckTmux))==0){
    var InstallTmux = await client.run('echo $password | sudo apt -y install tmux');
  }

  var InstallTmuxTime = DateTime.now().microsecondsSinceEpoch;

  print('tmux installed');
  client.close();
  print('SSHClient time: ${endSSHTime - startSSHTime}');
  print('ComfyExeCheck time: ${comfyExeCheckTime - endSSHTime}');
  print('comfyFolderCheck time: ${comfyFolderCheckTime- comfyExeCheckTime }');
  print('downloadRepo time: ${downloadRepoTime - comfyFolderCheckTime}');
  print('createExe time: ${createExeTime - downloadRepoTime }');
  print('tmuxInstallation time: ${InstallTmuxTime - createExeTime}');
  print('total time: ${InstallTmuxTime - startSSHTime}');

}


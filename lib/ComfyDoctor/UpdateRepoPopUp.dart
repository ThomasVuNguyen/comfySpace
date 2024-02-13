//predecesso of comfyScript/updateRepo.dart

import 'dart:convert';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xterm/core.dart';

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
  SSHClient client = SSHClient(
    await SSHSocket.connect(hostname, 22),
    username: username,
    onPasswordRequest: () => password,
  );
  var comfyExeCheck = await client.run('echo $password | sudo [ -f comfy ] && echo "1" || echo "0"');
  int comfyExeCheckString = int.parse(utf8.decode(comfyExeCheck));
  print('command check complete');
  var FolderCheck = await client.run('echo $password | sudo [ -d comfyScript ] && echo "1" || echo "0"');
  int FolderCheckString = int.parse(utf8.decode(FolderCheck));
  print('folder check complete');

  if (FolderCheckString==0){
    var DownloadRepo = await client.run('git clone https://github.com/ThomasVuNguyen/comfyScript.git');
    print('cloning comfscript');
  }
  else{
    var updateRepo = await client.run('cd comfyScript && git pull');
    print('updating comfyscript');
  }
  if (comfyExeCheckString==0){
    var makeExecutable = await client.run('echo $password | sudo cp comfyScript/bash/comfy /usr/bin/comfy');
    var assignchmod = await client.run('echo $password | sudo chmod +x /usr/bin/comfy');
    print('creating comfy command');
  }

  var InstallTmux = await client.run('echo $password | sudo apt -y install tmux');
  client.close();
  print('closing client for update');
  print('reloading update widget');

}


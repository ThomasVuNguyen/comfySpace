import 'dart:convert';
import 'dart:typed_data';

import 'package:comfyssh_flutter/components/LoadingWidget.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xterm/core.dart';



class updateRepoWidget extends StatefulWidget {
  const updateRepoWidget({super.key, required this.hostname, required this.username, required this.password, required this.terminal});
  final String hostname; final String username; final String password; final Terminal terminal;
  @override
  State<updateRepoWidget> createState() => _updateRepoWidgetState();
}

class _updateRepoWidgetState extends State<updateRepoWidget> {
  bool Finished = false; bool StrangeError = false;
  @override
  void initState(){
    super.initState();
    updateRepoRoot(widget.hostname, widget.username, widget.password, widget.terminal);
  }
  @override
  void dispose(){
    super.dispose();
    print("yoo");
  }

  Future<void> updateRepo(String hostname, String username, String password, Terminal terminal) async{
    SSHClient client = SSHClient(
      await SSHSocket.connect(hostname, 22),
      username: username,
      onPasswordRequest: () => password,
    );
    var FolderCheck = await client.run('[ -d comfyScript ] && echo "1" || echo "0"');
    int FolderCheckString = int.parse(utf8.decode(FolderCheck));
    print(FolderCheckString==0);
    if (FolderCheckString==0){
      terminal.write("comfyScript not found, downloading\r\n");
      var DownloadRepo = await client.run('git clone https://github.com/ThomasVuNguyen/comfyScript.git');
      terminal.write('${String.fromCharCodes(DownloadRepo)}\r\n');
      terminal.write("Repo downloaded\r\n");
    }
    else if(FolderCheckString == 1){
      terminal.write("comfyScript found, updating\r\n");
      var UpdateRepo = await client.run('cd comfyScript && git pull');
      terminal.write('${String.fromCharCodes(UpdateRepo)}\r\n');
      terminal.write("Repo updated\r\n");
    }
    else{
      StrangeError = true;
    }
    client.close();
    setState(() {Finished = true;});
  }
  Future<void> updateRepoRoot(String hostname, String username, String password, Terminal terminal) async{
    SSHClient client = SSHClient(
      await SSHSocket.connect(hostname, 22),
      username: username,
      onPasswordRequest: () => password,
    );
    var FolderCheck = await client.run('echo $password | sudo [ -d comfyScript ] && echo "1" || echo "0"');
    int FolderCheckString = int.parse(utf8.decode(FolderCheck));
    print(FolderCheckString==0);
    if (FolderCheckString==0){
      terminal.write("comfyScript not found, downloading\r\n");
      var DownloadRepo = await client.run('echo $password | sudo git clone https://github.com/ThomasVuNguyen/comfyScript.git');
      terminal.write('${String.fromCharCodes(DownloadRepo)}\r\n');
      terminal.write("Repo downloaded\r\n");
    }
    else if(FolderCheckString == 1){
      terminal.write("comfyScript found, updating\r\n");
      var UpdateRepo = await client.run('cd comfyScript && echo $password | sudo git pull');
      terminal.write('${String.fromCharCodes(UpdateRepo)}\r\n');
      terminal.write("Repo updated\r\n");
    }
    else{
      StrangeError = true;
    }
    client.close();
    setState(() {Finished = true;});
    //var result = await client.run('rm -r comfyScript');
    //terminal.write('${String.fromCharCodes(result)}\r\n');
    //var resultDownload = await client.run('git clone https://github.com/ThomasVuNguyen/comfyScript.git');
    //terminal.write('${String.fromCharCodes(resultDownload)}\r\n');
  }

  @override
  Widget build(BuildContext context) {
    if (StrangeError == false){
      return Center(
        child: Finished? null
            :LoadingWaveDots(),
      );
    }
    else{
      return Text("Weird fuckin error");
    }

  }
}



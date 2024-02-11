import 'dart:convert';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xterm/core.dart';

class updateRepoWidget extends StatefulWidget {
  const updateRepoWidget({super.key, required this.hostname, required this.username, required this.password, required this.terminal, required this.spacename});
  final String hostname; final String username; final String password; final Terminal terminal;final String spacename;
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

  }

  Future<void> updateRepoRoot(String hostname, String username, String password, Terminal terminal) async{
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
    client.close();
    print('closing client for update');
    setState(() {Finished = true;});
    print('reloading update widget');
    //var result = await client.run('rm -r comfyScript');
    //terminal.write('${String.fromCharCodes(result)}\r\n');
    //var resultDownload = await client.run('git clone https://github.com/ThomasVuNguyen/comfyScript.git');
    //terminal.write('${String.fromCharCodes(resultDownload)}\r\n');
  }

  @override
  Widget build(BuildContext context) {
    return Text(widget.spacename);
    /*Center(
        child: Finished?
            FutureBuilder(
                future: Future.delayed(const Duration(seconds: 1)),
                builder: (c,s){
                  if (s.connectionState == ConnectionState.done){
                    return FutureBuilder(
                      future: Future.delayed(const Duration(seconds: 1)),
                        builder: (c,s){
                        if(s.connectionState == ConnectionState.done){
                          widget.terminal.write('Hi, I am a collapsible terminal\r\n');
                          return Text(widget.spacename, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),);
                        }
                        else{
                          return Text("Enjoy", style: GoogleFonts.poppins( fontWeight: FontWeight.w400, fontSize: 18, color: Colors.black));
                        }
                        }
                        );
                  }
                  else{
                    return Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Loading Space",style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 18, color: Colors.black)),
                        Image.asset('assets/DuckHopRun.gif', height: 20, gaplessPlayback: true,),
                      ],
                    );
                  }
                }
                )
            : Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Updating RPi  ',style: GoogleFonts.poppins( fontWeight: FontWeight.w400, fontSize: 18, color: Colors.black)),
                Image.asset('assets/DuckHopRun.gif', height: 20, gaplessPlayback: true,),
                //Image.asset('assets/play.png', height: 20, gaplessPlayback: true,),
              ],
            ),
      );*/


  }
}


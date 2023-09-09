import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';
import 'package:xterm/core.dart';

Future<void> updateRepo(String hostname, String username, String password, Terminal terminal) async{
  SSHClient client = SSHClient(
    await SSHSocket.connect(hostname, 22),
    username: username,
    onPasswordRequest: () => password,
  );
  var result = await client.run('rm -r comfyScript');
  terminal.write('${String.fromCharCodes(result)}\r\n');
  var resultDownload = await client.run('git clone https://github.com/ThomasVuNguyen/comfyScript.git');
  terminal.write('${String.fromCharCodes(resultDownload)}\r\n');
}

Future<void> sudoUpdateRepo(String hostname, String username, String password, Terminal terminal) async{
  SSHClient client = SSHClient(
    await SSHSocket.connect(hostname, 22),
    username: username,
    onPasswordRequest: () => password,
  );
  var result = await client.run('\$echo $password | sudo rm -r comfyScript');
  terminal.write('${String.fromCharCodes(result)}\r\n');
  var resultDownload = await client.run('git clone https://github.com/ThomasVuNguyen/comfyScript.git');
  terminal.write('${String.fromCharCodes(resultDownload)}\r\n');
}
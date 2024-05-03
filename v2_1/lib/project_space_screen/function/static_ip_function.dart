import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v2_1/web_socket/webSocketFunction.dart';

Future<String?> getStaticIp(String hostname) async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  //get the existing list if possible
  final List<String>? currentLocalhostList = prefs.getStringList('localhostList');
  final List<String>? currentStaticIPList = prefs.getStringList('staticIPList');

  //if no list existed, return a random ip - showcase mode
  if(currentStaticIPList == null || currentLocalhostList == null){
    return 'no static list found';
  }

  //if no existing static ip is found, assign a random number for now
  int hostnameIndex = currentLocalhostList.indexOf(hostname);
  if(currentStaticIPList.length<hostnameIndex+1){
    return 'no static ip created yet';
  }
  //if existing static ip found, use it
  else{
    String staticIP = currentStaticIPList[hostnameIndex];
    print(currentLocalhostList.toString());
    print(currentStaticIPList.toString());
    return staticIP;
  }


}

Future<void> saveStaticIP(String hostname, String staticIP) async{
  print('saving static ip of $hostname as $staticIP');
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  //get the existing list if possible
  final List<String>? currentLocalhostList = prefs.getStringList('localhostList');
  final List<String>? currentStaticIPList = prefs.getStringList('staticIPList');

  //if no existing list available, create empty list
  if(currentLocalhostList == null || currentStaticIPList == null){
    await prefs.setStringList('localhostList', <String>[]);
    await prefs.setStringList('staticIPList', <String>[]);
  }
  else if(currentLocalhostList.contains(hostname)){
    int currentLocahostIndex = currentLocalhostList.indexOf(hostname);
    currentStaticIPList[currentLocahostIndex] = staticIP;
    await prefs.setStringList('localhostList', currentLocalhostList);
    await prefs.setStringList('staticIPList', currentStaticIPList);
    if (kDebugMode) {
      print(currentLocalhostList);
      print(currentStaticIPList);
      print('static ip saved');
    }

  }
  //if not, add hostname and static ip to list
  else{
    currentLocalhostList.add(hostname);
    currentStaticIPList.add(staticIP);
    await prefs.setStringList('localhostList', currentLocalhostList);
    await prefs.setStringList('staticIPList', currentStaticIPList);
    if (kDebugMode) {
      print(currentLocalhostList);
      print(currentStaticIPList);
      print('static ip saved');
    }
  }
}

Future<void> acquireStaticIP(String hostname, String username, String password) async{
  print('acquiring static ip');
  if(kIsWeb == false){
    SSHClient sshClient = SSHClient(
      await SSHSocket.connect(hostname, 22, timeout: const Duration(seconds: 5)),
      username: username,
      onPasswordRequest: () => password,
    );
    final clientResponse = await sshClient.run('hostname -I | awk \'{print \$1}\'');
    String staticIP = utf8.decode(clientResponse).trim();
    print("static ip is $staticIP");
    await saveStaticIP(hostname, staticIP);
    if (kDebugMode) {
      print('$hostname static IP saved as $staticIP');
    }
    //return staticIP;
  }
  else{
    await initializeWebSocket(hostname);

  }

}
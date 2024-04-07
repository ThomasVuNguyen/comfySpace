import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getStaticIp(String hostname) async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  //get the existing list if possible
  final List<String>? currentLocalhostList = await prefs.getStringList('localhostList');
  final List<String>? currentStaticIPList = await prefs.getStringList('staticIPList');
  if(currentStaticIPList == null || currentLocalhostList == null){
    return null;
  }
  int hostnameIndex = currentLocalhostList.indexOf(hostname);
  String staticIP = currentStaticIPList[hostnameIndex];

  return staticIP;

}

Future<void> saveStaticIP(String hostname, String staticIP) async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  //get the existing list if possible
  final List<String>? currentLocalhostList = await prefs.getStringList('localhostList');
  final List<String>? currentStaticIPList = await prefs.getStringList('staticIPList');

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
  SSHClient _sshClient = SSHClient(
      await SSHSocket.connect(hostname, 22),
      username: username,
  onPasswordRequest: () => password,
  );
  try{
    final _clientResponse = await _sshClient.run('hostname -I | awk \'{print \$1}\'').timeout(Duration(seconds: 5));
    String staticIP = utf8.decode(_clientResponse);
    await saveStaticIP(hostname, staticIP);
    if (kDebugMode) {
      print('$hostname static IP saved as $staticIP');
    }
  } on TimeoutException{
    print('time out acquiring static ip');
    //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Connection timed out')));
  }
  catch (e){
    print('error acquiring static ip: $e');
  }
  finally{
    _sshClient.close();
  }
}

import 'dart:convert';
import 'dart:ffi';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:comfyssh_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
newName(String name) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> oldNameList = prefs.getStringList("listName")!;
  oldNameList.add(name);
  prefs.setStringList("listName", oldNameList);
  nameList = prefs.getStringList("listName")!;
  //print("new name"); print(nameList!);
}
newHost(String name) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> oldHostList = prefs.getStringList("listHost")!;
  oldHostList.add(name);
  prefs.setStringList("listHost", oldHostList);
  hostList = prefs.getStringList("listHost")!;
  //print("new host"); print(hostList!);
}
newUser(String name) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> oldUserList = prefs.getStringList("listUser")!;
  oldUserList.add(name);
  prefs.setStringList("listUser", oldUserList);
  userList = prefs.getStringList("listUser")!;
  //print("new user"); print(userList!);
}
newPass(String name) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> oldPassList = prefs.getStringList("listPass")!;
  oldPassList.add(name);
  prefs.setStringList("listPass", oldPassList);
  passList = prefs.getStringList("listPass")!;
  //print("new pass"); print(passList!);
}
newDistro(String name) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> oldDistroList = prefs.getStringList("listDistro")!;
  //print("oldDistroList is " + oldDistroList.toString());
  oldDistroList.add(name);
  prefs.setStringList("listDistro", oldDistroList);
  distroList = prefs.getStringList("listDistro")!;
  //print("new distroList is "+ distroList.toString());
  //print("new distro " + name + "added");
}
clearData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList("listName", <String>[]);
  prefs.setStringList("listHost", <String>[]);
  prefs.setStringList("listUser", <String>[]);
  prefs.setStringList("listPass", <String>[]);
  prefs.setStringList("listDistro", <String>[]);
  nameList = <String>[];hostList = <String>[];userList = <String>[];passList = <String>[];distroList = <String>[];
}
reAssign() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //prefs.reload();
  nameList = prefs.getStringList("listName")!;
  hostList = prefs.getStringList("listHost")!;
  userList = prefs.getStringList("listUser")!;
  passList = prefs.getStringList("listPass")!;
  distroList = prefs.getStringList("listDistro")!;
}
resetData() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList("listName", nameList);
  prefs.setStringList("listHost", hostList);
  prefs.setStringList("listPass", passList);
  prefs.setStringList("listColor", distroList);
}
removeItem(int index) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var tempName = prefs.getStringList("listName");
  var tempHost = prefs.getStringList("listName");
  var tempUser = prefs.getStringList("listName");
  var tempPass = prefs.getStringList("listName");
  var tempDistro= prefs.getStringList("listDistro");
  tempName?.removeAt(index);
  tempHost?.removeAt(index);
  tempUser?.removeAt(index);
  tempPass?.removeAt(index);
  tempDistro?.removeAt(index);
  nameList = tempName!; hostList = tempHost!; userList = tempUser!; passList = tempPass!; distroList = tempDistro!;

  prefs.setStringList("listName", tempName!);
  prefs.setStringList("listHost", tempHost!);
  prefs.setStringList("listUser", tempUser!);
  prefs.setStringList("listPass", tempPass!);
  prefs.setStringList("listDistro", tempDistro!);
  print("new list");
  print(tempName);
}
infoBox(int count, BuildContext context) async{
  if(count == 1) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Add a new host"),
          content: Column(
            children: [
              TextField( onChanged: (name1){
                nickname = name1;},
                decoration: const InputDecoration(hintText: "nickname"), textInputAction: TextInputAction.next,
              ),
              TextField( onChanged: (host1){
                hostname = host1;},
                decoration: const InputDecoration(hintText: "hostname"), textInputAction: TextInputAction.next,
              ),
              TextField( onChanged: (user1){
                username = user1;},
                decoration: const InputDecoration(hintText: "username"), textInputAction: TextInputAction.next,
              ),
              TextField( onChanged: (pass1){
                password = pass1;},
                decoration: const InputDecoration(hintText: "password"), textInputAction: TextInputAction.next,
              ),
              DropdownButtonFormField<String> (
                value: colorMap.keys.toList()![0],
                items: colorMap.keys.toList()!.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                }).toList(),
                onChanged: (String? value){
                  currentDistro = value!;
                  print("changed$currentDistro");
                },
              ),
            ],
          ),
          actions: <Widget>[
            MaterialButton(
                color: Colors.green,
                textColor: Colors.white,
                child: const Text("Save"),
                onPressed: (){
                  newName(nickname!);
                  newHost(hostname!);
                  newUser(username!);
                  newPass(password!);
                  newDistro(currentDistro);
                  print("saved");
                  print("popped 1");
                  currentDistro=colorMap.keys.first;
                  reloadState.value = 1;
                  Navigator.of(context, rootNavigator:true).pop();
                })],
        )
    );
  }
}
memoryCheck() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getStringList("listName") == null){ await prefs.setStringList("listName", <String> []); print(null);}
  if (prefs.getStringList("listHost") == null){ await prefs.setStringList("listHost", <String> []);}
  if (prefs.getStringList("listPass") == null){ await prefs.setStringList("listPass", <String> []);}
  if (prefs.getStringList("listUser") == null){ await prefs.setStringList("listUser", <String> []);}
  if (prefs.getStringList("listDistro") == null){ await prefs.setStringList("listDistro", <String> []);}
}
Future<void> testCommand(String hostname, int port, String username, String password) async {
  final client2 = SSHClient(
      await SSHSocket.connect(hostname, port),
      username: username,
  onPasswordRequest: () => password,
  );
  var result = await client2.run("raspi-gpio set 21 dl");
}
Future<SSHClient> createClient(String hostname, int port, String username, String password) async {
  final client2 = SSHClient(
    await SSHSocket.connect(hostname, port),
    username: username,
    onPasswordRequest: () => password,
  );
  //var result = await client2.run("raspi-gpio set 21 dh");
  print("connection success");
  print(client2.username);
  return client2;
}
Future<void> sendCommandOff(SSHClient client2) async {
  print(client2.username);
  var result = await client2.run("raspi-gpio set 21 dl"); print(utf8.decode(result));print("command sent");
}
Future<void> sendCommandON(SSHClient client2) async {
  print(client2.username);
  var result = await client2.run("raspi-gpio set 21 dh"); print(utf8.decode(result));print("command sent");
}

void open_url() async{
    final Uri url = Uri.parse('https://flutter.dev');
    launchUrl(url);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch ');
    }
    print("yay");
}

void open_url2() {
  final Uri emailLaunchUri = Uri(
    scheme: 'StackOverFlow',
    path: 'https://stackoverflow.com',
  );

  launchUrl(emailLaunchUri);
}

Future<void> sendFeedback() async {
  final InAppReview inAppReview = InAppReview.instance;
  if (await inAppReview.isAvailable()) {
    inAppReview.requestReview();
  }
}
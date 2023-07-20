
import 'dart:convert';
import 'dart:ffi';
import 'package:dartssh2/dartssh2.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:comfyssh_flutter/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

Future<List<String>>updateSpaceRender() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> oldListSpace = await updateSpaceList('comfySpace');
  await prefs.setStringList("listSpace", oldListSpace);
  spaceList = prefs.getStringList("listSpace")!;
  print("space listed");
  return spaceList;
}
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
  nameList = prefs.getStringList("listName")!;
  hostList = prefs.getStringList("listHost")!;
  userList = prefs.getStringList("listUser")!;
  passList = prefs.getStringList("listPass")!;
  distroList = prefs.getStringList("listDistro")!;
}
Future<List<String>>reAssignNameList() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  nameList = prefs.getStringList("listName")!;
  return nameList;
}
Future<List<String>>reAssignHostList() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  hostList = prefs.getStringList("listHost")!;
  return hostList;
}
Future<List<String>>reAssignUserList() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  userList = prefs.getStringList("listUser")!;
  return userList;
}
Future<List<String>>reAssignPassList() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  passList = prefs.getStringList("listPass")!;
  return passList;
}
Future<List<String>>reAssignDistroList() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  distroList = prefs.getStringList("listDistro")!;
  return distroList;
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

Future<void> createSpace(String spaceName) async {
  String dbName = 'comfySpace.db';
  int version =1;
  var dbPath = await getDatabasesPath();
  var dbDirect = Directory(dbPath);
  final List<FileSystemEntity> entities = await dbDirect.list().toList();
  //print(entities.toString());
  var path = p.join(dbPath, dbName);
  var comfySpacedb = await openDatabase(path,
  version: version,
  onCreate: (Database db, version) async =>
      await db.execute('CREATE TABLE $spaceName(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, size_x INTEGER, size_y INTEGER, position INTEGER, command TEXT)')
  );
  var createTable = await comfySpacedb.execute('CREATE TABLE $spaceName(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, size_x INTEGER, size_y INTEGER, position INTEGER, command TEXT)');
  List<Map> list = await comfySpacedb.rawQuery('SELECT * FROM $spaceName');
  List<Map> listTable = await comfySpacedb.rawQuery('SELECT * FROM sqlite_master ORDER BY name;');
  print(listTable.toString());
}

Future<void> checkDB(String dbName, String spaceName)async {
  var dbPath = await getDatabasesPath();
  String path = p.join(dbPath,dbName);
  Database database = await openDatabase(path,
      version:1,
      onCreate: (Database db, version) async =>
      await db.execute('CREATE TABLE $spaceName(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, size_x INTEGER, size_y INTEGER, position INTEGER, command TEXT)')
  );
  List<Map> list = await database.rawQuery('SELECT * FROM $spaceName');
  print(list);
}

Future<List<List<String>>> renderer(String spaceName) async{
  var dbName = 'comfySpace.db';
  var dbPath = await getDatabasesPath();
  String path = p.join(dbPath,dbName);
  Database database = await openDatabase(path,
      version:1,
      onCreate: (Database db, version) async =>
      await db.execute('CREATE TABLE $spaceName(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, size_x INTEGER, size_y INTEGER, position INTEGER, command TEXT)')
  );
  var buttonMap = await database.query(spaceName, columns: ['name']);
  var sizeXMap = await database.query(spaceName, columns: ['size_x']);
  var sizeYMap = await database.query(spaceName, columns: ['size_y']);
  var positionMap = await database.query(spaceName, columns: ['position']);
  var commandMap = await database.query(spaceName, columns: ['command']);
  List<String> buttonList = []; List<String> sizeXList = []; List<String> sizeYList = []; List<String> positionList = []; List<String> commandList =[];
  for (int i = 0; i < buttonMap.length; i++){
    buttonList.add(buttonMap[i].values.toList().toString().replaceAll(RegExp(r'\[|\]'), ""));
    sizeXList.add(sizeXMap[i].values.toList().toString().replaceAll(RegExp(r'\[|\]'), ""));
    sizeYList.add(sizeYMap[i].values.toList().toString().replaceAll(RegExp(r'\[|\]'), ""));
    positionList.add(positionMap[i].values.toList().toString().replaceAll(RegExp(r'\[|\]'), ""));
    commandList.add(commandMap[i].values.toList().toString().replaceAll(RegExp(r'\[|\]'), ""));
  }
  var listTotal = [buttonList, sizeXList, sizeYList, positionList, commandList];
  return listTotal;
}

Future<void> addButton(String spaceName, String name, int size_x, int size_y, int position, String command )async{
  var dbName = 'comfySpace.db';
  var dbPath = await getDatabasesPath();
  String path = p.join(dbPath,dbName);
  Database database = await openDatabase(path,
      version:1,
      onCreate: (Database db, version) async =>
      await db.execute('CREATE TABLE $spaceName(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, size_x INTEGER, size_y INTEGER, position INTEGER, command TEXT)')
  );
  var addedButton = database.rawInsert('INSERT INTO $spaceName(name, size_x, size_y, position, command) VALUES("'"$name"'", $size_x, $size_y, $position, "'"$command"'")');
  print("button added");
}

Future<List<String>> updateSpaceList(String dbName) async{
  var dbName = 'comfySpace.db';
  var dbPath = await getDatabasesPath();
  String path = p.join(dbPath,dbName);
  Database database = await openDatabase(path,
      version:1,
      onCreate: (Database db, version) async =>
      await db.execute('CREATE TABLE defaultSpace(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, size_x INTEGER, size_y INTEGER, position INTEGER, command TEXT)')
  );
  List<Map> listTableMap = await database.rawQuery('SELECT * FROM sqlite_master ORDER BY name;');
  List<String> listTable = [];
  for (var mapping in listTableMap){
    var x = listTable.add(mapping['name']);}
  var y = listTable.removeAt(0); //remove android_metadata

  return listTable;
}

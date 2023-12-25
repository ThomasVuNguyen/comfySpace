
import 'package:comfyssh_flutter/comfyScript/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:comfyssh_flutter/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
//import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:xterm/xterm.dart';

import 'comfyScript/Buzzer.dart';
import 'comfyScript/ComfyHorizontalSwipeButton.dart';
import 'comfyScript/ComfyTapButton.dart';
import 'comfyScript/ComfyToggleButton.dart';
import 'comfyScript/ComfyVerticalSwipeButton.dart';
import 'comfyScript/DCmotor.dart';
import 'comfyScript/FullGestureButton.dart';
import 'comfyScript/LED.dart';
import 'comfyScript/customInput.dart';
import 'comfyScript/stepperMotor.dart';

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

  prefs.setStringList("listName", tempName);
  prefs.setStringList("listHost", tempHost);
  prefs.setStringList("listUser", tempUser);
  prefs.setStringList("listPass", tempPass);
  prefs.setStringList("listDistro", tempDistro);
  print("new list");
  print(tempName);
}

infoBox(int count, BuildContext context) async{
  if(count == 1) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Add a new host"),
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
                value: colorMap.keys.toList()[0],
                items: colorMap.keys.toList().map<DropdownMenuItem<String>>((String value) {
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
                  newName(nickname);
                  newHost(hostname);
                  newUser(username);
                  newPass(password);
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

Future<void> deleteDB(String dbName) async{
  var dbPath = await getDatabasesPath();
  var dbDirect = Directory(dbPath);
  final List<FileSystemEntity> entities = await dbDirect.list().toList();
  //print(entities.toString());
  var path = p.join(dbPath, dbName);
  var comfySpacedb = await openDatabase(path,
      version: 1,
      onCreate: (Database db, version) async =>
      await db.execute('CREATE TABLE defaultSpace(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, size_x INTEGER, size_y INTEGER, position INTEGER, command TEXT, buttonType TEXT)')
    //add to list
  );
  await deleteDatabase(path);
}

Future<void> updateAndroidMetaData(String dbName) async{
  var dbPath = await getDatabasesPath();
  var dbDirect = Directory(dbPath);
  final List<FileSystemEntity> entities = await dbDirect.list().toList();
  //print(entities.toString());
  var path = p.join(dbPath, dbName);
  var database = await openDatabase(path,
      version: 1,
      onCreate: (Database db, version) async =>
      await db.execute('CREATE TABLE defaultSpace(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, size_x INTEGER, size_y INTEGER, position INTEGER, command TEXT, buttonType TEXT)')
    //add to list
  );
  var enUS = "'en-US'" ;
  await database.execute('CREATE TABLE android_metadata (locale TEXT)');
  await database.execute('INSERT INTO android_metadata VALUES($enUS)');
}

Future<void> createHostInfo() async{
  String dbName = 'comfySpace.db';
  int version =1;
  var dbPath = await getDatabasesPath();
  var dbDirect = Directory(dbPath);
  final List<FileSystemEntity> entities = await dbDirect.list().toList();
  //print(entities.toString());
  var path = p.join(dbPath, dbName);
  var comfySpacedb = await openDatabase(path,
      version: version,
      onCreate: (Database db, version) async {
    await db.execute('CREATE TABLE hostInfo(id INTEGER PRIMARY KEY AUTOINCREMENT, spaceName TEXT, host Text, user TEXT, password TEXT)');});
  var createTable = await comfySpacedb.execute('CREATE TABLE hostInfo(id INTEGER PRIMARY KEY AUTOINCREMENT, spaceName TEXT, host Text, user TEXT, password TEXT)');
  print('host added');
}

Future<void> createSpace(String spaceName, String host, String user, String password) async { //save to local database
  String dbName = 'comfySpace.db';
  String spaceNameAdd = "'$spaceName'"; String hostAdd = "'$host'"; String userAdd = "'$user'"; String passwordAdd = "'$password'";
  int version =1;
  var dbPath = await getDatabasesPath();
  var dbDirect = Directory(dbPath);
  final List<FileSystemEntity> entities = await dbDirect.list().toList();
  //print(entities.toString());
  var path = p.join(dbPath, dbName);
  var comfySpacedb = await openDatabase(path,
  version: version,
  onCreate: (Database db, version) async {
      await db.execute('CREATE TABLE `$spaceName`(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, size_x INTEGER, size_y INTEGER, position INTEGER, command TEXT)');
      await db.execute('CREATE TABLE hostInfo(id INTEGER PRIMARY KEY AUTOINCREMENT, spaceName TEXT, host Text, user TEXT, password TEXT)');}
  );

  var createTable = await comfySpacedb.execute('CREATE TABLE `$spaceName`(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, size_x INTEGER, size_y INTEGER, position INTEGER, command TEXT, buttonType TEXT)');
  List<Map> list = await comfySpacedb.rawQuery('SELECT * FROM `$spaceName`');
  var addHostInfo = await comfySpacedb.execute('INSERT INTO hostInfo(spaceName, host, user, password) VALUES($spaceNameAdd, $hostAdd, $userAdd, $passwordAdd)');
  List<Map> listTable = await comfySpacedb.rawQuery('SELECT * FROM sqlite_master ORDER BY name;');
  List<Map> listHost = await comfySpacedb.rawQuery('SELECT * FROM hostInfo ORDER BY id;');
  print(listTable.toString());
  print(listHost.toString());
}

Future<void> checkDB(String dbName, String spaceName)async {
  var dbPath = await getDatabasesPath();
  String path = p.join(dbPath,dbName);
  Database database = await openDatabase(path,
      version:1,
      onCreate: (Database db, version) async =>
      await db.execute('CREATE TABLE `$spaceName`(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, size_x INTEGER, size_y INTEGER, position INTEGER, command TEXT, buttonType TEXT)')
  );
  List<Map> list = await database.rawQuery('SELECT * FROM `$spaceName`');
  print(list);
}

Future<List<Map<String, Object?>>> checkHostInfo(String dbName) async{
  var dbPath = await getDatabasesPath();
  String path = p.join(dbPath,dbName);
  Database database = await openDatabase(path,
      version:1,
      onCreate: (Database db, version) async =>
      await db.execute('CREATE TABLE hostInfo(id INTEGER PRIMARY KEY AUTOINCREMENT, spaceName TEXT, host Text, user TEXT, password TEXT)')
  );
  var checkHost = await database.rawQuery('SELECT COUNT(*) FROM hostInfo');
  return checkHost;
}

Future<List<List<String>>> renderer(String spaceName) async{
  List<String> prohibitedTable = ['hostInfo', 'sqlite_sequence','defaultSpace','android_metadata'];
  var dbName = 'comfySpace.db';
  var dbPath = await getDatabasesPath();
  String path = p.join(dbPath,dbName);
  Database database = await openDatabase(path,
      version:1,
      onCreate: (Database db, version) async =>
      await db.execute('CREATE TABLE `$spaceName`(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, size_x INTEGER, size_y INTEGER, position INTEGER, command TEXT, buttonType TEXT)')
  );
  var buttonMap = await database.query(spaceName, columns: ['name']);
  var sizeXMap = await database.query(spaceName, columns: ['size_x']);
  var sizeYMap = await database.query(spaceName, columns: ['size_y']);
  var positionMap = await database.query(spaceName, columns: ['position']);
  var commandMap = await database.query(spaceName, columns: ['command']);

  List<String> buttonList = []; List<String> sizeXList = []; List<String> sizeYList = []; List<String> positionList = []; List<String> commandList =[];
  for (int i = 0; i < buttonMap.length; i++){
    if(buttonMap[i].values.toList().toString()!='android_metadata'){
      print("new space added ${buttonMap[i].values.toList().toString().replaceAll(RegExp(r'\[|\]'), "")}");
      buttonList.add(buttonMap[i].values.toList().toString().replaceAll(RegExp(r'\[|\]'), ""));
      sizeXList.add(sizeXMap[i].values.toList().toString().replaceAll(RegExp(r'\[|\]'), ""));
      sizeYList.add(sizeYMap[i].values.toList().toString().replaceAll(RegExp(r'\[|\]'), ""));
      positionList.add(positionMap[i].values.toList().toString().replaceAll(RegExp(r'\[|\]'), ""));
      commandList.add(commandMap[i].values.toList().toString().replaceAll(RegExp(r'\[|\]'), ""));
    }
    else{
      print("info caught");
    }
  }

  int indexDelete = buttonList.indexOf('hostInfo');
  var deletebutton = buttonList.removeAt(indexDelete); sizeXList.removeAt(indexDelete); sizeYList.removeAt(indexDelete); positionList.removeAt(indexDelete); commandList.removeAt(indexDelete);
  var listTotal = [buttonList, sizeXList, sizeYList, positionList, commandList];
  print(deletebutton);
  return listTotal;
}

Future<void> addButton(String dbName, String spaceName, String name, int sizeX, int sizeY, int position, String command, String buttonType) async{
  var dbPath = await getDatabasesPath();
  String path = p.join(dbPath,dbName);
  Database database = await openDatabase(path,
      version:1,
      onCreate: (Database db, version) async =>
      await db.execute('CREATE TABLE `$spaceName`(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, size_x INTEGER, size_y INTEGER, position INTEGER, command TEXT, buttonType TEXT)')
  );
  var addedButton = database.rawInsert('INSERT INTO `$spaceName`(name, size_x, size_y, position, command, buttonType) VALUES("'"$name"'", $sizeX, $sizeY, $position, "'"$command"'","'"$buttonType"'")');
  print("button added to `$spaceName` space");
}

Future<List<String>> updateSpaceList(String dbName) async{
  List<String> prohibitedTable = ['hostInfo', 'sqlite_sequence','defaultSpace','android_metadata'];
  var dbName = 'comfySpace.db';
  var dbPath = await getDatabasesPath();
  String path = p.join(dbPath,dbName);
  Database database = await openDatabase(path,
      version:1,
      onCreate: (Database db, version) async =>
      await db.execute('CREATE TABLE defaultSpace(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, size_x INTEGER, size_y INTEGER, position INTEGER, command TEXT, buttonType TEXT)')
  );
  List<Map> listTableMap = await database.rawQuery('SELECT * FROM sqlite_master ORDER BY name;');
  List<String> listTable = [];
  for (var mapping in listTableMap){
    if(prohibitedTable.contains(mapping['name']) == false){
      var x = listTable.add(mapping['name']);
    }}
  return listTable;
}

Stream<List<String>> updateSpaceListStream(String dbName) async*{
  List<String> prohibitedTable = ['hostInfo', 'sqlite_sequence','defaultSpace','android_metadata'];
  var dbName = 'comfySpace.db';
  var dbPath = await getDatabasesPath();
  String path = p.join(dbPath,dbName);
  Database database = await openDatabase(path,
      version:1,
      onCreate: (Database db, version) async =>
      await db.execute('CREATE TABLE defaultSpace(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, size_x INTEGER, size_y INTEGER, position INTEGER, command TEXT, buttonType TEXT)')
  );
  List<Map> listTableMap = await database.rawQuery('SELECT * FROM sqlite_master ORDER BY name;');
  List<String> listTable = [];
  for (var mapping in listTableMap){
    if(prohibitedTable.contains(mapping['name']) == false){
      var x = listTable.add(mapping['name']);
    }}
  print("working");
  yield listTable;
  updateSpaceListStream(dbName);
}

Future<void> deleteSpace(String dbName, String spaceName) async {
  var spaceNameBraces = "'$spaceName'";
  var dbPath = await getDatabasesPath();
  String path = p.join(dbPath,dbName);
  Database database = await openDatabase(path,
      version:1,
      onCreate: (Database db, version) async =>
      await db.execute('CREATE TABLE `$spaceName`(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, size_x INTEGER, size_y INTEGER, position INTEGER, command TEXT, buttonType TEXT)')
  );
  var deleteDB = await database.rawDelete('DROP TABLE `$spaceName`');
  print('$spaceName has been deleted');
  var deleteHost = await database.rawDelete('DELETE FROM hostInfo WHERE spaceName=$spaceNameBraces');
  print(deleteHost.toString());
}

Future<void> editSpace(String dbName, String oldSpaceName, String newSpaceName, String newHostName, String newUser, String newPassword) async {
  String oldSpaceNameBraces = "'$oldSpaceName'";
  String newSpaceNameBraces = "'$newSpaceName'";
  String newHostNameBraces = "'$newHostName'";
  String newUserBraces = "'$newUser'";
  String newPasswordBraces = "'$newPassword'";
  var dbPath = await getDatabasesPath();
  String path = p.join(dbPath,dbName);
  Database database = await openDatabase(path,
      version:1,
      onCreate: (Database db, version) async =>
      await db.execute('CREATE TABLE `$newSpaceName`(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, size_x INTEGER, size_y INTEGER, position INTEGER, command TEXT, buttonType TEXT)')
  );
  var spaceRenamed = await database.execute('ALTER TABLE `$oldSpaceName` RENAME TO `$newSpaceName`');
  var hostRenamed = await database.rawUpdate('UPDATE hostInfo SET spaceName=$newSpaceNameBraces, host=$newHostNameBraces, user=$newUserBraces, password=$newPasswordBraces WHERE spaceName=$oldSpaceNameBraces');
}

Future<List<Map>> buttonRenderer(String dbName, String spaceName) async{
  var dbPath = await getDatabasesPath();
  String path = p.join(dbPath,dbName);
  Database database = await openDatabase(path,
      version:1,
      onCreate: (Database db, version) async =>
      await db.execute('CREATE TABLE `$spaceName` INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, size_x INTEGER, size_y INTEGER, position INTEGER, command TEXT, buttonType TEXT)')
  );
  List<Map> btnNameList = await database.rawQuery('SELECT * FROM `$spaceName`');
  return btnNameList;
}

Future<void> deleteButton(String dbName, String spaceName, String buttonName, int primaryKey) async{
  var btnName = "'$buttonName'";
  var dbPath = await getDatabasesPath();
  String path = p.join(dbPath,dbName);
  Database database = await openDatabase(path,
      version:1,
      onCreate: (Database db, version) async =>
      await db.execute('CREATE TABLE `$spaceName` INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, size_x INTEGER, size_y INTEGER, position INTEGER, command TEXT, buttonType TEXT)')
  );
  var deleteBtn = await database.rawDelete('DELETE FROM `$spaceName` WHERE name= $btnName AND id=$primaryKey');
  print(deleteBtn.toString());
}

Future<void> editButton(String dbName, String spaceName, int index, String newName, int newSizeX, int newSizeY, int newPosition, String newCommand) async{
  String btnName = "'$newName'";
  String btnCommand = "'$newCommand'";
  var dbPath = await getDatabasesPath();
  String path = p.join(dbPath,dbName);
  Database database = await openDatabase(path,
      version:1,
      onCreate: (Database db, version) async =>
      await db.execute('CREATE TABLE `$spaceName` INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, size_x INTEGER, size_y INTEGER, position INTEGER, command TEXT, buttonType TEXT)')
  );
  var buttonChange = await database.rawUpdate('UPDATE `$spaceName` SET name=$btnName, size_x=$newSizeX, size_y=$newSizeY, position=$newPosition, command=$btnCommand WHERE id=$index');
}

Future<Map<String, Object?>> hostInfoRenderer(String dbName, String spaceName) async{
  String spaceNameBraces = "'$spaceName'";
  var dbPath = await getDatabasesPath();
  String path = p.join(dbPath,dbName);
  Database database = await openDatabase(path,
      version:1,
      onCreate: (Database db, version) async {
        await db.execute('CREATE TABLE `$spaceName` INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, size_x INTEGER, size_y INTEGER, position INTEGER, command TEXT, buttonType TEXT)');
        await db.execute('CREATE TABLE hostInfo(id INTEGER PRIMARY KEY AUTOINCREMENT, spaceName TEXT, host Text, user TEXT, password TEXT)');
      }
  );
  var hostRender = await database.rawQuery('SELECT host,user,password FROM hostInfo WHERE spaceName=$spaceNameBraces');
  return hostRender[0];

}

Future<void> addColumn(String dbName, String spaceName, String columnName, String columnDataType) async{
  var dbPath = await getDatabasesPath();
  String path = p.join(dbPath,dbName);
  Database database = await openDatabase(path,
      version:1,
      onCreate: (Database db, version) async {
        await db.execute('CREATE TABLE `$spaceName` INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, size_x INTEGER, size_y INTEGER, position INTEGER, command TEXT, buttonType TEXT)');
        await db.execute('CREATE TABLE hostInfo(id INTEGER PRIMARY KEY AUTOINCREMENT, spaceName TEXT, host Text, user TEXT, password TEXT)');
      }
  );
  var addColumn = await database.rawUpdate('ALTER TABLE `$spaceName` ADD COLUMN $columnName $columnDataType');
  print(addColumn.toString());
}
Future<List<Map<String, Object?>>> countSpace(String dbName) async{
  var dbPath = await getDatabasesPath();
  String path = p.join(dbPath,dbName);
  Database database = await openDatabase(path,
      version:1,
      onCreate: (Database db, version) async {
      await db.execute('CREATE TABLE hostInfo(id INTEGER PRIMARY KEY AUTOINCREMENT, spaceName TEXT, host Text, user TEXT, password TEXT)');}
  );
  var checkHost = await database.rawQuery('SELECT count(*) FROM sqlite_master WHERE type = ${"'table'"} AND name != ${"'android_metadata'"} AND name != ${"'sqlite_sequence'"} AND name != ${"'hostInfo'"}');
  return checkHost;
}

int PopulateButton(BuildContext context){
  int width = MediaQuery.of(context).size.width.round();
  return (width/200).round();
}

Future<List<String>> WireDashInfo() async {
  try {
    String secret = await rootBundle.loadString('assets/secretshit/WireDashSecret.txt');
    String projectID = await rootBundle.loadString('assets/secretshit/WireDashProjectID.txt');
    return [projectID, secret];
  } catch (e) {
    return ["Error loading the file: $e","Error loading the file: $e" ];
  }
}

Widget ButtonSorting(int id, String name, String buttonType, String spaceName, String hostname, String username, String password, String command, Terminal terminal){
  switch(buttonType){
    case 'LED':
      return LedToggle(spaceName: spaceName, name: name, pin: command, id: id, hostname: hostname, username: username, password: password,terminal: terminal);
    case 'stepperMotor':
      List<String> pinList = command.split(" ");
      return StepperMotor(name: name, id: id ,pin1: pinList[0], pin2: pinList[1], pin3: pinList[2], pin4: pinList[3], hostname: hostname, username: username, password: password);
    case 'HCSR04':
      List<String> pinList = command.split(" ");
      return CustomInputButton(name: name, hostname: hostname, username: username, password: password, commandIn: 'python3 comfyScript/distance_sensor/HC-SR04.py ${pinList[0]} ${pinList[1]} 1', terminal: terminal,);
    case 'DCMotor':
      List<String> pinList = command.split(" ");
      return DCMotorSingle(name: name, id: id ,pin1: pinList[0], pin2: pinList[1], hostname: hostname, username: username, password: password);
    case 'ComfyData':
      return CustomInputButton(name: name, hostname: hostname, username: username, password: password, commandIn: command, terminal: terminal,);
    case 'ComfyTapButton':
      return SinglePressButton(name: name, hostname: hostname, username: username, password: password, command: command, terminal: terminal);
      case 'ComfyToggleButton':
      return ComfyToggleButton(name: name, hostname: hostname, username: username, password: password, commandOn: CommandExtract(command)[0],commandOff: CommandExtract(command)[1], terminal: terminal);
    case 'ComfyVerticalButton':
      return ComfyVerticalButton(name: name, hostname: hostname, username: username, password: password, up: CommandExtract(command)[0], middle: CommandExtract(command)[1], down: CommandExtract(command)[2] );
    case 'ComfyHorizontalButton':
      return ComfyHorizontalButton(name: name, hostname: hostname, username: username, password: password, left: CommandExtract(command)[0], middle: CommandExtract(command)[1], right: CommandExtract(command)[2] );
    case 'ComfyFullGestureButton':
      return ComfyFullGestureButton(name: name, hostname: hostname, username: username, password: password, middle: CommandExtract(command)[0], left: CommandExtract(command)[1], right: CommandExtract(command)[2], up: CommandExtract(command)[3], down: CommandExtract(command)[4]) ;
    case 'Buzzer':
      return BuzzerToggle(spaceName: spaceName, name: name, pin: command, id: id, hostname: hostname, username: username, password: password,terminal: terminal);
    case 'ComfyCustomGestureButton':
      return CustomComfyGestureButton(name: name, hostname: hostname, username: username, password: password, OverallCommand: command);
      default:
      return ListTile(
        title: Text(name),
        subtitle: const Text('Unknown button type'),
      );
  }
}
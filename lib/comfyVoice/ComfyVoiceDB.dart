import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as p;
Future<void> addVoicePrompt(String dbName, String spaceName, String prompt, String command,  BuildContext context) async{
  var dbPath = await getDatabasesPath();
  String path = p.join(dbPath,dbName);
  Database database = await openDatabase(path,
      version:1,
      onCreate: (Database db, version) async =>
      await db.execute('CREATE TABLE comfyVoice(id INTEGER PRIMARY KEY AUTOINCREMENT, SpaceName TEXT, prompt TEXT UNIQUE, command TEXT)')
  );

  //var CreateDB =await database.execute('CREATE TABLE comfyVoice(id INTEGER PRIMARY KEY AUTOINCREMENT, SpaceName TEXT, prompt TEXT, command TEXT)');
  var VoicePrompt = {
    'SpaceName': spaceName,
    'prompt': prompt,
    'command':  command
  };
  var addedButton = await database.insert(
    'comfyVoice',
    VoicePrompt,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  print('inserted');
}

Future<void> DeleteVoicePrompt(String dbName, String spaceName, String prompt, String command) async{
  var dbPath = await getDatabasesPath();
  String path = p.join(dbPath,dbName);
  Database database = await openDatabase(path,
      version:1,
      onCreate: (Database db, version) async =>
      await db.execute('CREATE TABLE comfyVoice(id INTEGER PRIMARY KEY AUTOINCREMENT, SpaceName TEXT, prompt TEXT UNIQUE, command TEXT)')
  );

  //var CreateDB =await database.execute('CREATE TABLE comfyVoice(id INTEGER PRIMARY KEY AUTOINCREMENT, SpaceName TEXT, prompt TEXT, command TEXT)');
  var VoicePrompt = {
    'SpaceName': spaceName,
    'prompt': prompt,
    'command':  command
  };
  var addedButton = await database.delete(
    'comfyVoice',
    where:  'Command = ?',
    whereArgs: [command]
  );
  print('deleted');
}

Future<void> EditVoicePrompt(String dbName, String spaceName, String prompt, String command, String NewPrompt, String NewCommand, BuildContext context) async{
  var dbPath = await getDatabasesPath();
  String path = p.join(dbPath,dbName);
  Database database = await openDatabase(path,
      version:1,
      onCreate: (Database db, version) async =>
      await db.execute('CREATE TABLE comfyVoice(id INTEGER PRIMARY KEY AUTOINCREMENT, SpaceName TEXT, prompt TEXT UNIQUE, command TEXT)')
  );

  //var CreateDB =await database.execute('CREATE TABLE comfyVoice(id INTEGER PRIMARY KEY AUTOINCREMENT, SpaceName TEXT, prompt TEXT, command TEXT)');
  var VoicePrompt = {
    'SpaceName': spaceName,
    'prompt': NewPrompt,
    'command':  NewCommand
  };
  var addedButton = await database.update(
      'comfyVoice',
      VoicePrompt,
      where:  'Command = ?',
      whereArgs: [command]
  );
}

Future<void> CreateVoicePromptDB(String dbName) async{
  var dbPath = await getDatabasesPath();
  String path = p.join(dbPath,dbName);
  Database database = await openDatabase(path,
      version:1,
      onCreate: (Database db, version) async =>
      await db.execute('CREATE TABLE comfyVoice(id INTEGER PRIMARY KEY AUTOINCREMENT, SpaceName TEXT, prompt TEXT UNIQUE, command TEXT)')
  );
  var CreateDB =await database.execute('CREATE TABLE comfyVoice(id INTEGER PRIMARY KEY AUTOINCREMENT, SpaceName TEXT, prompt TEXT UNIQUE, command TEXT)');
}

Future<bool> CheckIfPromptAlreadyExists(String dbName, String spaceName, String prompt) async {
  var dbPath = await getDatabasesPath();
  String path = p.join(dbPath,dbName);
  Database database = await openDatabase(path,
      version:1,
      onCreate: (Database db, version) async =>
      await db.execute('CREATE TABLE comfyVoice(id INTEGER PRIMARY KEY AUTOINCREMENT, SpaceName TEXT, prompt TEXT UNIQUE, command TEXT)')
  );

  var CheckIfVoiceExists = await database.rawQuery('SELECT EXISTS(SELECT 1 FROM comfyVoice WHERE prompt=`$prompt` AND spaceName = `$spaceName`);');
  if(CheckIfVoiceExists[0][CheckIfVoiceExists[0].keys.toList()[0]].toString()=='0'){
    return false;
  }
  else{
    return true;
  }
}

Future<String> CheckVoiceTable(String dbName ) async{
  var dbPath = await getDatabasesPath();
  String path = p.join(dbPath,dbName);
  Database database = await openDatabase(path,
      version:1,
      onCreate: (Database db, version) async =>
      await db.execute('CREATE TABLE `comfyVoice`(id INTEGER PRIMARY KEY AUTOINCREMENT, SpaceName TEXT, prompt TEXT UNIQUE, command TEXT)')
  );
  var TableData =  await database.query('comfyVoice');
  return 'comfyVoice  contains ' + TableData.toString();
}

Future<Map<String, String>> VoiceCommandExtracted(String dbName, String spaceName) async{
  var dbPath = await getDatabasesPath();
  String path = p.join(dbPath,dbName);
  Map<String, String> Command = {};
  Database database = await openDatabase(path,
      version:1,
      onCreate: (Database db, version) async =>
      await db.execute('CREATE TABLE comfyVoice(id INTEGER PRIMARY KEY AUTOINCREMENT, SpaceName TEXT, prompt TEXT UNIQUE, command TEXT)')
  );
  List<Map> maps = await database.query(
      'comfyVoice',
    columns: ['prompt', 'command'],
    where: 'SpaceName = ?',
    whereArgs: [spaceName]
  );
  for(int i=0; i<maps.length; i++){
    Command[maps[i]['prompt']] = maps[i]['command'];
  }
  return Command;
}

Future<List<Map>> VoiceCommandExtractedList(String dbName, String spaceName) async{
  var dbPath = await getDatabasesPath();
  String path = p.join(dbPath,dbName);
  Map<String, String> Command = {};
  Database database = await openDatabase(path,
      version:1,
      onCreate: (Database db, version) async =>
      await db.execute('CREATE TABLE comfyVoice(id INTEGER PRIMARY KEY AUTOINCREMENT, SpaceName TEXT, prompt TEXT UNIQUE, command TEXT)')
  );
  List<Map> maps = await database.query(
      'comfyVoice',
      columns: ['prompt', 'command'],
      where: 'SpaceName = ?',
      whereArgs: [spaceName]
  );
  return maps;
}

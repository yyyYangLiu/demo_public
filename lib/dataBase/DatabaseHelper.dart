

import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{

  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'NameList';

  static final columnId = '_id';
  static final columnName = 'name';
  static final columnUniqueId = "uniqueId";
  static final columnCreateDate = "createDate";

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, _databaseName);
      return await openDatabase(path,version: _databaseVersion,
      onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    print("get into create");
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnUniqueId TEXT NOT NULL,
        $columnCreateDate TEXT NOT NULL
      )
    ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    print(db);
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> getData(String name) async {
    Database db = await instance.database;
    return await db.query(table, where: "name = ?",whereArgs: [name]);
  }

  Future<List<Map<String, dynamic>>> checkUnique(String uniqueId) async {
    Database db = await instance.database;
    return await db.query(table, where: "$columnUniqueId = ?",whereArgs: [uniqueId]);
  }

  Future<int> queryRowCount() async{
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(String name) async{
    Database db = await instance.database;
    return await db.delete(table, where: '$columnName = ?', whereArgs: [name]);
  }
  
  void deleteTable () async {
    Database db= await instance.database;
    db.rawDelete("DROP TABLE IF EXISTS $table");
  }

  void deleteAll() async {
    Database db =await instance.database;
    db.rawDelete("DELETE FROM $table");
  }

  // show the name for all the table in the database
  void show() async {
    Database db = await instance.database;
    final data = db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'", null);
    data.then((name){
      for (Map i in name){
        print(i["name"]);
      }
    });
  }

}
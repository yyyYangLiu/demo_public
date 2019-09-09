

import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class GPSDatabaseHelper{

  static final _databaseName = "gpsdatabase.db";
  static final _databaseVersion = 1;

  static final table = 'gpsdata';

  static final columnId = '_id';
  static final columnName = 'name';
  static final columnTime = 'time';
  static final columnLatitude = "latitude";
  static final columnLongitude = "longitude";

  GPSDatabaseHelper._privateConstructor();
  static final GPSDatabaseHelper instance = GPSDatabaseHelper._privateConstructor();

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
        $columnTime TEXT NOT NULL,
        $columnLatitude DOUBLE NOT NULL,
        $columnLongitude DOUBLE NOT NULL
      )
    ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> getData(String time) async {
    Database db = await instance.database;
    return await db.query(table, where: "time = ?",whereArgs: [time]);
  }

  void deleteAll() async {
    Database db =await instance.database;
    db.rawDelete("DELETE FROM $table");
  }

}
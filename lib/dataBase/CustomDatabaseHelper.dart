
import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class CustomDatabaseHelper{

  static final _databaseName = "YesDatabase.db";
  static final _databaseVersion = 1;

  static final columnId = '_id';
  static final columnCreateYear = 'createyear';
  static final columnCreateMonth = 'createmonth';
  static final columnCreateDate = 'createdate';
  static final columnCreateWeek = 'createweek';
  static final columnCreateTime = 'createtime';
  static final columnAnswerTime = 'answertime';
  static final columnAnswer = 'answer';


  CustomDatabaseHelper._privateConstructor();
  static final CustomDatabaseHelper instance = CustomDatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,version: _databaseVersion);
  }

  Future onCreate(Database db, String table) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnCreateYear TEXT NOT NULL,
        $columnCreateMonth TEXT NOT NULL,
        $columnCreateDate TEXT NOT NULL,
        $columnCreateWeek TEXT NOT NULL,
        $columnCreateTime TEXT NOT NULL,
        $columnAnswerTime TEXT NOT NULL,
        $columnAnswer TEXT NOT NULL
      )
    ''');
  }

  Future<int> insert(Map<String, dynamic> row, String table) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> getData(String name,String table) async {
    Database db = await instance.database;
    return await db.query(table, where: "name = ?",whereArgs: [name]);
  }

  Future<List<Map<String, dynamic>>> checkTime(String table,String year,String month,String date,String time) async {
    Database db = await instance.database;
    return await db.query(table,where: "$columnCreateYear = ? AND $columnCreateMonth = ? AND $columnCreateDate = ? AND $columnCreateTime = ?",whereArgs: [year,month,date,time]);
  }

  Future<List<Map<String, dynamic>>> getTodayValues(String table,String year,String month,String date) async {
    Database db = await instance.database;
    return await db.query(table,where: "$columnCreateYear = ? AND $columnCreateMonth = ? AND $columnCreateDate =?",whereArgs: [year,month,date]);
  }

  Future<List<Map<String, dynamic>>> getDataByDate(String date, String table) async {
    Database db = await instance.database;
    return await db.query(table,where: "$columnCreateDate = ?",whereArgs: [date]);
  }

  Future<int> queryRowCountByDateValue(String table, String date, String value) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM $table WHERE $columnCreateDate = $date AND $columnAnswer = '$value'",[]));
  }

  Future<int> queryRowCountByDateYes(String table,String year,String month,String date) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM $table WHERE $columnCreateYear = $year AND $columnCreateMonth = $month AND $columnCreateDate = $date AND $columnCreateDate = $date AND $columnAnswer = 'yes'",[]));
  }

  Future<int> queryRowCountByDateNo(String table,String year,String month,String date) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM $table WHERE $columnCreateYear = $year AND $columnCreateMonth = $month AND $columnCreateDate = $date AND $columnCreateDate = $date AND $columnAnswer = 'no'",[]));
  }

  Future<int> queryRowCountByDate(String table,String date) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM $table WHERE $columnCreateDate = $date"));
  }

  Future<int> queryRowCount(String table) async{
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> update(Map<String, dynamic> row, String table) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  void deleteAll(String table) async {
    Database db =await instance.database;
    db.rawDelete("DELETE FROM $table");
  }

  void show(String table) async {
    Database db = await instance.database;
    final data = db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'", null);
    data.then((name){
      for (Map i in name){
        print(i["name"]);
      }
    });
  }

}
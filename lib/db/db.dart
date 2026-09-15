import 'dart:developer';

import 'package:done/models/task_model.dart';
import 'package:sqflite/sqflite.dart' as db;
import 'package:sqflite/sqlite_api.dart';

class Db {
  static db.Database? _database;
  static const int _version = 1;
  static const String _tableName = 'Tasks';

  static Future<void> initDb() async {
    if (_database != null) {
      log('Database has been created already');
      return;
    } else {
      try {
        String _path = '${await db.getDatabasesPath()}tasks.db';
        _database = await db.openDatabase(
          _path,
          version: _version,
          onCreate: (db, version) async => await db.execute(
            'CREATE TABLE $_tableName (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, note TEXT, isCompleted INTEGER, date TEXT, startTime TEXT, endTime TEXT, remind INTEGER, repeat TEXT)',
          ),
        );
        log('Database created successfully');
      } catch (e) {
        log('Database error initialize');
      }
    }
  }

  static Future<List<Map<String, dynamic>>> queryDb() async {
    return await _database!.query(_tableName);
  }

  static Future<int> insertDb(TaskModel task) async {
    return await _database!.insert(
      _tableName,
      task.toJson(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  static Future<int> deleteAllDb() async {
    return await _database!.delete(_tableName);
  }

  static Future<int> deleteSingleDb(int id) async {
    return await _database!.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> updateToCompletedDb(int id) async {
    return await _database!.rawUpdate(
      'UPDATE $_tableName SET isCompleted = ? WHERE id = ?',
      [1, id],
    );
  }
}

import 'dart:io';
import 'package:englozi/model/dic_model.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _dbName = 'englozi.db';
  static const _tableName = 'engTable';
  static const _dbVersion = 1;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDb();
    return _database!;
  }

  Future initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    final exist = await databaseExists(path);

    if (!exist) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join('assets', _dbName));
      List<int> byte =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(byte, flush: true);
    } else {
      print('opening existing database in DBB');
    }

    return await openDatabase(path, version: _dbVersion);
  }

  Future<List<DictionaryModel>> queryAll() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> data = await db.query(_tableName);

    return data.map((e) => DictionaryModel.fromMap(e)).toList();
  }

  Future<List<DictionaryModel>> searchWords(String keyword) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> allRows = await db
        .query(_tableName, where: 'word LIKE ?', whereArgs: ['$keyword%']);
    return allRows.map((e) => DictionaryModel.fromMap(e)).toList();
  }

}

// WHERE word LIKE 'keyword%' -> finds word that starts with keyword
// WHERE word LIKE '%keyword' -> finds word that ends with keyword
// WHERE word LIKE '%keyword%' -> finds word that have keyword at any position

import 'dart:io';
import 'package:englozi/model/phr_model.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PhrasesDB {
  static const _dbName = 'phrasesDB.db';
  static const _tableName = 'phrTable';
  static const _dbVersion = 1;

  PhrasesDB._privateConstructor();

  static final PhrasesDB instance = PhrasesDB._privateConstructor();

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
      print('opening existing database in Phrases');
    }

    return await openDatabase(path, version: _dbVersion);
  }

  Future<List<PhraseDictionary>> queryAll() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> data = await db.query(_tableName);

    return data.map((e) => PhraseDictionary.fromMap(e)).toList();
  }

  Future<List<PhraseDictionary>> searchWords(String keyword) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> allRows = await db
        .query(_tableName, where: 'phrEnglish LIKE ?', whereArgs: ['%$keyword%']);
    return allRows.map((e) => PhraseDictionary.fromMap(e)).toList();
  }

}
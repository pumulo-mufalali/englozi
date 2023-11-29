import 'dart:io';
import 'package:englozi/model/his_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHistory {
  static const _dbName = 'myHistory.db';
  static const _tableName = 'myHistory';
  static const _dbVersion = 1;

  static const columnId = 'id';
  static const columnWord = 'word';

  DatabaseHistory._privateConstructor();
  static final DatabaseHistory instance = DatabaseHistory._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initiateDatabase();

  Future _initiateDatabase () async {
    Directory directory = await getApplicationDocumentsDirectory();

    String path = join(directory.path, _dbName);

    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) {
    return db.execute(
      ''' 
        CREATE TABLE $_tableName(
        $columnId INTEGER PRIMARY KEY,
        $columnWord TEXT NOT NULL)
      '''
    );
  }

  Future<int> insert(History history) async{

    Database db = await instance.database;

    return await db.insert(_tableName, history.toMap());
  }

  Future<List<History>> queryAll() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> data = await db.query(_tableName);

    return data.map((e) => History.fromMap(e)).toList();
  }

  Future<List<History>> searchWords(String keyword) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> allRows = await db
        .query(_tableName, where: 'word LIKE ?', whereArgs: ['$keyword%']);
    return allRows.map((e) => History.fromMap(e)).toList();
  }

  Future<int> update(Map<String,dynamic> row) async{

    Database db = await instance.database;

    int id = row[columnId];

    return await db.update(_tableName, row, where: '$columnId=?',whereArgs: [id]);
  }
  
  Future<int> delete(int id) async{

    Database db = await instance.database;

    return await db.rawDelete('DELETE FROM $_tableName WHERE $columnId = $id');
  }

  Future<int> deleteAll(int id) async{

    Database db = await instance.database;

    return await db.delete(_tableName, where: '$columnId=?', whereArgs: [id]);
  }
}
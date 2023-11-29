import 'dart:io';
import 'package:englozi/model/fav_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseFavourite {
  static const _dbName = 'myFavourite.db';
  static const _tableName = 'myFavourite';
  static const _dbVersion = 1;

  static const columnId = 'id';
  static const columnWord = 'word';
  static const columnBool = 'ispressed';

  DatabaseFavourite._privateConstructor();
  static final DatabaseFavourite instance = DatabaseFavourite._privateConstructor();

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
        $columnWord TEXT NOT NULL,
        $columnBool TEXT)
      '''
    );
  }

  Future<int> insert(Favourite favourite) async{

    Database db = await instance.database;

    return await db.insert(_tableName, favourite.toMap());
  }

  Future<List<Favourite>> queryAll() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> data = await db.query(_tableName);

    return data.map((e) => Favourite.fromMap(e)).toList();
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
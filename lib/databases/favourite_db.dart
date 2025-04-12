import 'dart:io';
import 'package:englozi/model/fav_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

class DatabaseFavourite {
  // Database constants
  static const _dbName = 'favourites.db';
  static const _tableName = 'favourites';
  static const _dbVersion = 1;

  // Column names
  static const columnId = 'id';
  static const columnWord = 'word';
  static const columnIsPressed = 'isPressed'; // Changed from 'ispressed' for consistency

  // Singleton pattern
  DatabaseFavourite._privateConstructor();
  static final DatabaseFavourite instance = DatabaseFavourite._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initiateDatabase();

  Future<Database> _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Added for future migrations
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName(
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnWord TEXT NOT NULL UNIQUE,  -- Prevents duplicates
        $columnIsPressed INTEGER NOT NULL DEFAULT 0  -- Store as 0/1
      )
    ''');

    // Add index for faster word searches
    await db.execute('''
      CREATE INDEX idx_word ON $_tableName($columnWord)
    ''');
  }

  // Placeholder for future database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      // Add migration logic here if needed
    }
  }

  // --- CRUD Operations ---

  /// Inserts a favourite word. Returns ID if successful, -1 on error.
  Future<int> insertFavourite(Favourite favourite) async {
    try {
      final db = await instance.database;
      return await db.insert(
        _tableName,
        favourite.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace, // Handles duplicates
      );
    } catch (e) {
      debugPrint('Insert error: $e');
      return -1;
    }
  }

  /// Gets all favourites in descending order (newest first)
  Future<List<Favourite>> getAllFavourites() async {
    try {
      final db = await instance.database;
      final data = await db.query(
        _tableName,
        orderBy: '$columnId DESC', // Newest first
      );
      return data.map((e) => Favourite.fromMap(e)).toList();
    } catch (e) {
      debugPrint('Query error: $e');
      return [];
    }
  }

  /// Checks if a word exists in favourites
  Future<bool> isFavourite(String word) async {
    try {
      final db = await instance.database;
      final result = await db.query(
        _tableName,
        where: '$columnWord = ?',
        whereArgs: [word],
        limit: 1,
      );
      return result.isNotEmpty;
    } catch (e) {
      debugPrint('Check favourite error: $e');
      return false;
    }
  }

  /// Updates isPressed status for a word
  Future<int> updateFavourite(Favourite favourite) async {
    try {
      final db = await instance.database;
      return await db.update(
        _tableName,
        favourite.toMap(),
        where: '$columnId = ?',
        whereArgs: [favourite.id],
      );
    } catch (e) {
      debugPrint('Update error: $e');
      return 0;
    }
  }

  /// Deletes a favourite by ID
  Future<int> deleteFavourite(int id) async {
    try {
      final db = await instance.database;
      return await db.delete(
        _tableName,
        where: '$columnId = ?',
        whereArgs: [id],
      );
    } catch (e) {
      debugPrint('Delete error: $e');
      return 0;
    }
  }

  /// Deletes a favourite by word (alternative approach)
  Future<int> deleteFavouriteByWord(String word) async {
    try {
      final db = await instance.database;
      return await db.delete(
        _tableName,
        where: '$columnWord = ?',
        whereArgs: [word],
      );
    } catch (e) {
      debugPrint('Delete by word error: $e');
      return 0;
    }
  }

  /// Clears all favourites
  Future<int> clearAllFavourites() async {
    try {
      final db = await instance.database;
      return await db.delete(_tableName);
    } catch (e) {
      debugPrint('Clear all error: $e');
      return 0;
    }
  }

  Future<bool> isWordFavourited(String word) async {
    final db = await database;
    final result = await db.query(
      _tableName,
      where: '$columnWord = ?',
      whereArgs: [word],
    );
    return result.isNotEmpty;
  }

}
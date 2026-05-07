import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/game_record.dart';

class DatabaseService {
  static Database? _database;
  static const String _tableName = 'game_records';

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'babystudy.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            gameType TEXT NOT NULL,
            ageGroup TEXT NOT NULL,
            score INTEGER NOT NULL,
            stars INTEGER NOT NULL,
            playedAt TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertGameRecord(GameRecord record) async {
    final db = await database;
    return await db.insert(_tableName, record.toMap());
  }

  Future<List<GameRecord>> getGameRecordsByAgeGroup(String ageGroup) async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: 'ageGroup = ?',
      whereArgs: [ageGroup],
      orderBy: 'playedAt DESC',
    );
    return maps.map((map) => GameRecord.fromMap(map)).toList();
  }

  Future<List<GameRecord>> getAllGameRecords() async {
    final db = await database;
    final maps = await db.query(_tableName, orderBy: 'playedAt DESC');
    return maps.map((map) => GameRecord.fromMap(map)).toList();
  }
}

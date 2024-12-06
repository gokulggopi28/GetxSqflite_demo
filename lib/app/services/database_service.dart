import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();
  final String _tasksTableName = "tasks";
  final String _taskIdColumnName = "id";
  final String _taskContentColumnName = "content";
  final String _taskStatusColumnName = "status";

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");

    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tasksTableName(
            $_taskIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
            $_taskContentColumnName TEXT NOT NULL,
            $_taskStatusColumnName INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> insertItem(Map<String, dynamic> task) async {
    final db = await database;
    await db.insert(_tasksTableName, task);
  }

  Future<List<Map<String, dynamic>>> fetchItems() async {
    final db = await database;
    return await db.query(_tasksTableName);
  }

  Future<void> deleteItem(int id) async {
    final db = await database;
    await db.delete(
      _tasksTableName,
      where: '$_taskIdColumnName = ?',
      whereArgs: [id],
    );
  }
}

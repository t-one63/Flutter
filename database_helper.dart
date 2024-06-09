import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SampleItem {
  String id;
  String name;

  SampleItem({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'sample_items.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE items(id TEXT PRIMARY KEY, name TEXT)",
        );
      },
    );
  }

  Future<void> insertItem(SampleItem item) async {
    final db = await database;
    await db.insert(
      'items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SampleItem>> getItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('items');
    return List.generate(maps.length, (i) {
      return SampleItem(
        id: maps[i]['id'],
        name: maps[i]['name'],
      );
    });
  }

  Future<void> deleteItem(String id) async {
    final db = await database;
    await db.delete(
      'items',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> updateItem(SampleItem item) async {
    final db = await database;
    await db.update(
      'items',
      item.toMap(),
      where: "id = ?",
      whereArgs: [item.id],
    );
  }
}

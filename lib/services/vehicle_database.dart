import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/vehicle_info.dart';


class VehicleDatabase {
  VehicleDatabase({Database? database}) : _injected = database;

  /// App-wide shared instance.
  static final VehicleDatabase instance = VehicleDatabase();

  static const _fileName = 'car_dna.db';
  static const _version = 2;
  static const table = 'vehicles';

  final Database? _injected;
  Database? _db;

  Future<Database> get _database async =>
      _injected ?? (_db ??= await _open());

  Future<Database> _open() async {
    final path = p.join(await getDatabasesPath(), _fileName);
    return openDatabase(
      path,
      version: _version,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        vin         TEXT PRIMARY KEY,
        year        INTEGER,
        make        TEXT,
        model       TEXT,
        data        TEXT NOT NULL,
        searched_at INTEGER NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add the search timestamp; back-fill existing rows with "now" so they
      // still show up in the recent list rather than being dropped.
      await db.execute(
        'ALTER TABLE $table ADD COLUMN searched_at INTEGER NOT NULL DEFAULT 0',
      );
      await db.update(
        table,
        {'searched_at': DateTime.now().millisecondsSinceEpoch},
        where: 'searched_at = 0',
      );
    }
  }

  /// Returns the cached vehicle for [vin], or `null` if not stored yet.
  Future<VehicleInfo?> findByVin(String vin) async {
    final db = await _database;
    final rows = await db.query(
      table,
      where: 'vin = ?',
      whereArgs: [vin],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return VehicleInfo.fromDbMap(rows.first);
  }

  Future<void> save(VehicleInfo info) async {
    final db = await _database;
    await db.insert(
      table,
      info.toDbMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<VehicleInfo>> recentSearches({int? limit}) async {
    final db = await _database;
    final rows = await db.query(
      table,
      orderBy: 'searched_at DESC',
      limit: limit,
    );
    return rows.map(VehicleInfo.fromDbMap).toList();
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}

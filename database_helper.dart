// -------  Nama Program : Login dan Register -------
//------- Author : Refan Rustoni Putra ------
//------- Versi : 10  ------
//------- Ownership : Pribadi------
//------- Deskripsi : Pembuatan halaman Login, Dashboard dan Profile ------
//------- Pekan Ke 5 --------------
//------- Library --------
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // ─── GET DATABASE ───────────────────────────────────
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('luminous.db');
    return _database!;
  }

  // ─── INIT DB ────────────────────────────────────────
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // ─── CREATE TABLE ───────────────────────────────────
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nim TEXT UNIQUE,
        nama TEXT,
        kelas TEXT,
        prodi TEXT,
        angkatan INTEGER,
        foto TEXT,
        password TEXT,
        gpa TEXT,
        hadirCount INTEGER,
        totalPertemuan INTEGER
      )
    ''');
  }

  // ─── INSERT USER ────────────────────────────────────
  Future<void> insertUser(User user) async {
    final db = await database;

    await db.insert(
      'users',
      user.toMap(), // 🔥 pakai ini biar semua field masuk
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  // ─── CEK USER ADA ───────────────────────────────────
  Future<bool> userExists(String nim) async {
    final db = await database;

    final result = await db.query(
      'users',
      where: 'nim = ?',
      whereArgs: [nim],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  // ─── FIND USER (LOGIN) ──────────────────────────────
  Future<User?> findUser(String nim) async {
    final db = await database;

    final result = await db.query(
      'users',
      where: 'nim = ?',
      whereArgs: [nim],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }

    return null;
  }

  // ─── UPDATE PASSWORD ────────────────────────────────
  Future<int> updatePassword(String nim, String newPassword) async {
    final db = await database;

    return await db.update(
      'users',
      {'password': newPassword},
      where: 'nim = ?',
      whereArgs: [nim],
    );
  }
}

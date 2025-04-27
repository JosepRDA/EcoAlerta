import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Singleton setup
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static const _databaseName = 'eco_alerta.db';
  static const _databaseVersion = 1;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Initialize ffi for desktop
    sqfliteFfiInit();
    // Use the ffi factory
    databaseFactory = databaseFactoryFfi;

    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // Create the user table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');
  }

  // Insert a new user into the database
  Future<int> insertUser(String email, String password) async {
    final db = await database;
    return await db.insert(
      'users',
      {'email': email, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  // Validate user credentials
  Future<bool> validateUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty;
  }
}
  
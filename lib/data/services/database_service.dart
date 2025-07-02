import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../core.dart';
import '../../features/main_page/model/users_list_response_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._constructor();
  static Database? _db;

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'users_book.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY,
      name TEXT,
      username TEXT,
      email TEXT,
      phone TEXT,
      website TEXT,
      street TEXT,
      suite TEXT,
      city TEXT,
      zipcode TEXT,
      geo_lat TEXT,
      geo_lng TEXT,
      company_name TEXT,
      company_catchPhrase TEXT,
      company_bs TEXT
    )
    ''');
  }

  /// Insert a single user
  Future<void> insertUser(UsersListResponseModel user) async {
    final db = await database;
    await db.insert('users', _userToDbMap(user), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Insert or update users (upsert)
  Future<void> upsertUsers(List<UsersListResponseModel> users) async {
    final db = await database;
    final batch = db.batch();

    for (final user in users) {
      batch.insert('users', _userToDbMap(user), conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit(noResult: true);
  }

  /// Insert a list of users
  Future<void> insertUsers(List<UsersListResponseModel> users) async {
    final db = await database;
    final batch = db.batch();
    for (final user in users) {
      batch.insert('users', _userToDbMap(user), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  /// Get all users
  Future<List<UsersListResponseModel>> getAllUsers() async {
    final db = await database;
    final maps = await db.query('users');
    return maps.map(_dbMapToUser).toList();
  }

  /// Get user by ID
  Future<UsersListResponseModel?> getUserById(int id) async {
    final db = await database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id], limit: 1);
    if (maps.isNotEmpty) {
      return _dbMapToUser(maps.first);
    }
    return null;
  }

  /// Convert user model to DB map
  Map<String, dynamic> _userToDbMap(UsersListResponseModel user) {
    return {
      'id': user.id,
      'name': user.name,
      'username': user.username,
      'email': user.email,
      'phone': user.phone,
      'website': user.website,
      'street': user.address?.street,
      'suite': user.address?.suite,
      'city': user.address?.city,
      'zipcode': user.address?.zipcode,
      'geo_lat': user.address?.geo?.lat,
      'geo_lng': user.address?.geo?.lng,
      'company_name': user.company?.name,
      'company_catchPhrase': user.company?.catchPhrase,
      'company_bs': user.company?.bs,
    };
  }

  /// Convert DB map back to user model
  UsersListResponseModel _dbMapToUser(Map<String, dynamic> map) {
    return UsersListResponseModel(
      id: map['id'] as int?,
      name: map['name'],
      username: map['username'],
      email: map['email'],
      phone: map['phone'],
      website: map['website'],
      address: Address(
        street: map['street'],
        suite: map['suite'],
        city: map['city'],
        zipcode: map['zipcode'],
        geo: Geo(lat: map['geo_lat'], lng: map['geo_lng']),
      ),
      company: Company(name: map['company_name'], catchPhrase: map['company_catchPhrase'], bs: map['company_bs']),
    );
  }

  Future<int> getMaxUserId() async {
    final db = await database;
    final result = await db.rawQuery("SELECT MAX(id) as max_id FROM users");
    final maxId = result.first["max_id"] as int?;
    return maxId ?? 0; // if table empty, return 0
  }
}

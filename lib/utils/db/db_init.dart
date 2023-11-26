
import 'package:sqflite/sqflite.dart';

class DatabaseInit {
  static final DatabaseInit _databaseInit = DatabaseInit._privateConstructor();
  DatabaseInit._privateConstructor();

  factory DatabaseInit() {
    return _databaseInit;
  }

  static Database? _database;

  Future<Database> get database async => _database ??= await initDB();

  initDB() async {
    String path = await getDatabasesPath() + 'yhlife.db';
    // databaseFactory.deleteDatabase(path);

    return await openDatabase(
      path,
      version:1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE ObjectiveSettingInfo(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              timer INTEGER NOT NULL,
              count INTEGER NOT NULL
            )
        ''');

        await db.execute('''
        CREATE TABLE WorkoutRecord(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              dateTime TEXT NOT NULL,
              useTime INTEGER NOT NULL, 
              count INTEGER NOT NULL
            )
        ''');

        await db.execute('''
        CREATE TABLE Member(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            height INTEGER,
            weight INTEGER,
            birth TEXT
          )
        ''');

        await db.execute('''
        CREATE TABLE Notification(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            image TEXT,
            title TEXT,
            time TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE Contact(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            contact TEXT,
            notificationAvailability INTEGER
          )
        ''');
      },

    );
  }
}



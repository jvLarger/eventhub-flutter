import 'dart:async';

import 'package:eventhub/utils/util.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' show join;

class EventHubDatabase {
  static const _databaseName = "eventhub.db";
  static const _databaseVersion = 2;

  EventHubDatabase._internal() {
    // if (_database == null) database;
  }
  static final EventHubDatabase instance = EventHubDatabase._internal();

  static final EventHubDatabase db = EventHubDatabase.instance;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    Util.printInfo("Abrindo a conexção com o banco local...");
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onOpen: (db) {},
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) {},
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE usuario(
            id INTEGER NOT NULL PRIMARY KEY,
            nome_completo VARCHAR(255) NOT NULL,
            nome_usuario VARCHAR(60) NOT NULL,
            email VARCHAR(60) NOT NULL,
            token TEXT NOT NULL,
            nome_absoluto_foto TEXT,
            identificador_notificacao TEXT
          )
    ''');
  }
}

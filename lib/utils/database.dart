import 'dart:io';
import 'package:sampleapp/models/offline_userlist_object.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class OfflineuserDB {
  static final OfflineuserDB db = OfflineuserDB();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Offlineuser.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE Offlineuser("
              "id INTEGER PRIMARY KEY,"
              "first_name TEXT,"
              "last_name TEXT,"
              "email TEXT,"
              "avatar TEXT"
              ")");
        });
  }
  addofflineuser(Offlineuser newofflineuser) async {
    final db = await database;
    var raw = await db.rawInsert(
        "INSERT Into offlineuser (id,first_name,last_name,email,avatar)"
            " VALUES (?,?,?,?,?)",
        [
          newofflineuser.id,
          newofflineuser.first_name,
          newofflineuser.last_name,
          newofflineuser.email,
          newofflineuser.avatar,
        ]);
    return raw;
  }
   getofflineuser() async {
    final db = await database;
    var userlist = await db.rawQuery("SELECT * FROM Offlineuser");
    return userlist;
  }
  deleteofflineuser(int id) async {
    final db = await database;
    return db.delete("Offlineuser", where: "id = ?", whereArgs: [id]);
  }
}

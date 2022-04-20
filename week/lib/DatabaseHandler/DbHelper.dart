import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:week/models/user.dart';
import 'dart:io' as io;

import '../models/UserModel.dart';
import '../models/posts_model.dart';

//https://docs.google.com/document/d/1dWfVb4_8pQdX5RpuxDcfvnejCCUxqhnqpXJjzThzb6A/edit

class DbHelper {
  static Database? _db;
  static final DbHelper instance = DbHelper.initDb();
  DbHelper.initDb();

  static const DB_Name = 'app2.db';
  static const String Table_User = 'user';
  static const String tableFollowers = 'follower';
  static const String tablePhotos = 'photo';
  static const String tableOutfit = 'outfit';
  static const int Version = 1;

  static const String C_UserID = 'user_id';
  static const String C_UserName = 'user_name';
  static const String C_Email = 'email';
  static const String C_Password = 'password';

  static const String followerID = "";

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDb();

    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_Name);
    var db = await openDatabase(path, version: Version, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int intVersion) async {
    await db.execute("CREATE TABLE $Table_User ("
        " $C_UserID TEXT, "
        " $C_UserName TEXT, "
        " $C_Email TEXT,"
        " $C_Password TEXT, "
        " PRIMARY KEY ($C_UserID)"
        ")");

    await db.execute("CREATE TABLE $tableFollowers ("
        " $C_UserID TEXT, "
        " $followerID TEXT,"
        " date TEXT,"
        " PRIMARY KEY ($C_UserID)"
        ")");

    await db.execute("CREATE TABLE $tableOutfit ("
        " $C_UserID TEXT, "
        " photoID INTEGER,"
        " date TEXT,"
        " clothType TEXT,"
        " season TEXT,"
        " brand TEXT,"
        " store TEXT,"
        " PRIMARY KEY ($C_UserID)"
        ")");

    await db.execute("CREATE TABLE publication ("
        "publicationID INTEGER PRIMARY KEY,"
        "albumId INTEGER, "
        "$C_UserID TEXT," 
        "caption TEXT,"
        "image TEXT, "
        "date TEXT,"
        ")");

    await db.execute("CREATE TABLE likes ("
        "$C_UserID PRIMARY KEY,"
        "publicationID INTEGER,"
        "liked INTEGER,"   // 0 -> no like 1 -> like
        "FOREIGN KEY(publicationID) REFERENCES publication(publicationID)" 
        ")");

    await db.execute("CREATE TABLE comments ("
        "commentID INTEGER PRIMARY KEY,"
        "publicationID INTEGER," 
        "commentText TEXT,"
        "FOREIGN KEY(publicationID) REFERENCES publication(publicationID)"
        ")");
    
  }

  Future<int?> saveData(UserModel user) async {
    var dbClient = await db;
    var res = await dbClient?.insert(Table_User, user.toMap());
    return res;
  }

  Future<UserModel?> getLoginUser(String userId, String password) async {
    var dbClient = await db;
    var res = await dbClient!.rawQuery("SELECT * FROM $Table_User WHERE "
        "$C_UserID = '$userId' AND "
        "$C_Password = '$password'");

    if (res.length > 0) {
      return UserModel.fromMap(res.first);
    }

    return null;
  }

  Future<int> updateUser(UserModel user) async {
    var dbClient = await db;
    var res = await dbClient!.update(Table_User, user.toMap(),
        where: '$C_UserID = ?', whereArgs: [user.user_id]);
    return res;
  }

  // photos db
  Future<Photo?> photo(String date) async {
    var dbClient = await db;
    final List<Map<String, dynamic>> photo =
        await dbClient!.query("photo WHERE date = '$date'");

    if (photo.isNotEmpty) {
      return Photo.fromMap(photo.first);
    }

    return null;
  }


  Future<int> deleteUser(String user_id) async {
    var dbClient = await db;
    var res = await dbClient!
        .delete(Table_User, where: '$C_UserID = ?', whereArgs: [user_id]);
    return res;
  }
}
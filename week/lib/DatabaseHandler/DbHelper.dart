import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:week/models/follower_model.dart';
import 'package:week/models/outfit_model.dart';
import 'package:week/models/user.dart';
import 'dart:io' as io;

import '../models/UserModel.dart';
import '../models/posts_model.dart';

//https://docs.google.com/document/d/1dWfVb4_8pQdX5RpuxDcfvnejCCUxqhnqpXJjzThzb6A/edit

class DbHelper {
  static Database? _db;
  static final DbHelper instance = DbHelper.initDb();
  DbHelper.initDb();

  static const DB_Name = 'app12.db';
  static const String Table_User = 'user';
  static const String tableFollowers = 'follower';
  static const String tablePhotos = 'photo';
  static const String tableOutfit = 'outfit';
  static const int Version = 1;

  static const String C_UserID = 'user_id';
  static const String C_UserName = 'user_name';
  static const String C_Email = 'email';
  static const String C_Password = 'password';

  static const String followerID = "followerID";

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
        " imagePath TEXT, "
        " about TEXT, "
        " PRIMARY KEY ($C_UserID)"
        ")");

    await db.execute("CREATE TABLE $tableFollowers ("
        " followID TEXT PRIMARY KEY, "
        " $C_UserID TEXT, "
        " $followerID TEXT,"
        " date TEXT"
        ")");

    await db.execute("CREATE TABLE $tableOutfit ("
        " clothingID TEXT PRIMARY KEY,"
        " $C_UserID TEXT,"
        " photoID TEXT,"
        " date TEXT,"
        " clothType TEXT,"
        " season TEXT,"
        " brand TEXT,"
        " store TEXT,"
        " color TEXT"
        ")");

    await db.execute("CREATE TABLE publication ("
        " publicationID INTEGER PRIMARY KEY AUTOINCREMENT,"
        " $C_UserID TEXT,"
        " photoID TEXT,"
        " date TEXT,"
        " FOREIGN KEY(photoID) REFERENCES photo(photoID)"
        ")");

    await db.execute("CREATE TABLE photo ("
        "photoID INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$C_UserID TEXT,"
        "image TEXT,"
        "FOREIGN KEY($C_UserID) REFERENCES $Table_User($C_UserID)"
        ")");

    await db.execute("CREATE TABLE likes ("
        "$C_UserID TEXT PRIMARY KEY,"
        "publicationID INTEGER,"
        "liked INTEGER," // 0 -> no like 1 -> like
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

  Future<UserModel?> getUserInfo(String userId) async {
    var dbClient = await db;
    debugPrint('Searching for pub of: ' + userId);
    var res = await dbClient!.rawQuery("SELECT * FROM $Table_User WHERE "
        "$C_UserID = '$userId'");

    if (res.isNotEmpty) {
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
        await dbClient!.query("publication WHERE date = '$date'");

    if (photo.isNotEmpty) {
      return Photo.fromMap(photo.first);
    }

    return null;
  }

  // photos db
  Future<Photo?> photoToday(String uid, String date, String nextDay) async {
    var dbClient = await db;
    debugPrint('userid: ' + uid);
    final List<Map<String, dynamic>> pub = await dbClient!.rawQuery(
        "SELECT * FROM publication WHERE $C_UserID = ('$uid') and date >= date('$date') and date < date('$nextDay')");

    final List<Map<String, dynamic>> t =
        await dbClient.rawQuery("SELECT * FROM photo");

    for (var i = 0; i < t.length; i++) {
      print(Photo.fromMap(t[i]).toString());
    }

    if (pub.isNotEmpty) {
      print('Publications today: ' + pub.length.toString());
      String pid = Publication.fromMap(pub.last).photoId.toString();
      print("Photo ID: " + pid);
      final List<Map<String, dynamic>> photo =
          await dbClient.query("photo WHERE photoID=($pid)");

      if (photo.isNotEmpty) {
        print(photo.first.toString());
        return Photo.fromMap(photo.first);
      }
    }

    return null;
  }

  void insertPhoto(Photo photo) async {
    print('photo be inserted: ' + photo.toString());
    await _db!.insert(
      'photo',
      photo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> follow(FollowerModel fmodel) async {
    print("The user: " +
        fmodel.user_id +
        " wants to follow: " +
        fmodel.followerID);
    int rowInserted = await _db!.insert(
      tableFollowers,
      fmodel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    if (rowInserted != -1) {
      debugPrint('Row inserted');
      return true;
    } else {
      return false;
    }
  }

  void unfollow(FollowerModel fmodel) async {
    var dbClient = await db;
    await dbClient!.delete(tableFollowers,
        where: '$C_UserID = ? and $followerID = ?',
        whereArgs: [fmodel.user_id, fmodel.followerID]);
  }

  Future<List<FollowerModel>?> getFollowers(String uid) async {
    final List<Map<String, dynamic>> users = await _db!
        .rawQuery("SELECT * FROM $tableFollowers WHERE $C_UserID=('$uid')");

    if (users.isNotEmpty) {
      print('got users');
      var list = <FollowerModel>[];
      for (var user in users) {
        print(FollowerModel.fromMap(user).toString());
        list.add(FollowerModel.fromMap(user));
      }
      return list;
    }

    return null;
  }

  Future<List<UserModel>?> getRandomUsers(String uid) async {
    final List<Map<String, dynamic>> users = await _db!.rawQuery(
        "SELECT * FROM $Table_User WHERE $C_UserID!='$uid' ORDER BY RANDOM() LIMIT 5");

    if (users.isNotEmpty) {
      print('got users!!!');
      var list = <UserModel>[];
      for (var user in users) {
        print(UserModel.fromMap(user).toString());
        list.add(UserModel.fromMap(user));
      }
      return list;
    }

    return null;
  }

  Future<Publication?> getPub(String uid, String date, String nextDay) async {
    final List<Map<String, dynamic>> pub = await _db!.rawQuery(
        "SELECT * FROM publication WHERE $C_UserID='$uid' and date >= date('$date') and date < date('$nextDay') ORDER BY date DESC LIMIT 1");

    if (pub.isNotEmpty) {
      debugPrint('got posts!!!');
      debugPrint(Publication.fromMap(pub.first).toString());
      return Publication.fromMap(pub.first);
    }

    return null;
  }

  Future<String?> getLastPhotoID() async {
    /*
    final List<Map<String, dynamic>> id =
        await _db!.rawQuery("SELECT last_insert_rowid()");

    if (id.isNotEmpty) {
      return int.parse(id.first['last_insert_rowid()'].toString());
    }*/

    final List<Map<String, dynamic>> id =
        await _db!.rawQuery("SELECT MAX(photoID) AS max_id FROM photo");

    if (id.isNotEmpty) {
      return id.first['max_id'].toString();
    }

    return null;
  }

  Future<Photo?> getPhoto(String photoID) async {
    final List<Map<String, dynamic>> photo =
        await _db!.rawQuery("SELECT * FROM photo WHERE photoID='$photoID'");

    if (photo.isNotEmpty) {
      return Photo.fromMap(photo.first);
    }

    return null;
  }

  void insertPublication(Publication publication) async {
    await _db!.insert(
      'publication',
      publication.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void insertClothing(Clothing clothing) async {
    await _db!.insert(
      tableOutfit,
      clothing.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Clothing>?> getClothing(String uid, String pid) async {
    var dbClient = await db;
    final List<Map<String, dynamic>> clothing = await dbClient!.rawQuery(
        "SELECT * FROM $tableOutfit WHERE ($C_UserID=('$uid') and photoID=($pid))");

    final List<Map<String, dynamic>> t = await dbClient
        .rawQuery("SELECT * FROM $tableOutfit WHERE $C_UserID = '$uid'");

    for (var item in t) {
      print(Clothing.fromMap(item).toString());
    }

    if (clothing.isNotEmpty) {
      print('got clothing');
      var list = <Clothing>[];
      for (var item in clothing) {
        print(Clothing.fromMap(item).toString());
        list.add(Clothing.fromMap(item));
      }
      return list;
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

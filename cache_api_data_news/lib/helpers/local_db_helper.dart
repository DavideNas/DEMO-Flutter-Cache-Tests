import 'dart:developer' as console;

import 'package:cache_api_data_news/models/hacker_news_model.dart';
import 'package:sqflite/sqflite.dart';

class LocalDbHelper {
  // CREATE NEWS && DATA_TIME TABLE
  static Future<Database> createDatabase() async {
    return await openDatabase(
      "hacker_news.db",
      version: 1,
      onCreate: (db, version) async {
        // TABLE news
        await db.execute(
          'CREATE TABLE news (id INTEGER PRIMARY KEY, title TEXT, url TEXT, author VARCHAR(255), updatedAt TEXT)',
        );
        // TABLE saved_time
        await db.execute(
          'CREATE TABLE saved_time (page_no INTEGER PRIMARY KEY, lastSavedTime DATETIME)',
        );
      },
    );
  }

  // ADD NEWS TO LOCAL DB
  static Future insertNews(HackerNewsModel hackerNewsModel) async {
    var db = await createDatabase();

    return await db.insert("news", {
      "id": hackerNewsModel.id,
      "title": hackerNewsModel.title,
      "url": hackerNewsModel.url,
      "author": hackerNewsModel.author,
      "updatedAt": hackerNewsModel.updatedAt,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // FETCH LATEST 20 NEWS FROM LOCAL DB
  static Future<List<Map<String, dynamic>>> getNews() async {
    var db = await createDatabase();
    return await db.query("news", orderBy: "updatedAt DESC", limit: 20);
  }

  // FETCH MORE 20 NEWS FROM DB
  static Future<List<Map<String, dynamic>>> getMoreNews(int lastNo) async {
    var db = await createDatabase();
    return await db.query(
      "news",
      orderBy: "updatedAt DESC",
      limit: 20,
      offset: lastNo,
    );
  }

  // COUNT LOCAL DB NEWS
  static Future<int?> getNewsCount() async {
    var db = await createDatabase();
    return Sqflite.firstIntValue(
      await db.rawQuery("SELECT COUNT(*) FROM news"),
    );
  }

  // DELETE STORED NEWS
  static Future deleteNewsTable() async {
    var db = await createDatabase();
    return await db.delete("news");
  }

  // INSERT TIME AFTER SAVING TO DB
  static Future insertSaveTime(int pageNo) async {
    var db = await createDatabase();
    return await db.insert("saved_time", {
      "page_no": pageNo,
      "lastSavedTime": DateTime.now().toString(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // GET SAVED TIME FOR EACH PAGE
  static Future<List<Map<String, dynamic>>> getSaveTime() async {
    var db = await createDatabase();
    var data = await db.query("saved_time");
    console.log(data.toString());
    return data;
  }

  // DELETE SAVE_TIME TABLE
  static Future deleteSavedTimeTable() async {
    var db = await createDatabase();
    return await db.delete("saved_time");
  }
}

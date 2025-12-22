# Cache API data news

A sample news app with local caching by DB

## Init

create app with

```sh
flutter create cache_api_data_news
```

then open project and add following packages to `pubspec.yaml` : http, sqflite, url_launcher

You can check pub.dev for latest package version or add by terminal with this command

```sh
flutter pub add http sqflite
```

The project referral api will be https://hn.algolia.com/api/v1/items/1 .  
Open link to get correct model structure.

---

## Scaffold for app

Create new file in `views/home.dart` with a new stf widget Homepage .
Return a simple void Scaffold for now and add it to `main.dart`.

Create model for news in `models/hacker_news_model.dart` and add these field from JSON res.

```dart
class HackerNewsModel {
  final int id;
  final String author;
  final String title;
  final String url;
  final String updatedAt;

  HackerNewsModel({
    required this.id,
    required this.author,
    required this.title,
    required this.url,
    required this.updatedAt,
  });

  factory HackerNewsModel.formJson(Map<String, dynamic> json) =>
      HackerNewsModel(
        id: json["story_id"] ?? 0,
        author: json["author"] ?? "",
        title: json["title"] ?? "",
        url: json["url"] ?? "",
        updatedAt: json["updated_at"] ?? "",
      );
}
```

---

## Add DB helper

In a new file `helpers/local_db_helper.dart` add this code:

```dart
import 'package:cache_api_data_news/models/hacker_news_model.dart';
import 'package:sqflite/sqflite.dart';

class LocalDbHelper {
  // CREATE NEWS TABLE
  static Future<Database> createDatabase() async {
    return await openDatabase(
      "hacker_news.db",
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE news (id INTEGER PRIMARY KEY, title TEXT, url TEXT, author VARCHAR(255), updatedAt TEXT)',
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
}
```

---

## Add API Helper

Then add helper to mange api call.  
In `helpers/api_news_helpers` add following code:

```dart
import 'dart:convert';
import 'package:cache_api_data_news/helpers/local_db_helper.dart';
import 'package:cache_api_data_news/models/hacker_news_model.dart';
import 'package:http/http.dart' as http;

class ApiNewsHelper {
  static Future<bool> getLatestHAckerNews() async {
    String url = "http://hn.algolia.com/api/v1/search_by_date?tags=story";

    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        for (var dt in data["hits"]) {
          var news = HackerNewsModel.formJson(dt);

          // SAVE IN LOCAL DB
          LocalDbHelper.insertNews(news);
        }
        return true;
      } else {
        print("Error within the api call ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
```

---

## Implement Homepage

Reopen file in `view/home.dart` the complete implementation for UI.

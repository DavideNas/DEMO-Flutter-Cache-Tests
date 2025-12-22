import 'dart:convert';
import 'dart:developer' as console;
import 'package:cache_api_data_news/helpers/local_db_helper.dart';
import 'package:cache_api_data_news/models/hacker_news_model.dart';
import 'package:http/http.dart' as http;

class ApiNewsHelper {
  static Future<bool> getLatestHAckerNews(int pageNo) async {
    String url =
        "http://hn.algolia.com/api/v1/search_by_date?tags=story&page=$pageNo";

    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        for (var dt in data["hits"]) {
          var news = HackerNewsModel.formJson(dt);

          // SAVE IN LOCAL DB
          LocalDbHelper.insertNews(news);
          LocalDbHelper.insertSaveTime(pageNo);
        }

        console.log("Data fetch successfully from API");
        return true;
      } else {
        console.log("Error within the api call ${response.statusCode}");
        return false;
      }
    } catch (e) {
      console.log("General API Error : $e");
      return false;
    }
  }
}

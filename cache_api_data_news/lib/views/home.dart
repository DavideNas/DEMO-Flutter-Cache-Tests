import 'dart:developer' as console;

import 'package:cache_api_data_news/helpers/api_news_helper.dart';
import 'package:cache_api_data_news/helpers/local_db_helper.dart';
import 'package:cache_api_data_news/models/hacker_news_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final ScrollController _scrollController = ScrollController();
  List<HackerNewsModel> latestNews = [];
  bool isLoading = true;
  bool isMoreNewsLoading = true;
  List<Map<String, dynamic>> savedTime = [];
  int currentPage = 0;

  // GET ALL TIMES WITHIN PAGE WHERE SAVED TO DB
  Future<void> getLastSavedTime() async {
    var time = await LocalDbHelper.getSaveTime();
    setState(() {
      savedTime = time;
    });
  }

  // FETCH NEWS: DB || API
  void firstPageNews() async {
    int count = await LocalDbHelper.getNewsCount() ?? 0;
    console.log("Saved News count : $count");
    int savedTimeLength = savedTime.length;
    DateTime firstPageSavedTime = savedTimeLength >= 1
        ? DateTime.parse(savedTime[0]["lastSavedTime"] ?? "2000-01-01")
        : DateTime(2000);
    console.log(firstPageSavedTime.toString());

    DateTime currentTime = DateTime.now();
    Duration difference = currentTime.difference(firstPageSavedTime);
    if (difference.inMinutes > 5 || 0 == count) {
      console.log("Fetching from API call");
      var isApifetching = await ApiNewsHelper.getLatestHAckerNews(currentPage);
      if (isApifetching) {
        getNews();
      }
    } else {
      getNews();
    }
  }

  // NEXT PAGE NEWS
  void nextPageNews() async {
    int count = await LocalDbHelper.getNewsCount() ?? 0;
    console.log("Saved News count : $count");
    await getLastSavedTime();
    int savedTimeLength = savedTime.length;
    DateTime nextPageSavedTime = currentPage > savedTimeLength - 1
        ? DateTime(2000)
        : DateTime.parse(
            savedTime[currentPage]["lastSavedTime"] ?? "2000-01-01",
          );
    console.log(nextPageSavedTime.toString());

    DateTime currentTime = DateTime.now();
    Duration difference = currentTime.difference(nextPageSavedTime);
    if (difference.inMinutes > 5) {
      console.log("Fetching from API call for $currentPage");
      var isApifetching = await ApiNewsHelper.getLatestHAckerNews(currentPage);
      if (isApifetching) {
        getMoreNews();
      }
    } else {
      getMoreNews();
    }
  }

  // FETCH FROM LOCAL DB
  void getNews() async {
    var news = await LocalDbHelper.getNews();
    setState(() {
      latestNews = news.map((e) => HackerNewsModel.formJson(e)).toList();
      isLoading = false;
    });
  }

  // FETCH MORE NEW FROM LOCAL DB
  void getMoreNews() async {
    setState(() {
      isMoreNewsLoading = true;
    });
    var news = await LocalDbHelper.getMoreNews(latestNews.length);
    setState(() {
      latestNews.addAll(news.map((e) => HackerNewsModel.formJson(e)).toList());
      isMoreNewsLoading = false;
    });
  }

  // LOAD MORE NEWS ON PULL
  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      currentPage++;
      nextPageNews();
    }
  }

  @override
  void initState() {
    getLastSavedTime();
    firstPageNews();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hacker News"), centerTitle: true),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : latestNews.isEmpty
          ? Center(child: Text("No News Founded"))
          : ListView.builder(
              controller: _scrollController,
              itemCount: latestNews.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text("${index + 1}."),
                  title: Text(latestNews[index].title),
                  subtitle: Text("By : ${latestNews[index].author}"),
                  trailing: IconButton(
                    onPressed: () {
                      _launchUrl(latestNews[index].url);
                    },
                    icon: Icon(Icons.open_in_new),
                  ),
                );
              },
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                getLastSavedTime();
                firstPageNews();
                currentPage = 0;
                setState(() {
                  isLoading = true;
                });
              },
              child: Icon(Icons.refresh),
            ),
            SizedBox(height: 10),
            FloatingActionButton(
              onPressed: () {
                LocalDbHelper.deleteNewsTable();
                LocalDbHelper.deleteSavedTimeTable();
                setState(() {
                  latestNews = [];
                });
              },
              child: Icon(Icons.delete),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isMoreNewsLoading
          ? SizedBox(
              height: 55,
              child: Center(child: CircularProgressIndicator()),
            )
          : null,
    );
  }
}

Future<void> _launchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw Exception('Could not launch $url');
  }
}

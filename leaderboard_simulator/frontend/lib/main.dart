import 'dart:convert';
import 'dart:developer' as console;

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caching',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Box box;
  List data = [];
  late Future<void> _fetchDataFuture;

  static final customCacheManager = CacheManager(
    Config(
      'customCacheImageKey',
      stalePeriod: Duration(days: 15),
      maxNrOfCacheObjects: 1,
    ),
  );

  @override
  void initState() {
    super.initState();
    // fetch data only at the beginning
    _fetchDataFuture = getAllData();
  }

  Future<void> openBox() async {
    if (!Hive.isBoxOpen('data')) {
      box = await Hive.openBox('data');
    } else {
      box = Hive.box('data');
    }
  }

  Future<bool> getAllData() async {
    await openBox();

    // 1. Fetch data form cache to avoid "No Data" message
    setState(() {
      data = box.values.toList();
    });

    // 2. AUTO START DOWNLOAD
    // no 'await' needed if you want to show UI
    updateData();

    return true;
  }

  // ignore: strict_top_level_inference
  Future putData(jsondata) async {
    await box.clear();
    // insert data
    for (var d in jsondata) {
      await box.add(d);
    }
  }

  Future<void> updateData() async {
    // 10.0.2.2 is the correct IP for android emulator
    // 192.168.1.9 is the ip to get data from PC
    var url = Uri.parse("http://192.168.1.9:8000/api/data");
    try {
      // Add a Timeout to avoid infinite loading...
      var response = await http.get(url).timeout(const Duration(seconds: 10));
      console.log("Response received: ${response.statusCode}");

      if (response.statusCode == 200) {
        var jd = jsonDecode(response.body);
        await putData(jd); // Save in Hive

        // 2. Update local variable with new downloaded data
        if (mounted) {
          setState(() {
            data = box.values.toList();
          });
        }
      }
    } on SocketException catch (e) {
      Toast.show(
        "No internet : $e",
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: const Text("Leaderboard"))),
      body: Center(
        child: FutureBuilder(
          future: _fetchDataFuture, // use initState reference
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                data.isEmpty) {
              return const CircularProgressIndicator();
            }
            if (data.isEmpty) {
              return const Text(
                'No Data Found',
                style: TextStyle(fontSize: 24),
              );
            }

            return Column(
              children: [
                SizedBox(height: 25),
                CachedNetworkImage(
                  cacheManager: customCacheManager,
                  imageUrl:
                      "https://badgeos.org//wp-content/uploads/edd/2013/11/leaderboard.png",
                  height: 250,
                  placeholder: (context, url) {
                    return FaIcon(
                      FontAwesomeIcons.trophy,
                      size: 250,
                      color: Colors.pink.shade800,
                    );
                  },
                  errorWidget: (context, url, error) => Container(
                    color: Colors.transparent,
                    child: Center(
                      child: Icon(
                        FontAwesomeIcons.gamepad,
                        size: 250,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                // Image(
                //   image: NetworkImage(
                //     "https://badgeos.org//wp-content/uploads/edd/2013/11/leaderboard.png",
                //   ),
                //   height: 250,
                // ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: updateData,
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (ctx, index) {
                        return ListTile(
                          title: Text("${data[index]['name']}"),
                          trailing: Text("${data[index]['marks']}"),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

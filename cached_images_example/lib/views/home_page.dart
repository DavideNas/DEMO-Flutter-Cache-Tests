import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final customCacheManager = CacheManager(
    Config(
      'customCacheKey',
      stalePeriod: Duration(days: 15),
      maxNrOfCacheObjects: 100,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Cached Network Image"),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              onPressed: clearCache,
              child: Text('Clear Cache', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
        body: ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: 50,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.white,
              child: ListTile(
                leading: buildImage(index),
                title: Text(
                  "Image ${index + 1}",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildImage(int index) => ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: CachedNetworkImage(
      cacheManager: customCacheManager,
      key: UniqueKey(),
      imageUrl: "https://picsum.photos/100/100?random=$index",
      height: 50,
      width: 50,
      fit: BoxFit.cover,
      // maxHeightDiskCache: 75,
      placeholder: (context, url) {
        // return Center(child: CircularProgressIndicator());
        return Container(color: Colors.black);
      },
      errorWidget: (context, url, error) => Container(
        color: Colors.black,
        child: Icon(Icons.error, color: Colors.red),
      ),
    ),
    //backgroundImage: CachedNetworkImageProvider(
    //  "https://picsum.photos/200/200?random=$index",
    //),
  );

  void clearCache() {
    DefaultCacheManager().emptyCache();

    imageCache.clear();
    imageCache.clearLiveImages();
    setState(() {});
  }
}

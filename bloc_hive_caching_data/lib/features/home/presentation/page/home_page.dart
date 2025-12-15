import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size size;
    double height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text('Caching Data With Bloc & Hive'),
            Text(
              '@Demo with BrickpointGames',
              style: theme.textTheme.labelMedium!.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
      body: SizedBox(height: height, width: width),
    );
  }
}

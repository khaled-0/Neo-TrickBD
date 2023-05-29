import 'package:flutter/material.dart';
import 'package:neo_trickbd/tabs/posts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Icon(Icons.wifi_rounded),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) => setState(() => tabIndex = value),
        currentIndex: tabIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.rss_feed_rounded),
            label: "Recent",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            label: "Search",
          )
        ],
      ),
      body: [
        const Posts(),
        const SizedBox(),
      ][tabIndex],
    );
  }
}

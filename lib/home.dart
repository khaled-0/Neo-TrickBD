import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neo_trickbd/tabs/posts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int tabIndex = 0;
  late PageController tabController;

  final tabs = [
    const Posts(),
    const SizedBox(),
  ];

  @override
  void initState() {
    super.initState();

    tabController = PageController(initialPage: tabIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Icon(Icons.wifi_rounded),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) => setState(() {
          tabIndex = value;
          tabController.jumpToPage(value);
        }),
        currentIndex: tabIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.list_bullet_below_rectangle),
            label: "Recent",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            label: "Search",
          )
        ],
      ),
      body: PageView(
        controller: tabController,
        children: tabs,
        onPageChanged: (value) => setState(() => tabIndex = value),
      ),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}

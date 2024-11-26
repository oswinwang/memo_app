// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:memorize/pages/learningpage1.dart';
import 'package:memorize/pages/setting1.dart';
import 'package:memorize/pages/object.dart';

class HomePage extends StatefulWidget {
  final String id;
  final String usewName;
  const HomePage(this.id, this.usewName, {Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _pages = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pages.add(LearningPage1(widget.id, widget.usewName));
    _pages.add(ObjectPage(widget.id));
    _pages.add(Setting1(widget.id, widget.usewName));
  }

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Memorize",
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              print('Info page');
            },
          )
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: SalomonBottomBar(
        backgroundColor: Colors.blueGrey,
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: const Icon(Icons.home, size: 30),
            title: const Text("Home"),
            selectedColor: Colors.white,
            unselectedColor: Colors.white60
          ),

          /// Package
          SalomonBottomBarItem(
            icon: const Icon(Icons.bakery_dining, size: 30),
            title: const Text("Package"),
            selectedColor: Colors.white,
            unselectedColor: Colors.white60
          ),

          /// Settings
          SalomonBottomBarItem(
            icon: const Icon(Icons.settings, size: 30),
            title: const Text("Settings"),
            selectedColor: Colors.white,
            unselectedColor: Colors.white60
          ),
        ],
      ),
    );
  }
}

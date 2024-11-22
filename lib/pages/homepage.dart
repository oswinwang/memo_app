// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:memorize/pages/learningpage1.dart';
import 'package:memorize/pages/setting1.dart';

class HomePage extends StatefulWidget {
  final String id;
  final String usewName;
  const HomePage(this.id, this.usewName, {Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List _pages = [];

  @override
  void initState() {
    super.initState();
    // 在此处通过 widget.id 来访问传递的 id
    _pages.add(LearningPage1(widget.id, widget.usewName)); // 将 id 传递给 LearningPage1
    _pages.add(Setting1(widget.id, widget.usewName));
  }

  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Memorize",
          style: TextStyle(
            color: Colors.white,
          )
          ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              print('Info page');
            },
        )],
      ),

      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueGrey, // 设置背景颜色
        selectedItemColor: Colors.white, // 选中图标和文字的颜色
        unselectedItemColor: Colors.grey[400], // 未选中图标和文字的颜色
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,  
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
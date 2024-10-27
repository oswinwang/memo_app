import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:memorize/pages/homepage.dart';

class Resultpage extends StatelessWidget {
  const Resultpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          '結果',
          style: TextStyle(
            color: Colors.white
          ),
          ),
        backgroundColor: Colors.blueGrey,
        automaticallyImplyLeading: false,
      ),

      body: const Center(
        child: Column(
          children: [
            Text('結果頁面'),
          ],
        ),

      ),
    );
  }
}
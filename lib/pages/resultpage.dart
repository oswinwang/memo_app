// ignore_for_file: prefer_const_constructors, unnecessary_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:memorize/pages/homepage.dart';
import 'package:memorize/style/elvatorbutonstyle.dart';

class Resultpage extends StatelessWidget {
  final String id;
  final String userName;

  const Resultpage({super.key, required this.id, required this.userName});

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

      body: Center(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '已完成今日複習',
                style: TextStyle(
                  fontSize: 30
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyles.elevatedButtonStyle(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage(id, userName)),
                  );
                },
                child: Text(
                  '回首頁',
                  style: TextStyle(
                    color: Colors.white
                  ),
                )
              ),
            ],
          ),
        )
      ),
    );
  }
}
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:memorize/pages/accountsettingpage.dart';
import 'package:memorize/pages/logginpage.dart';

class Setting1 extends StatelessWidget {
  const Setting1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 垂直居中
          crossAxisAlignment: CrossAxisAlignment.center, // 水平居中
          children: [
            Container(
            width: 170,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.blueGrey,
            ),
            child: TextButton(
                onPressed: () {
                  print('account setting');
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Accountsettingpage()),
                    );
                },
                child: Text(
                  '帳戶設定',
                  style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Container(
            width: 170,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.blueGrey,
            ),
            child: TextButton(
                onPressed: () {
                  print('log out');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: Text(
                  '登出',
                  style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
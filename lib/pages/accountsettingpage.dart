// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';

class Accountsettingpage extends StatelessWidget {
  const Accountsettingpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "帳戶設定",
          style: TextStyle(
            color: Colors.white,
          )
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),

      ),
      
    );
  }
}
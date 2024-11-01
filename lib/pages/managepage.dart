// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Managepage extends StatefulWidget {
  const Managepage({super.key});

  @override
  State<Managepage> createState() => _Managepage();
}

class _Managepage extends State<Managepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "測驗管理",
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
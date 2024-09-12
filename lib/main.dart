// ignore_for_file: prefer_const_constructors, unused_import, duplicate_ignore

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:memorize/pages/choosepage.dart';
import 'package:memorize/pages/homepage.dart';
import 'package:memorize/pages/learningpage1.dart';
import 'package:memorize/pages/setting1.dart';
import 'package:memorize/pages/society1.dart';
import 'package:provider/provider.dart';

import 'model/memoListSet.dart';

void main() {
  runApp(const MyApp());
}

// ignore_for_file: prefer_const_constructors

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Memolistset(),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      )
    );
  }
}

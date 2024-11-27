// ignore_for_file: prefer_const_constructors, unused_import, duplicate_ignore

import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:memorize/pages/choosepage.dart';
import 'package:memorize/pages/homepage.dart';
import 'package:memorize/pages/learningpage1.dart';
import 'package:memorize/pages/logginpage.dart';
import 'package:memorize/pages/object.dart';
import 'package:memorize/pages/setting1.dart';
import 'package:memorize/pages/spellingpage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'model/memoListSet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(Duration(seconds: 1));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Memolistset(),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage("1", "1")
        //HomePage("1", "1"),
        //SpellingPage(name: '', userid: '', username: '',),
        //LoginPage(),
        
      )
    );
  }
}

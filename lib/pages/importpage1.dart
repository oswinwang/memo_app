// ignore_for_file: prefer_const_constructors, avoid_print, use_super_parameters

import 'package:flutter/material.dart';
import 'package:memorize/pages/managesetpage.dart';
import 'package:memorize/pages/uploadpage.dart';

class Importpage extends StatefulWidget {
  final String id;
  const Importpage(this.id, {Key? key}) : super(key: key);

  @override
  State<Importpage> createState() => _ChoosePageState();
}

class _ChoosePageState extends State<Importpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "匯入及管理記憶集",
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                  print('上傳新記憶集');
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Uploadpage(widget.id),));
                },
                child: Text(
                  '上傳新記憶集',
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
                  print('查看現有記憶集');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Managesetpage(widget.id)),
                  );
                },
                child: Text(
                  '管理現有記憶集',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
          ),
        )
    );
  }
}
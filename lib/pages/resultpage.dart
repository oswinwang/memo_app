// ignore_for_file: prefer_const_constructors, unnecessary_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:memorize/pages/homepage.dart';
import 'package:memorize/style/elvatorbutonstyle.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Resultpage extends StatelessWidget {
  final String id;
  final String userName;

  const Resultpage({super.key, required this.id, required this.userName});

  void fetchData() async {
    final response = await http.post(
      Uri.parse('http://192.168.193.141:5000/API/CompleteTest/${id}'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'user_id': id,
      }),
    );
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print(jsonData["message"]);
    } else {
      throw Exception('Failed updated');
    }
  }

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
                  fetchData();
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
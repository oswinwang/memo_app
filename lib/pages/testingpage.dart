// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, avoid_print, unnecessary_import, unused_import, non_constant_identifier_names, camel_case_types

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:memorize/model/setname.dart';
import 'package:memorize/pages/homepage.dart';
import 'package:memorize/pages/resultpage.dart';
import 'package:memorize/style/elvatorbutonstyle.dart';

class Testingpage extends StatefulWidget {
  final String name;

  const Testingpage({super.key, required this.name});

  @override
  State<Testingpage> createState() => _TestingpageState();
}

class word {
  final String word1;
  final int id;

  word({required this.word1 , required this.id});
}

class _TestingpageState extends State<Testingpage> {
  List<word> wordList = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
    currentIndex = 0;
  }

  // Fetch data from API based on selected name
  // Fetch data from API based on selected name
  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://192.168.193.141:5000/API/choose/${widget.name}'));

    if (response.statusCode == 200) {
      setState(() {
        var jsonData = jsonDecode(response.body);
        for (var eachSet in jsonData) {
          print(eachSet["word"]);
          wordList.add(word(word1: eachSet["word"], id: eachSet["id"]));
        }
      });
    } else {
      throw Exception('Failed to load strings');
    }
  }

Future<void> PostData(int id, int score) async {
  final response = await http.post(
    Uri.parse('http://192.168.193.141:5000/API/choose/${widget.name}/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, int>{
      'score': score,
    }),
  );

  if (response.statusCode == 200) {
    setState(() {
      var jsonData = jsonDecode(response.body);
      print(jsonData["message"]);
    });
  } else {
    throw Exception('Failed to load strings');
  }
}

  void _nextString(int score) {
    setState(() {
      PostData(wordList[currentIndex].id,score);
      print(currentIndex);
      if (currentIndex == wordList.length - 1) {
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => Resultpage()),
        );
      }
      currentIndex = (currentIndex + 1) % wordList.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "Testing Page - ${widget.name}",  // 在標題顯示選擇的 name
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: wordList.isEmpty
          ? CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.blueGrey,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      wordList[currentIndex].word1,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                buildButtonRow([0, 1, 2]),
                SizedBox(height: 20),
                buildButtonRow([3, 4, 5]),
              ],
            ),
      ),
    );
  }

  // Custom button row builder
  Widget buildButtonRow(List<int> buttonLabels) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttonLabels.map((label) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ElevatedButton(
            onPressed: () => _nextString(label),
            style: ButtonStyles.elevatedButtonStyle(),
            child: Text(
              '$label',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        );
      }).toList(),
    );
  }
}


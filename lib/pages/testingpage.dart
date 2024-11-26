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
  final String id;
  final String username;

  const Testingpage({super.key, required this.name, required this.id, required this.username});

  @override
  State<Testingpage> createState() => _TestingpageState();
}

class word {
  final String word1;
  final int id;
  final String meaning;

  word({required this.word1 , required this.id, required this.meaning});
}

class _TestingpageState extends State<Testingpage> {
  List<word> wordList = [];
  int currentIndex = 0;
  bool _showMeaning = false;

  @override
  void initState() {
    super.initState();
    fetchData();
    currentIndex = 0;
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://192.168.193.141:5000/API/choose/${widget.name}'));

    if (response.statusCode == 200) {
      setState(() {
        var jsonData = jsonDecode(response.body);
        for (var eachSet in jsonData) {
          print(eachSet["word"]);
          wordList.add(word(word1: eachSet["word"], id: eachSet["id"], meaning: eachSet["meaning"]));
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
          MaterialPageRoute(builder: (context) => Resultpage(id:widget.id, userName: widget.username)),
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
          "Testing Page - ${widget.name}",
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
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showMeaning = !_showMeaning;
                    });
                  },
                  child: Padding(
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
                      child: Column(
                        children: [
                          Text(
                            _showMeaning
                              ? wordList[currentIndex].meaning
                              : wordList[currentIndex].word1,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          Text(
                            "點擊顯示意思",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
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


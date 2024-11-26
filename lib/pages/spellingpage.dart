// ignore_for_file: prefer_const_constructors, camel_case_types, avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SpellingPage extends StatefulWidget {
  final String name;
  final String userid;
  final String username;
  const SpellingPage({super.key, required this.name, required this.userid, required this.username});

  @override
  State<SpellingPage> createState() => _SpellingPageState();
}

class word {
  final String word1;
  final int id;
  final String meaning;

  word({required this.word1, required this.id, required this.meaning});
}

class _SpellingPageState extends State<SpellingPage> {
  final TextEditingController _spellingController = TextEditingController();
  List<word> wordList = [
    word(word1: 'apple', id: 1, meaning: '蘋果'),
    word(word1: 'banana', id: 2, meaning: '香蕉'),
    word(word1: 'cat', id: 3, meaning: '貓'),
  ];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    //串接時開啟
    //fetchData();
    currentIndex = 0;
  }

  //串接時嘗試
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

  void _nextWord() {
    //串接時嘗試
    //postData(wordList[currentIndex].id, 0);
    setState(() {
      if (currentIndex < wordList.length - 1) {
        currentIndex++;
      } else {
        currentIndex = 0;
      }
      _spellingController.clear();
    });
  }

  //串接時嘗試
  Future<void> postData(int id, int score) async {
    final response = await http.post(
      Uri.parse('http://192.168.193.141:5000/API/enter_word/${widget.name}/$id'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text(
          'Spelling Test',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blueGrey,
                  border: Border.all(
                    color: Colors.white, // 邊框顏色
                    width: 1.0, // 邊框寬度
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  wordList[currentIndex].meaning,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36.0),
              child: TextField(
                controller: _spellingController,
                decoration: const InputDecoration(
                  labelText: '請輸入單字',
                  labelStyle: TextStyle(color: Colors.blueGrey),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _nextWord();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
              ),
              child: const Text(
                '下一題',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

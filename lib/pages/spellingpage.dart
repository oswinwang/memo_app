// ignore_for_file: prefer_const_constructors, camel_case_types, avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'resultpage.dart';

class SpellingPage extends StatefulWidget {
  final String name;
  final String userid;
  final String username;
  const SpellingPage({super.key, required this.name, required this.userid, required this.username});

  @override
  State<SpellingPage> createState() => _SpellingPageState();
}

class Word {
  final String word1;
  final int id;
  final String meaning;

  Word({required this.word1, required this.id, required this.meaning});
}

class _SpellingPageState extends State<SpellingPage> {
  final TextEditingController _spellingController = TextEditingController();
  List<Word> wordList = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://192.168.193.141:5000/API/choose/${widget.name}'));
    if (response.statusCode == 200) {
      setState(() {
        var jsonData = jsonDecode(response.body);
        wordList = jsonData.map<Word>((item) => Word(
          word1: item["word"],
          id: item["id"],
          meaning: item["meaning"],
        )).toList();
        currentIndex = 0;
      });
    } else {
      throw Exception('Failed to load words');
    }
  }

  void _nextWord() {
    if (wordList.isNotEmpty) {
      postData(wordList[currentIndex].id, _spellingController.text);
      setState(() {
        if (currentIndex < wordList.length - 1) {
          currentIndex++;
        } else {
          Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => Resultpage(id:widget.userid, userName: widget.username)),
        );
        }
        _spellingController.clear();
      });
    }
  }

  Future<void> postData(int id, String enterword) async {
    final response = await http.post(
      Uri.parse('http://192.168.193.141:5000/API/EnterWord/$enterword/$id/${widget.userid}'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, int>{
        
      }),
    );

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print(jsonData["message"]);
    } else {
      throw Exception('Failed to post score');
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
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: wordList.isEmpty
            ? const CircularProgressIndicator()
            : Column(
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
                          color: Colors.white,
                          width: 1.0,
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
                        wordList[currentIndex].meaning, // 顯示當前單字的中文意思
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
                    onPressed: _nextWord,
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


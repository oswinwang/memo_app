// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, avoid_print, unnecessary_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:memorize/model/setname.dart';

class Testingpage extends StatefulWidget {
  const Testingpage({super.key});

  @override
  State<Testingpage> createState() => _TestingpageState();
}

class _TestingpageState extends State<Testingpage> {
  final String memo = "apple";
  final String explain = "蘋果";
  List<String> stringArray = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Fetch data from API
  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://10.242.184.203:5000'));

    if (response.statusCode == 200) {
      setState(() {
        var jsondata = jsonDecode(response.body);
        for (var eachset in jsondata) {
          final setname = Setname(name: eachset['name']);
          stringArray.add(setname.name);
        }
      });
    } else {
      throw Exception('Failed to load strings');
    }
  }

  void _nextString() {
    setState(() {
      currentIndex = (currentIndex + 1) % stringArray.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "testingpage",
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
        child: stringArray.isEmpty
        ? CircularProgressIndicator()
        :Column(
          mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    stringArray[currentIndex],  // Display current string
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _nextString,
                    child: Text('Next String'),
                  ),
                ],
              ),
        )
      );
  }
}
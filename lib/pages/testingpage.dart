// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, avoid_print, unnecessary_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:memorize/model/setname.dart';
import 'package:memorize/pages/homepage.dart';

class Testingpage extends StatefulWidget {
  const Testingpage({super.key});

  @override
  State<Testingpage> createState() => _TestingpageState();
}

class _TestingpageState extends State<Testingpage> {
  List<String> stringArray = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
    currentIndex = 0;
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
      print(currentIndex);
      if(currentIndex == stringArray.length - 1) {
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => HomePage(),)
        );
      }
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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: EdgeInsets.all(50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueGrey,
                      ),
                      child: Text(
                        stringArray[currentIndex],  // Display current string
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _nextString,
                        child: Text('0'),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: _nextString,
                        child: Text('1'),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: _nextString,
                        child: Text('2'),
                      ),
                    ]
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _nextString,
                        child: Text('3'),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: _nextString,
                        child: Text('4'),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: _nextString,
                        child: Text('5'),
                      ),
                    ]
                  )
                ],
              ),
        )
      );
  }
}
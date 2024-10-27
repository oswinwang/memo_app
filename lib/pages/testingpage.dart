// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, avoid_print, unnecessary_import

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:memorize/model/setname.dart';
import 'package:memorize/pages/homepage.dart';
import 'package:memorize/pages/resultpage.dart';
import 'package:memorize/style/elvatorbutonstyle.dart';

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
          MaterialPageRoute(builder: (context) => Resultpage(),)
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
          "Testing Page",
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
                      stringArray[currentIndex],
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
            onPressed: _nextString,
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

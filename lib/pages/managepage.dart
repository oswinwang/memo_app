// ignore_for_file: prefer_const_constructors, avoid_print, sort_child_properties_last, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Managepage extends StatefulWidget {
  final String id;
  const Managepage({super.key, required this.id});

  @override
  State<Managepage> createState() => _Managepage();
}

class _Managepage extends State<Managepage> {
  List<Map<String, dynamic>> itemList = [];

  /// Fetch data from API
  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('http://192.168.193.141:5000/API/ALL_Record/${widget.id}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        var jsonData = jsonDecode(response.body);
        itemList = jsonData.map<Map<String, dynamic>>((item) {
          return {
            'date': item['date'],
            'records': item['records'],
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "測驗管理",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: itemList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: itemList.length,
              itemBuilder: (context, index) {
                final item = itemList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ExpansionTile(
                    title: Text(
                      item['date'],
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    children: (item['records'] as List<dynamic>).map((record) {
                      return ListTile(
                        title: Text(
                          record[1].toString(),
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "上次選擇精熟度 : " + record[0].toString(),
                          style: TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
    );
  }
}

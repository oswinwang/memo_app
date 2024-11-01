// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Map<String, dynamic>> itemList = [];
  bool isAscending = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // 从 API 获取数据
  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://10.242.184.203:5000'));

    if (response.statusCode == 200) {
      setState(() {
        var jsondata = jsonDecode(response.body);
        itemList = jsondata.map<Map<String, dynamic>>((item) => {
              'name': item['name'].toString(),
              'EF': item['EF'],
            }).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  // 按条件排序
  void _sortList(String sortType) {
    setState(() {
      if (sortType == 'Ascending') {
        itemList.sort((a, b) => a['name'].compareTo(b['name']));
      } else if (sortType == 'Descending') {
        itemList.sort((a, b) => b['name'].compareTo(a['name']));
      } else if (sortType == 'ProficiencyDescending') {
        itemList.sort((a, b) => b['EF'].compareTo(a['EF']));
      } else if (sortType == 'ProficiencyAscending') {
        itemList.sort((a, b) => a['EF'].compareTo(b['EF']));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(
          "記憶集列表",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.sort), // 自訂排序圖標
            onPressed: () {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(1000, 80, 0, 0),
                items: [
                  PopupMenuItem(
                    value: 'Ascending',
                    child: Text('按首字母排序'),
                  ),
                  PopupMenuItem(
                    value: 'Descending',
                    child: Text('按倒序排列'),
                  ),
                  PopupMenuItem(
                    value: 'ProficiencyDescending',
                    child: Text('按精熟度降序'),
                  ),
                  PopupMenuItem(
                    value: 'ProficiencyAscending',
                    child: Text('按精熟度升序'),
                  ),
                ],
              ).then((value) {
                if (value != null) _sortList(value);
              });
            },
          ),
        ],
      ),
      body: Center(
        child: itemList.isEmpty
            ? Center(
              child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: itemList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(itemList[index]['name']),
                    subtitle: Text(
                      '精熟度: ${itemList[index]['EF'].toStringAsFixed(2)}',
                    ),
                  );
                },
              ),
      ),
    );
  }
}


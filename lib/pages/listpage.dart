// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, avoid_print, sort_child_properties_last, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListPage extends StatefulWidget {
  final String momolistname;
  final String id;
  const ListPage({Key? key, required this.momolistname, required this.id}) : super(key: key);

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
    final response = await http.get(
      Uri.parse('http://192.168.193.141:5000/API/choose/${widget.momolistname}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        var jsondata = jsonDecode(response.body);
        itemList = jsondata.map<Map<String, dynamic>>((item) => {
              'id': item['id'],
              'word': item['word'],
            }).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> deleteWord(int id, int index) async {
    final response = await http.delete(
      Uri.parse('http://192.168.193.141:5000/API/Delete/${widget.momolistname}/$id'),
    );

    if (response.statusCode == 200) {
      setState(() {
        itemList.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('刪除成功')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('刪除失敗')),
      );
    }
  }

  // 删除整个记忆集
  Future<void> deleteEntireCollection() async {
    final response = await http.delete(
      Uri.parse('http://192.168.193.141:5000/API/Delete/${widget.momolistname}'),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('記憶集刪除成功')),
      );
      Navigator.of(context).pop(); // 返回上一页
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('記憶集刪除失敗')),
      );
    }
  }

  // 按条件排序
  void _sortList(String sortType) {
    setState(() {
      if (sortType == 'Ascending') {
        itemList.sort((a, b) => a['word'].compareTo(b['word']));
      } else if (sortType == 'Descending') {
        itemList.sort((a, b) => b['word'].compareTo(a['word']));
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
            icon: Icon(Icons.more_vert_rounded),
            onPressed: () {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(1000, 80, 0, 0),
                items: [
                  PopupMenuItem(
                    value: 'Ascending',
                    child: Text('按字母升序排列'),
                  ),
                  PopupMenuItem(
                    value: 'Descending',
                    child: Text('按字母降序排列'),
                  ),
                  PopupMenuItem(
                    value: 'DeleteAll',
                    child: Text('刪除整個記憶集'),
                  ),
                ],
              ).then((value) {
                if (value == 'Ascending' || value == 'Descending') {
                  _sortList(value ?? '');
                } else if (value == 'DeleteAll') {
                  // 删除整个记忆集确认对话框
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("確認刪除"),
                      content: Text("確定要刪除整個記憶集嗎？此操作不可恢復！"),
                      actions: [
                        TextButton(
                          child: Text("取消"),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        TextButton(
                          child: Text("確定"),
                          onPressed: () {
                            Navigator.of(context).pop();
                            deleteEntireCollection();
                          },
                        ),
                      ],
                    ),
                  );
                }
              });
            },
          ),
        ],
      ),
      body: Center(
        child: itemList.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: itemList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(itemList[index]['word']),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteWord(itemList[index]['id'], index),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("新增單字");
          // 在这里可以添加新的单词或执行其他功能
          // 可以通过弹出对话框来输入新单词
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }
}

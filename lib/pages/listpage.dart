// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, avoid_print, sort_child_properties_last, use_build_context_synchronously, unused_element, prefer_const_literals_to_create_immutables, non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';


class ListPage extends StatefulWidget {
  final String momolistname;
  final String userId;
  const ListPage({Key? key, required this.momolistname, required this.userId}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Map<String, dynamic>> itemList = [];
  bool isAscending = true;
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _meaningController = TextEditingController();


  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('http://192.168.193.141:5000/API/showWords/${widget.momolistname}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        var jsondata = jsonDecode(response.body);
        itemList = jsondata.map<Map<String, dynamic>>((item) => {
              'id': item['id'],
              'word': item['word'],
              'meaning': item['meaning'],
              'review_date': item['review'],
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

  Future<void> deleteEntireCollection() async {
    final response = await http.delete(
      Uri.parse('http://192.168.193.141:5000/API/Delete/${widget.momolistname}'),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('記憶集刪除成功')),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('記憶集刪除失敗')),
      );
    }
  }

  void _sortList(String sortType) {
    setState(() {
      if (sortType == 'Ascending') {
        itemList.sort((a, b) => a['word'].compareTo(b['word']));
      } else if (sortType == 'Descending') {
        itemList.sort((a, b) => b['word'].compareTo(a['word']));
      }
    });
  }

  void _new_word(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('新增單字'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _wordController,
                  decoration: InputDecoration(
                    labelText: '輸入單字',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _meaningController,
                  decoration: InputDecoration(
                    labelText: '輸入解釋',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('確定'),
              onPressed: () {
                String word = _wordController.text.trim();
                String meaning = _meaningController.text.trim();
                if (word.isNotEmpty && meaning.isNotEmpty) {
                  _postNewWord(word, meaning);
                  Navigator.of(context).pop();  // 關閉對話框
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('請輸入單字及解釋！')),
                  );
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _postNewWord(String word, String meaning) async {
    final url = Uri.parse('http://192.168.193.141:5000/API/New/${widget.momolistname}');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'meaning': meaning,
        'word': word,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('新增單字成功')),
      );
      fetchData();  // 成功後重新載入列表
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('新增單字失敗')),
      );
    }
  }

  void _editWord(BuildContext context, String word, String meaning, int id) {
    _wordController.text = word;
    _meaningController.text = meaning;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('編輯單字'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _wordController,
                  decoration: InputDecoration(
                    labelText: '輸入單字',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _meaningController,
                  decoration: InputDecoration(
                    labelText: '輸入解釋',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('確定'),
              onPressed: () {
                String word = _wordController.text.trim();
                String meaning = _meaningController.text.trim();
                if (word.isNotEmpty && meaning.isNotEmpty) {
                  _updateWord(word, meaning, id);
                  Navigator.of(context).pop();  // 關閉對話框
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('請輸入單字及解釋！')),
                  );
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateWord(String word, String meaning, int id) async {
    final url = Uri.parse('http://192.168.193.141:5000/API/UpdateWord/${widget.momolistname}/$id');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'meaning': meaning,
        'name': word,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('編輯單字成功')),
      );
      fetchData();  // 成功後重新載入列表
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('新增單字失敗')),
      );
    }
  }

    Future<List<Map<String, dynamic>>> fetchGraphData(int id) async {
    final response = await http.get(
      Uri.parse('http://192.168.193.141:5000/API/Record/$id'),
    );

    if (response.statusCode == 200) {
      List jsonData = jsonDecode(response.body);
      return jsonData.map<Map<String, dynamic>>((item) {
        return {
          "date": DateTime.parse(item['date']), // 解析日期
          "difficulty": item['difficulty'],
        };
      }).toList();
    } else {
      throw Exception('Failed to fetch graph data');
    }
  }


  void showGraphDialog(int id) async {
    try {
      final graphData = await fetchGraphData(id);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Difficulty Over Time"),
          content: Container(
            width: 300,
            height: 200,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: graphData
                        .map((data) => FlSpot(
                            data['date'].millisecondsSinceEpoch.toDouble(),
                            data['difficulty'].toDouble()))
                        .toList(),
                    isCurved: false,
                    barWidth: 2,
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                        return Text(
                          "${date.month}/${date.day}",
                          style: TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, _) {
                        return Text(
                          "${value.toInt()}",
                          style: TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: true),
                gridData: FlGridData(show: false),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Close"),
            ),
          ],
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $error')),
      );
    }
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
                title: Text(itemList[index]['word'] + " - " + itemList[index]['meaning']),
                subtitle: Text("複習時間：" + itemList[index]['review_date']),                  
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.history, color: Colors.blue),
                      onPressed: () {
                        print("object");
                        showGraphDialog(itemList[index]['id']);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteWord(itemList[index]['id'], index),
                    ),
                  ],
                ),
                onTap: () => _editWord(context, itemList[index]['word'], itemList[index]['meaning'], itemList[index]['id']),
              );
            },
          ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _new_word(context);
          print("新增單字");
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          ),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }
}

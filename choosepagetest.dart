import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:memorize/components/memotile.dart';
import 'package:memorize/model/memoListSet.dart';
import 'package:memorize/pages/testingpage.dart';
import 'package:memorize/model/memolist.dart';
import 'package:provider/provider.dart';

class ChoosePage extends StatefulWidget {
  const ChoosePage({super.key});

  @override
  State<ChoosePage> createState() => _ChoosePageState();
}

class _ChoosePageState extends State<ChoosePage> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // 串接API並將資料賦予給memolist
  Future<void> fetchData() async {
    final url = 'https://www.travel.taipei/open-api/zh-tw/Attractions/All?page=1';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // 獲取API回傳的name並賦值給memolist
        final List<dynamic> attractions = data['data'];
        final memolist = Provider.of<Memolistset>(context, listen: false);

        memolist.Memolist_1.clear(); // 清除原有列表，更新資料
        for (var attraction in attractions) {
          memolist.Memolist_1.add(MemoList(listname: attraction['name']) as Memolist);
        }

        setState(() {}); // 更新UI
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "選擇記憶集",
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
      body: Consumer<Memolistset>(
        builder: (context, memolist, child) => Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: memolist.Memolist_1.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Testingpage(),
                      ),
                    ),
                    child: Memotile(
                      momolistname: memolist.Memolist_1[index].listname,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MemoList {
  String listname;
  MemoList({required this.listname});
}


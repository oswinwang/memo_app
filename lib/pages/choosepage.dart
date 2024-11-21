// ignore_for_file: prefer_const_constructors, unused_import, avoid_print, must_be_immutable, use_super_parameters

import 'package:flutter/material.dart';
import 'package:memorize/components/memotile.dart';
import 'package:memorize/model/memoListSet.dart';
import 'package:memorize/pages/testingpage.dart';
import 'package:provider/provider.dart';
import 'package:memorize/model/setname.dart';
import 'package:memorize/services/api_service.dart'; // 引入新檔案
import 'package:http/http.dart' as http;

class ChoosePage extends StatelessWidget {
  final String username;
  final String userId;
  ChoosePage(this.userId, this.username, {Key? key}) : super(key: key);
  List<Setname> setnames = [];

  Future<void> getsetname() async {
  setnames = await ApiService.getSetNames(userId);
  }

  Future<void> fetchData(String setname, BuildContext context) async {
    final response = await http.get(
      Uri.parse('http://192.168.193.141:5000/API/choose/${setname}'),
    );

    if (response.statusCode == 404) {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '此記憶集今日無需複習',
          style: TextStyle(color: Colors.white),
          ), // 訊息文字
        duration: Duration(seconds: 2), // 持續時間
        backgroundColor: Colors.blueGrey[400], // 訊息背景顏色
      ),
    );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Testingpage(name: setname, id: userId, username: username),  // 傳遞 name
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "選擇記憶集",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder(
        future: getsetname(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: setnames.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Memotile(
                    momolistname: setnames[index].name,
                  ),
                  onTap: () {
                    String selectedName = setnames[index].name;
                    print(selectedName);
                    fetchData(selectedName, context);
                  },
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

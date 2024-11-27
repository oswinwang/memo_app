// ignore_for_file: prefer_const_constructors, unused_import, avoid_print, must_be_immutable, use_super_parameters, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:memorize/components/memotile.dart';
import 'package:memorize/model/memoListSet.dart';
import 'package:memorize/pages/testingpage.dart';
import 'package:provider/provider.dart';
import 'package:memorize/model/setname.dart';
import 'package:memorize/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:memorize/pages/spellingpage.dart';

class ChoosePage extends StatelessWidget {
  final String username;
  final String userId;
  ChoosePage(this.userId, this.username, {Key? key}) : super(key: key);
  List<Setname> setnames = [];

  Future<void> getsetname() async {
    setnames = await ApiService.getSetNames(userId);
  }

  Future<void> fetchData(String setname, BuildContext context, String examType) async {
    final response = await http.get(
      Uri.parse('http://192.168.193.141:5000/API/choose/$setname'),
    );

    if (response.statusCode == 404) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '此記憶集今日無需複習',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blueGrey[400],
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => examType == "point"
              ? Testingpage(name: setname, id: userId, username: username)
              : SpellingPage(name: setname, userid: userId, username: username),
        ),
      );
    }
  }

  void _showExamTypeDialog(BuildContext context, String setname) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("選擇考試類型"),
        content: Text("請選擇您要進行的考試類型："),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              fetchData(setname, context, "point");
            },
            child: const Text("Point"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              fetchData(setname, context, "spelling");
            },
            child: const Text("Spelling"),
          ),
        ],
      ),
    );
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
                    _showExamTypeDialog(context, selectedName);
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


// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Accountsettingpage extends StatelessWidget {
  final String id;
  final String userName;
  const Accountsettingpage(this.id, this.userName,{super.key});

  void _changepassword(BuildContext context) {
    final TextEditingController _wordController = TextEditingController();
    final TextEditingController _meaningController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('修改密碼'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _wordController,
                  decoration: InputDecoration(
                    labelText: '輸入舊密碼',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _meaningController,
                  decoration: InputDecoration(
                    labelText: '輸入新密碼',
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
                String oldpass = _wordController.text.trim();
                String newpass = _meaningController.text.trim();
                if (oldpass.isNotEmpty && newpass.isNotEmpty) {
                  _updatepassword(oldpass, newpass, int.parse(id), context);
                  Navigator.of(context).pop();  // 關閉對話框
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('請輸入舊密碼和新密碼')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updatepassword(String oldpass, String newpass, int id, BuildContext context) async {
    final url = Uri.parse('http://192.168.193.141:5000/API/UpdatePassword/$id');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'oldPassword': oldpass,
        'newPassword': newpass,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('變更成功')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('變更失敗')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "帳戶設定",
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Uername : " + userName,
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _changepassword(context);
              }, 
              child: Text("更改密碼"),
            )
          ],
        ),
      ),
    );
  }
}
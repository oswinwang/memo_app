// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, library_private_types_in_public_api, annotate_overrides, avoid_print, sort_child_properties_last
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:memorize/pages/homepage.dart';
import 'package:memorize/pages/registerpage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    postData();
    // 先印出提示，這行會在登入按鈕被按下時執行
    print('Login pressed');
  }


    Future<void> postData() async {
    Map<String, dynamic> jsonData = {
      "account": _usernameController.text,
      "password": _passwordController.text,
    };

    final response = await http.post(
      Uri.parse('http://192.168.193.141:5000/API/Login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(jsonData),
    );

    if (response.statusCode == 201) {
      setState(() {
        var responseData = jsonDecode(response.body);
        if (responseData["message"] == "Login successfully") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(responseData["ID"].toString(), _usernameController.text),
            ),
          );
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('登入失敗:('), // 訊息文字
          duration: Duration(seconds: 2), // 持續時間
          backgroundColor: Colors.blueGrey[400], // 訊息背景顏色
        ),
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(
          'Login',
          style: TextStyle(color: Colors.white),),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: Colors.blueGrey),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey),
                ),
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.blueGrey),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text(
                'Register',
                style: TextStyle(color: Colors.blueGrey),),
            ),
          ],
        ),
      ),
    );
  }
}
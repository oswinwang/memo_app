// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, library_private_types_in_public_api, annotate_overrides, avoid_print, sort_child_properties_last

import 'package:flutter/material.dart';
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
    // 先印出提示，這行會在登入按鈕被按下時執行
    print('Login pressed');
    
    // 顯示登入成功的 Snackbar 訊息
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('登入成功'), // 訊息文字
        duration: Duration(seconds: 2), // 持續時間
        backgroundColor: Colors.blueGrey[400], // 訊息背景顏色
      ),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
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
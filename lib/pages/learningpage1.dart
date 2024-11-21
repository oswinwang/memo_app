// ignore_for_file: unused_import, prefer_const_constructors, avoid_print, use_super_parameters
import 'package:flutter/material.dart';
import 'package:memorize/pages/choosepage.dart';
import 'package:memorize/pages/importpage1.dart';
import 'package:memorize/pages/listpage.dart';
import 'package:memorize/pages/managepage.dart';

class LearningPage1 extends StatelessWidget {
  final String id;
  final String username;
  const LearningPage1(this.id, this.username, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 垂直居中
            crossAxisAlignment: CrossAxisAlignment.center, // 水平居中
            children: [
              Container(
                width: 170,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.blueGrey,
                ),
                child: TextButton(
                  onPressed: () {
                    print('choose');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChoosePage(id, username)),
                    );
                  },
                  child: Text(
                    '測驗',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      ),
                  ),
                ),
              ),
              SizedBox(height: 40), // 添加按钮之间的间距
              Container(
                width: 170,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.blueGrey,
                ),
                child: TextButton(
                  onPressed: () {
                    print('import');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Importpage(id)),
                    );
                  },
                  child: Text(
                    '新增、管理記憶集',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      ),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
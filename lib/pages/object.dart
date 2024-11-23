// ignore_for_file: unused_import, prefer_const_constructors, avoid_print, use_super_parameters, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:memorize/pages/mypackage.dart';
import 'package:memorize/pages/shoplistview.dart';

class ObjectPage extends StatefulWidget {
  final String userId;
  const ObjectPage(this.userId, {Key? key}) : super(key: key);

  @override
  State<ObjectPage> createState() => _ObjectPageState();
}

class _ObjectPageState extends State<ObjectPage> {
  int _currentPage = 0;
  int _coins = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          Center(
            child: _currentPage == 0
                ? const Mypackagepage()
                : const ShopListView(),
          ),
          Positioned(
            top: 10,
            right: 15,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.yellow[600],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
                border: Border.all(
                  color: Colors.yellow[700]!, // 邊框顏色
                  width: 3.0, // 邊框寬度
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.attach_money, color: Colors.white),
                  Text(
                    '$_coins',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(width: 2),
                  ToggleButtons(
                    borderColor: Colors.transparent,
                    fillColor: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    selectedBorderColor: Colors.transparent,
                    selectedColor: Colors.blueGrey,
                    color: Colors.white,
                    constraints: BoxConstraints(minHeight: 40, minWidth: 70),
                    isSelected: [_currentPage == 0, _currentPage == 1],
                    onPressed: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    children: [
                      Text(
                        "我的物品",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "商店",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

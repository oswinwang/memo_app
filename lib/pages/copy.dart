// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:memorize/components/memotile.dart';
import 'package:memorize/model/memoListSet.dart';
import 'package:memorize/pages/testingpage.dart';
import 'package:provider/provider.dart';

class ChoosePage1 extends StatefulWidget {
  const ChoosePage1({super.key});

  @override
  State<ChoosePage1> createState() => _ChoosePageState();
}

class _ChoosePageState extends State<ChoosePage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "選擇記憶集",
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
      body: Consumer<Memolistset>(
        builder: (context, memolist, child) => Column(children: [
          Expanded(
            child: ListView.builder(
              itemCount: memolist.Memolist_1.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => Testingpage(),)
                    ),
                  child: Memotile(
                    momolistname: memolist.Memolist_1[index].listname,
                    
                  ),
                );
              },
            ),
          ),
        ],)
      ),
    );
  }
}
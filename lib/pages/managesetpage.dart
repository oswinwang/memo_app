// ignore_for_file: prefer_const_constructors, must_be_immutable, unused_import, avoid_print

import 'package:flutter/material.dart';
import 'package:memorize/components/memotile.dart';
import 'package:memorize/model/memoListSet.dart';
import 'package:memorize/model/setname.dart';
import 'package:memorize/pages/listpage.dart';
import 'package:memorize/services/api_service.dart';
import 'package:provider/provider.dart';

class Managesetpage extends StatelessWidget {
  final String id;
  Managesetpage(this.id, {Key? key}) : super(key: key);

  List<Setname> setnames = [];

  Future getsetname() async {
    setnames = await ApiService.getSetNames(id); // 呼叫 ApiService 中的函數
    print(setnames.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          '管理現有記憶集',
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
      body: FutureBuilder(
        future: getsetname(), 
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: setnames.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Memotile(
                    momolistname: setnames[index].name,
                  ),
                  onTap: (){
                    print(setnames[index].name);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListPage(momolistname: setnames[index].name ,id:id),
                      )
                    );
                  }
                );
              }
            );
          }else{
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
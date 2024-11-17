// ignore_for_file: prefer_const_constructors, unused_import, avoid_print, must_be_immutable, use_super_parameters

import 'package:flutter/material.dart';
import 'package:memorize/components/memotile.dart';
import 'package:memorize/model/memoListSet.dart';
import 'package:memorize/pages/testingpage.dart';
import 'package:provider/provider.dart';
import 'package:memorize/model/setname.dart';
import 'package:memorize/services/api_service.dart'; // 引入新檔案

class ChoosePage extends StatelessWidget {
  final String id;
  ChoosePage(this.id, {Key? key}) : super(key: key);
  List<Setname> setnames = [];

  Future<void> getsetname() async {
  setnames = await ApiService.getSetNames(id);
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Testingpage(name: selectedName),  // 傳遞 name
                      ),
                    );
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

// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:file_picker/file_picker.dart'; // 引入文件選擇包
import 'package:flutter/material.dart';
import 'package:memorize/model/setname.dart';
import 'package:memorize/services/api_service.dart';

class Uploadtonow extends StatefulWidget {
  const Uploadtonow({super.key});

  @override
  State<Uploadtonow> createState() => _UploadtonowState();
}

class _UploadtonowState extends State<Uploadtonow> {
  String selectedItem = '尚未選擇'; // 保存選擇的項目
  String selectedFilePath = ''; // 保存選擇的文件路徑

  List<Setname> setnames = [];

  Future getsetname() async {
    setnames = await ApiService.getSetNames("0"); // 呼叫 ApiService 中的函數
    print(setnames.length);
  }

  // 彈出對話框的方法
  void showListDialog(BuildContext context) {
    getsetname();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder(
          future: getsetname(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done) {
              return AlertDialog(
                title: Text('選擇一項'),
                content: Container(
                  width: double.maxFinite,
                  height: 400,
                  child: ListView.builder(
                    itemCount: setnames.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(setnames[index].name),
                        onTap: () {
                          // 當點擊項目時，保存選擇的項目
                          setState(() {
                          selectedItem = setnames[index].name;
                          });
                          Navigator.of(context).pop(); // 關閉對話框
                        },
                      );
                    },
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('取消'),
                    onPressed: () {
                      Navigator.of(context).pop(); // 關閉對話框
                    },
                  ),
                ],
              );
            }else{
              return Center(child: CircularProgressIndicator());
              }
          }
        );
      },
    );
  }

  // 選擇文件的方法
  Future<void> pickExcelFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'], // 僅允許Excel文件
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedFilePath = result.files.single.path ?? '未選擇文件';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(
          "上傳至現有記憶集",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                showListDialog(context); // 顯示對話框
              },
              child: Text('選擇已有記憶集'),
            ),
            SizedBox(height: 20),
            // 顯示所選的項目
            Text(
              '選擇的記憶集: $selectedItem',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                pickExcelFile(); // 選擇Excel文件
              },
              child: Text('上傳Excel文件'),
            ),
            SizedBox(height: 20),
            // 顯示選擇的文件路徑
            Text(
              selectedFilePath.isEmpty ? '尚未選擇文件' : '選擇的文件路徑: $selectedFilePath',
              style: TextStyle(fontSize: 18),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 20), // 再次增加距離
            if (selectedFilePath.isNotEmpty && selectedItem != '尚未選擇')
              ElevatedButton(
                onPressed: _uploadFile,
                child: Text('上傳檔案'),
              ),
          ],
        ),
      ),
    );
  }

  void _uploadFile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('上傳檔案'),),
    );
    Navigator.pop(context);
  }
}

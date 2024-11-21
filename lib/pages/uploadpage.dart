// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, prefer_final_fields, use_super_parameters, avoid_print, non_constant_identifier_names, sort_child_properties_last, sized_box_for_whitespace

import 'dart:io';
import 'dart:convert'; // 用於 JSON 編碼
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:http/http.dart' as http;


class Uploadpage extends StatefulWidget {
  final String id;
  const Uploadpage(this.id, {Key? key}) : super(key: key);

  @override
  _UploadpageState createState() => _UploadpageState();
}

class _UploadpageState extends State<Uploadpage> {
  String? _fileName; // 用於存儲檔案名稱
  String? _filePath; // 用於存儲檔案路徑
  TextEditingController _textController = TextEditingController(); // TextField 控制器

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'], // 允許的檔案類型
    );

    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
        _filePath = result.files.single.path; // 取得檔案路徑
      });

    } else {
      setState(() {
        _fileName = null;
        _filePath = null;
      });
    }
  }

  Future<void> _readAndPrintExcel(File file) async {
    // 讀取 Excel 檔案
    var bytes = file.readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    // 定義 JSON 結構
    Map<String, dynamic> jsonData = {
      "id": widget.id,
      "name": _textController.text,
      "words": []
    };

    // 假設資料在第一個 sheet 中
    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table]!.rows) {
        if (row[0] != null && row[1] != null) {
          // 將每行的數據加入 JSON
          jsonData["words"].add({
            "word": row[0]!.value.toString(),
            "meaning": row[1]!.value.toString()
          });
        }
      }
      break; // 僅讀取第一個 sheet
    }
    PostData(jsonData);
    // 打印 JSON 結果
    print(jsonEncode(jsonData));
  }

  Future<void> PostData(Map<String, dynamic> jsonData) async {
    final response = await http.post(
      Uri.parse('http://192.168.193.141:5000/API/New'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(jsonData), 
    );

    if (response.statusCode == 201) {
      setState(() {
        var responseData = jsonDecode(response.body);
        print(responseData["message"]);
      });
    } else {
        setState(() {
        var responseData = jsonDecode(response.body);
        print(responseData["message"]);
      });    }
  }

  void  _uploadFile() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('上傳檔案: $_fileName')),
    );
    Navigator.pop(context);

      // 解析並打印 Excel 文件內容
      if (_filePath != null) {
        await _readAndPrintExcel(File(_filePath!));
      }


    _textController.clear();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          '上傳新記憶集',
          style: TextStyle(
            color: Colors.white,
          ),
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
            ElevatedButton(
              onPressed: _pickFile,
              child: Text(
                '選擇 Excel 檔案',
                style: TextStyle(color: Colors.white),
                ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[500],
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '記憶集名稱',
                  labelStyle: TextStyle(color: Colors.blueGrey),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            if (_fileName != null)
              Column(
                children: [
                  Text(
                    '選擇的檔案: $_fileName',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '檔案路徑: $_filePath',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _uploadFile,
                    child: Text('上傳檔案'),
                  ),
                ],
              )
            else
              Text(
                '未選擇檔案',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}








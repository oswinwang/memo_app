// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class Uploadpage extends StatefulWidget {
  const Uploadpage({super.key});

  @override
  _UploadpageState createState() => _UploadpageState();
}

class _UploadpageState extends State<Uploadpage> {
  String? _fileName; // 用於存儲檔案名稱
  String? _filePath; // 用於存儲檔案路徑
  TextEditingController _textController = TextEditingController(); // TextField 控制器

  Future<void> _pickFile() async {
    // 使用 FilePicker 選擇 Excel 檔案
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'], // 允許的檔案類型
    );

    if (result != null) {
      // 檔案選擇成功，更新檔案名稱和路徑
      setState(() {
        _fileName = result.files.single.name;
        _filePath = result.files.single.path; // 取得檔案路徑
      });
    } else {
      // 使用者取消選擇檔案
      setState(() {
        _fileName = null;
        _filePath = null;
      });
    }
  }

  void _uploadFile() {
    // 在這裡處理檔案上傳邏輯
    // 例如，可以將檔案上傳到伺服器
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('上傳檔案: $_fileName')),
    );
    Navigator.pop(context);

    // 清空 TextField
    _textController.clear();
  }

  @override
  void dispose() {
    // 銷毀 TextEditingController 以釋放資源
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
              child: Text('選擇 Excel 檔案'),
            ),
            SizedBox(height: 20), // 增加一點距離
            TextField(
              
              controller: _textController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '記憶集名稱', // 可輸入描述
                
              ),
            ),
            if (_fileName != null)
              Column(
                children: [
                  Text(
                    '選擇的檔案: $_fileName',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  SizedBox(height: 10), // 增加一點距離
                  Text(
                    '檔案路徑: $_filePath',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    overflow: TextOverflow.ellipsis, // 如果路徑太長，可以使用省略號
                  ),
                  
                  SizedBox(height: 20), // 再次增加距離
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







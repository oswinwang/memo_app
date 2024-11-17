// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:memorize/model/setname.dart';

class ApiService {
  static Future<List<Setname>> getSetNames(String id) async {
    final url = Uri.parse('http://192.168.193.141:5000/API/choose/${id}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((name) => Setname(name: name)).toList();
    } else {
      throw Exception('Failed to load set names');
    }
  }
}


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:memorize/model/setname.dart';

class ApiService {
  static Future<List<Setname>> getSetNames() async {
    var headers = {
      'Authorization': '88a77849-6278-40c1-9835-fbc0a1b23fa8', 
    };
    var response = await http.get(
      Uri.https('api.balldontlie.io', 'v1/teams'),
      headers: headers,
    );
    var jsondata = jsonDecode(response.body);
    List<Setname> setnames = [];
    for (var eachset in jsondata['data']) {
      final setname = Setname(name: eachset['name']);
      setnames.add(setname);
    }
    return setnames;
  }
}

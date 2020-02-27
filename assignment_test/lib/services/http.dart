import 'package:assignment_test/data/album.dart';
import 'package:assignment_test/util/util.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class HttpApi  { 
  static Future<List<Album>> getPortraitPhotos() async {
    try {
      final response =
          await http.get(CONSTANTS.WEB_SERVICE_PORTRAIT_URL);
      if (response.statusCode == 200) {
        List<Album> list = parsePhotos(response.body);
        return list;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
}


  static Future<List<Album>> getLanscapePhoto() async {
    try {
      final response =
          await http.get(CONSTANTS.WEB_SERVICE_LANDSCAPE_URL);
      if (response.statusCode == 200) {
        List<Album> list = parsePhotos(response.body);
        return list;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
}

static List<Album> parsePhotos(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Album>((json) => Album.fromJson(json)).toList();
  }
}
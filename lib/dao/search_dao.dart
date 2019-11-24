import 'dart:async';
import 'dart:convert';
import 'package:flutter_trip/model/search_model.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_trip/model/home_model.dart';

const SEARCH_URL = 'https://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=';

// 搜索接口
class SearchDao{

  static Future<SearchModel> fetch(String url, String text) async{
    final response = await http.get(url);
    if (response.statusCode == 200){
        Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
        var result = json.decode(utf8decoder.convert(response.bodyBytes));
        print('$result');
        SearchModel model = SearchModel.fromJson(result);
        model.keyword = text;
        return model;
    }else {
        throw Exception('Fail to load home_page.json');
    }
  }


}
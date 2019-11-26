import 'dart:async';
import 'dart:convert';

import 'package:flutter_trip/model/travel_model.dart';
import 'package:flutter_trip/model/travel_tab_model.dart';
import 'package:http/http.dart' as http;

// 旅拍接口
var Params = {
  "districtId": -1,
  "groupChannelCode":"",
  "type": null,
  "lat": -100,
  "lng": -100,
  "locationDistrictId": 0,
  "pagePara":{
    "pageIndex": 1,
    "pageSize": 10,
    "sortType": 9,
    "sortDirction": 0
  },
  "imageeCutType":1,
  "head":{

  },
  "contentType":"json"
};


class TravelDao {
  static Future<TravelModel> fetch(String url, String groupChannelCode, int pageIndex, int pageSize) async {
    Map paramsMap = Params['pagePara'];
    paramsMap['pageIndex'] = pageIndex;
    paramsMap['pageSize']  = pageSize;
    Params['groupChannelCode'] = groupChannelCode;
    final response = await http.post(url, body: jsonEncode(Params));
    if (response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      print('$result');
      return TravelModel.fromJson(result);
    } else {
      throw Exception('Fail to load travel_page.json');
    }
  }
}



import 'package:flutter/material.dart';
import 'package:flutter_trip/widget/webview.dart';


const URL = 'https://m.ctrip.com/webapp/myctrip/';

class MyPage extends StatefulWidget{

  @override
  _MyPageState createState() => _MyPageState();

}

class _MyPageState extends State<MyPage>{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: WebView(
        url: URL,
        hideAppBar: true,
        backForbid: true,
        statusBarColor: '4c5bca',
      ),
    );
  }




}
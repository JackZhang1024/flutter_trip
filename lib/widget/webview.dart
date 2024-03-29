import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebView extends StatefulWidget {
  final String title;
  final String url;
  final String statusBarColor;
  final bool hideAppBar;
  final bool backForbid;

  const WebView(
      {Key key,
      this.title,
      this.url,
      this.statusBarColor,
      this.hideAppBar,
      this.backForbid})
      : super(key: key);

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  final webViewReference = FlutterWebviewPlugin();
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;

  @override
  void initState() {
    super.initState();
    webViewReference.close();
    _onUrlChanged = webViewReference.onUrlChanged.listen((String url) {
       print('onUrlChanged $url');
    });
    _onStateChanged =
        webViewReference.onStateChanged.listen((WebViewStateChanged state) {
      switch (state.type) {
        case WebViewState.startLoad:
          break;
        case WebViewState.shouldStart:
          // TODO: Handle this case.
          break;
        case WebViewState.finishLoad:
          // TODO: Handle this case.
          break;
        case WebViewState.abortLoad:
          // TODO: Handle this case.
          break;
      }
    });
    _onHttpError =
        webViewReference.onHttpError.listen((WebViewHttpError error) {
      print('$error');
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    String statusBarColorStr = widget.statusBarColor ?? 'ffffff';
    Color backButtonColor;
    if (statusBarColorStr == 'ffffff') {
      backButtonColor = Colors.black;
    } else {
      backButtonColor = Colors.white;
    }
    return Scaffold(
      body: Column(
        children: <Widget>[
          _appBar(
              Color((int.parse('0xff' + statusBarColorStr))), backButtonColor),
          Expanded(
              child: WebviewScaffold(
            url: widget.url,
            withJavascript: true,
            withZoom: true,
            hidden: true,
            withLocalStorage: true,
            initialChild: Container(
              color: Colors.white,
              child: Center(
                child: Text('Waiting...'),
              ),
            ),
          ))
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    webViewReference.dispose();
    super.dispose();
  }

  _appBar(Color backgroundColor, Color backButtonColor) {
    if (widget.hideAppBar ?? false) {
      return Container(
        color: backgroundColor,
        height: MediaQuery.of(context).padding.top,
      );
    } else {
      return Container(
        color: backgroundColor,
        padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
        child: FractionallySizedBox(
          // 撑满屏幕宽度
          widthFactor: 1,
          child: Stack(
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.close,
                    color: backButtonColor,
                    size: 26,
                  ),
                ),
              ),
              Positioned(
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      widget.title ?? '',
                      style: TextStyle(fontSize: 20, color: backButtonColor),
                    ),
                  ))
            ],
          ),
        ),
      );
    }
  }
}

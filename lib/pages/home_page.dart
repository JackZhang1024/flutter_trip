import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/home_dao.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/model/home_model.dart';
import 'package:flutter_trip/model/sales_box_model.dart';
import 'package:flutter_trip/pages/search_page.dart';
import 'package:flutter_trip/pages/speak_page.dart';
import 'package:flutter_trip/widget/grid_nav.dart';
import 'package:flutter_trip/widget/loading_container.dart';
import 'package:flutter_trip/widget/local_nav.dart';
import 'package:flutter_trip/widget/sales_box.dart';
import 'package:flutter_trip/widget/search_bar.dart';
import 'package:flutter_trip/widget/sub_nav.dart';
import 'package:flutter_trip/widget/webview.dart';

const APPBAR_SCROLL_OFFSET = 100;
const SEARCH_BAR_DEFAULT_TEXT = '网红打卡地 景点 酒店 美食';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _imageUrls = [
    'https://img.zcool.cn/community/012cfc5b4b04dca80121ade084f015.jpg@1280w_1l_2o_100sh.jpg',
    'https://img.zcool.cn/community/01c15b5b4b04eea8012036be92ea83.jpg@2o.jpg',
    'https://img.zcool.cn/community/013ba35b4b052ea80121ade09e6e04.jpg@2o.jpg'
  ];

  double appBarAlpha = 0;
  String resultString = "";
  List<CommonModel> localNavList = [];
  GridNavModel gridNavModel;
  List<CommonModel> subNavList = [];
  List<CommonModel> bannerList = [];

  SalesBoxModel salesBoxModel;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    //loadData();
    _handleRefresh();
  }

  _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
    print(appBarAlpha);
  }

  // 同步方法处理 （看起来像是同步执行一样）
  Future<Null> _handleRefresh() async {
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        localNavList = model.localNavList;
        gridNavModel = model.gridNav;
        subNavList = model.subNavList;
        bannerList = model.bannerList;
        salesBoxModel = model.salesBox;
        _loading = false;
      });
    } catch (e) {
      print(e);
      _loading = false;
    }
    return null;
  }

  // 异步方法处理
  loadData() {
    HomeDao.fetch().then((model) {
      setState(() {
        localNavList = model.localNavList;
        gridNavModel = model.gridNav;
        subNavList = model.subNavList;
        salesBoxModel = model.salesBox;
        _loading = false;
      });
    }).catchError((e) {
      print(e);
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: LoadingContainer(
          isLoading: _loading,
          child: Stack(
            children: <Widget>[
              MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: RefreshIndicator(
                    child: NotificationListener(
                      onNotification: (scrollNotification) {
                        if (scrollNotification is ScrollUpdateNotification &&
                            scrollNotification.depth == 0) {
                          // 滚动且是列表滚动的时候
                          _onScroll(scrollNotification.metrics.pixels);
                        }
                        return false;
                      },
                      child: _listView,
                    ),
                    onRefresh: _handleRefresh),
              ),
              _appBar
            ],
          )),
    );
  }

  Widget get _listView {
    return ListView(
      children: <Widget>[
        _banner,
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: LocalNav(localNavList: localNavList),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: GridNav(
            gridNavModel: gridNavModel,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: SubNav(
            subNavList: subNavList,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: SalesBox(
            salesBox: salesBoxModel,
          ),
        )
      ],
    );
  }

  Widget get _appBar {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              // AppBar 渐变遮照背景
              gradient: LinearGradient(
                  colors: [Color(0x66000000), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: 80.0,
            decoration: BoxDecoration(
                color:
                    Color.fromARGB((appBarAlpha * 255).toInt(), 255, 255, 255)),
            child: SearchBar(
              searchBarType: appBarAlpha > 0.2
                  ? SearchBarType.homeLight
                  : SearchBarType.home,
              inputBoxClick: _jumpToSearch,
              speakClick: _jumpToSpeak,
              defaultText: SEARCH_BAR_DEFAULT_TEXT,
              leftButtonClick: () {},
            ),
          ),
        ),
        Container(
          height: appBarAlpha > 0.2 ? 0.5 : 0,
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.5)]),
        )
      ],
    );
  }

  Widget get _banner {
    return Container(
        height: 160,
        child: Swiper(
          itemCount: bannerList.length,
          autoplay: true,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  CommonModel model = bannerList[index];
                  return WebView(
                      url: model.url,
                      statusBarColor: model.statusBarColor,
                      title: model.title,
                      hideAppBar: model.hideAppBar);
                }));
              },
              child: Image.network(bannerList[index].icon, fit: BoxFit.fill),
            );
          },
          pagination: SwiperPagination(builder: DotSwiperPaginationBuilder()),
        ));
  }

  void _jumpToSearch() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SearchPage(hint: SEARCH_BAR_DEFAULT_TEXT)));
  }

  void _jumpToSpeak() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SpeakPage())
    );
  }
}

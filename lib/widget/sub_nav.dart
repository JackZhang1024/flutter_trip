import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';

class SubNav extends StatelessWidget {
  // final修饰应为widget类的修饰符是immutable 不可修改的
  final List<CommonModel> subNavList;

  // @required 表示为必填参数 this.name = 'xiaomoing' 默认参数
  const SubNav({Key key, @required this.subNavList}) : super(key: key);

//  @override
//  _GridNavState createState() => _GridNavState();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Padding(
        padding: EdgeInsets.all(7),
        child: _items(context),
      ),
    );
  }

  _items(BuildContext context) {
    if (subNavList == null) return null;
    List<Widget> items = [];
    subNavList.forEach((model) {
      items.add(_item(context, model));
    });
    // 按照行排列
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items);
  }


  Widget _item(BuildContext context, CommonModel model) {
    return GestureDetector(
      onTap: () {

      },
      child: Column(
        children: <Widget>[
          Image.network(model.icon, width: 32, height: 32),
          Text(
            model.title,
            style: TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }
}

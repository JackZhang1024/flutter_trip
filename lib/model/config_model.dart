

class ConfigModel{

  final String searchUrl;

  ConfigModel({this.searchUrl});


  factory ConfigModel.fromJson(Map<String, dynamic> json){
    return ConfigModel(searchUrl: json['searchUrl']);
  }

  // 转化成字符串
  Map<String, dynamic> toJson(){
    return {searchUrl: searchUrl};
  }




}
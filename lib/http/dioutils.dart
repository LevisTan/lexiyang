import 'package:dio/dio.dart';

//Dio helper类
//饿汉式单例模式
class DioManager {
  //类中唯一实例变量
  static final DioManager _instance = DioManager._();

  Dio _dio;

  //私有构造方法,基本dio设置
  DioManager._() {
    if (_dio == null) {
      _dio = new Dio(BaseOptions(
        connectTimeout: 5000,
        receiveTimeout: 100000,
      ));
    }
  }

  static DioManager getInstance() {
    return _instance;
  }

  //通用get方法
  get(String url, Map<String,dynamic> params) async{
    Response response;
    try {
      response = await _dio.get(url,queryParameters: params);
    } on DioError catch (e) {
      print('dio get error ' + e.toString());
    }
    return response.data;
  }

  //通用post方法
  post(String url, Map<String,dynamic> params) async {
    Response response;
    try {
      response = await _dio.post(url,queryParameters: params);
    } on DioError catch (e) {
      print('dio post error ' + e.toString());
    }
    return response.data;
  }
}
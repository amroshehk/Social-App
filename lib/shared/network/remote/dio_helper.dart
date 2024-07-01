import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../components/constants.dart';


class DioHelper {
  static late Dio dio;

  static init(){
    dio = Dio(
      BaseOptions(
        // baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
      )
    );
  }

  static Future<Response> getData({required path , Map<String, dynamic>? queryParameters,
    String lang ='en',
    String? token,}) async {
    dio.options.headers =  {
      'Content-Type': 'application/json',
      'lang':lang,
      'Authorization':token
    };
    return await dio.get(path ,queryParameters:queryParameters);
  }

  static Future<Response> postData({required path ,
    Map<String, dynamic>? queryParameters,
    required Map<String, dynamic>? data,
    String lang ='en',
    String? token,

  }) async {
    dio.options.headers =  {
      'Content-Type': 'application/json',
      'lang':lang,
      'Authorization':token
    };
    return await dio.post(path ,queryParameters:queryParameters, data: data);
  }

  static Future<Response> putData({
    required String path,
    Map<String, dynamic>? queryParameters,
    required Map<String, dynamic> data,
    String lang = 'en',
    String? token,
  }) async
  {
    dio.options.headers =
    {
      'lang':lang,
      'Authorization': token??'',
      'Content-Type': 'application/json',
    };

    return dio.put(
      path,
      queryParameters: queryParameters,
      data: data,
    );
  }

}
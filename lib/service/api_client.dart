import 'package:dio/dio.dart';

class ApiClient {
  Dio init() {
    var options = BaseOptions(
      baseUrl: 'https://api.imgflip.com',
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );

    Dio dio = Dio(options);
    dio.interceptors.add(CustomInterceptors());
    return dio;
  }
}

class CustomInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    return super.onError(err, handler);
  }
}

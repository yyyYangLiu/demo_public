import 'package:dio/dio.dart';

class HttpRequest{
  final String url = 'https://9b621f2b.ngrok.io';
  static Dio dio;

  BaseOptions options;
  HttpRequest([BaseOptions baseOptions]){
    if(baseOptions==null){
      baseOptions=BaseOptions(
        baseUrl: url ,
        connectTimeout: 5000,
        receiveTimeout: 3000
      );
    }

    this.options = baseOptions;

    dio = Dio(options);
    dio.interceptors.add(InterceptorsWrapper(onRequest:(RequestOptions options){
      return options;
    },onResponse:  (Response response){
      return response;
    },onError: (DioError e){
      print("error =====> $e");
      return e;
    })
    );
  }

  //get
  Future get(String path,{queryParameters, Options options, CancelToken cancelToken})async{
      return await dio.get(path, queryParameters: queryParameters,options: options,cancelToken: cancelToken);
  }

}

HttpRequest httpRequest = new HttpRequest();
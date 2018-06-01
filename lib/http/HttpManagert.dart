import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

typedef InterceptorCallback(Options options);
typedef InterceptorErrorCallback(DioError e);
typedef InterceptorsSuccessCallback(Response e);

final Dio dio =
    new Dio(new Options(connectTimeout: 5000, receiveTimeout: 3000));

get(
    {@required String url,
    InterceptorCallback onSend,
    InterceptorsSuccessCallback onSuccess,
    InterceptorErrorCallback onError}) async {
  dio.interceptor.request.onSend = onSend;
  dio.interceptor.response.onSuccess = onSuccess;
  dio.interceptor.response.onError = onError;

  Response response = await dio.get(url);
  return response.data;
}

post(
    {@required String url,
    FormData data,
    InterceptorCallback onSend,
    InterceptorsSuccessCallback onSuccess,
    InterceptorErrorCallback onError}) async {
  dio.interceptor.request.onSend = onSend;
  dio.interceptor.response.onSuccess = onSuccess;
  dio.interceptor.response.onError = onError;

  Response response = await dio.post(url, data: data);
  return response.data;
}

getDownload(
    {@required String url,
    String type,
    OnDownloadProgress progress,
    InterceptorCallback onSend,
    InterceptorsSuccessCallback onSuccess,
    InterceptorErrorCallback onError}) async {
  dio.interceptor.request.onSend = onSend;
  dio.interceptor.response.onSuccess = onSuccess;
  dio.interceptor.response.onError = onError;

  Response response = await dio.download(url, type, onProgress: progress);
  return response.data;
}

postDownload(
    {@required String url,
    FormData data,
    String type,
    OnDownloadProgress progress,
    InterceptorCallback onSend,
    InterceptorsSuccessCallback onSuccess,
    InterceptorErrorCallback onError}) async {
  dio.interceptor.request.onSend = onSend;
  dio.interceptor.response.onSuccess = onSuccess;
  dio.interceptor.response.onError = onError;

  Response response =
      await dio.download(url, type, data: data, onProgress: progress);
  return response.data;
}

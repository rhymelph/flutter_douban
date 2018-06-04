import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

typedef InterceptorCallback();
typedef InterceptorErrorCallback(Object e);
typedef InterceptorsSuccessCallback(String body);

get(
    {@required String url,
    InterceptorCallback onSend,
    InterceptorsSuccessCallback onSuccess,
    InterceptorErrorCallback onError}) async {
  onSend();
  try {
    await http.get(url).then(
      (http.Response response) {
        onSuccess(response.body);
      },
    ).catchError((){
      onError(null);
    });
  }  catch (e) {
    onError(e);
  }
}

//post(
//    {@required String url,
//    FormData data,
//    InterceptorCallback onSend,
//    InterceptorsSuccessCallback onSuccess,
//    InterceptorErrorCallback onError}) async {
//  dio.interceptor.request.onSend = onSend;
//  dio.interceptor.response.onSuccess = onSuccess;
//  dio.interceptor.response.onError = onError;
//
//  Response response = await dio.post(url, data: data);
//  return response.data;
//}
//
//getDownload(
//    {@required String url,
//    String type,
//    OnDownloadProgress progress,
//    InterceptorCallback onSend,
//    InterceptorsSuccessCallback onSuccess,
//    InterceptorErrorCallback onError}) async {
//  dio.interceptor.request.onSend = onSend;
//  dio.interceptor.response.onSuccess = onSuccess;
//  dio.interceptor.response.onError = onError;
//
//  Response response = await dio.download(url, type, onProgress: progress);
//  return response.data;
//}
//
//postDownload(
//    {@required String url,
//    FormData data,
//    String type,
//    OnDownloadProgress progress,
//    InterceptorCallback onSend,
//    InterceptorsSuccessCallback onSuccess,
//    InterceptorErrorCallback onError}) async {
//  dio.interceptor.request.onSend = onSend;
//  dio.interceptor.response.onSuccess = onSuccess;
//  dio.interceptor.response.onError = onError;
//
//  Response response =
//      await dio.download(url, type, data: data, onProgress: progress);
//  return response.data;
//}

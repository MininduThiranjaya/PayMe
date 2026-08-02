import 'package:dio/dio.dart';

class DioClient {
  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://localhost:8081/payme/api/',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }
  late final Dio dio;
}
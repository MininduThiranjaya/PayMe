import 'package:client/config/ApiEndpoints.dart';
import 'package:client/config/DioClient.dart';
import 'package:client/models/UserProfile.dart';
import 'package:dio/dio.dart';

class Login_Service {

  final DioClient dioClient;

  Login_Service({
    required this.dioClient,
  });

  // login service
  Future<String> login({required String nic, required String password}) async {

    try {
      final response = await dioClient.dio.post(
        ApiEndpoints.login,
        data: {
            'nic': nic,
            'password': password,
          }
      );
      final data = response.data;
      if (data is! Map) {
        throw Exception('Invalid login response');
      }
      final token =  data['token'];
      if (token == null || token.toString().isEmpty) {
          throw Exception('Token was not returned');
      }

      return token.toString();
    } on DioException catch (error) {

      final responseData = error.response?.data;
      final statusCode = error.response?.statusCode;
      if (statusCode == 401) {
        final code = responseData is Map ? responseData['code']?.toString() : null;
        switch (code) {
          case 'INVALID_CREDENTIALS':
            throw Exception('Invalid NIC or password');

          default:
            throw Exception('Unauthorized user');
        }
      }
      rethrow;
    }
  }

  // me
  Future<UserProfile> getCurrentUserPrrofile({required String token}) async {
    
    try {
      final response = await dioClient.dio.get(
      ApiEndpoints.me,
      options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
        throw Exception('Invalid user profile response');
    }
    return UserProfile.fromJson(data);
    } on DioException catch(error) {

      final responseData = error.response?.data;
      if (error.response?.statusCode == 401) {
        final code = responseData is Map ? responseData['code'] : null;
        switch (code) {
          case 'TOKEN_EXPIRED':
            throw Exception('Session expired');

          case 'INVALID_TOKEN':
          case 'AUTHENTICATION_FAILED':
          case 'USER_NOT_FOUND':
            throw Exception('Unauthorized user');

          default:
            throw Exception('Unauthorized user');
        }
      }
      if (responseData is Map &&
          responseData['message'] != null) {
        throw Exception(responseData['message'].toString());
      }
      rethrow;
    }
  }
}
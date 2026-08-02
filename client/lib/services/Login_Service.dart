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
      final token =  data['token'];
      if (token == null || token.toString().isEmpty) {
          throw Exception('Token was not returned');
        }

      return token.toString();
    } on DioException catch (error) {

      final responseData = error.response?.data;
      if (responseData is Map &&
          responseData['message'] != null) {
        throw Exception(responseData['message'].toString());
      }
      throw Exception(
        error.message ?? 'Login request failed',
      );
    }
  }

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
        throw Exception('Session expired');
      }
      if (responseData is Map &&
          responseData['message'] != null) {
        throw Exception(responseData['message'].toString());
      }
      throw Exception(
        error.message ?? 'Unable to load user profile',
      );
    }
  }
}
import 'package:client/config/ApiEndpoints.dart';
import 'package:client/config/DioClient.dart';
import 'package:client/models/ApiResponse.dart';
import 'package:client/models/UserRegister.dart';
import 'package:dio/dio.dart';

class Register_Service {
  final DioClient dioClient;

  Register_Service({
    required this.dioClient,
  });

  // register customer
  Future<RegisterResponseData> registerCustomer({
    required String userName,
    required String nic,
    required String password,
  }) async {
    try {
      final response = await dioClient.dio.post(
        ApiEndpoints.userRegister,
        data: {
          'userName': userName,
          'nic': nic,
          'password': password,
          'role': 'CUSTOMER',
        },
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid registration response');
      }

      final apiResponse = ApiResponse<RegisterResponseData>.fromJson(
        data,
        (json) => RegisterResponseData.fromJson(json as Map<String, dynamic>),
      );

      if (!apiResponse.status || apiResponse.resData == null) {
        throw Exception(
          apiResponse.message.isNotEmpty
              ? apiResponse.message
              : 'Registration failed',
        );
      }

      return apiResponse.resData!;
    } on DioException catch (error) {
      final responseData = error.response?.data;
      final statusCode = error.response?.statusCode;

      if (statusCode == 409) {
        final code = responseData is Map ? responseData['code']?.toString() : null;
        switch (code) {
          case 'NIC_ALREADY_EXISTS':
            throw Exception('An account with this NIC already exists');
          default:
            throw Exception('Account already exists');
        }
      }
      if (statusCode == 400) {
        final message =
            responseData is Map ? responseData['message']?.toString() : null;
        throw Exception(message ?? 'Invalid registration details');
      }
      if (responseData is Map && responseData['message'] != null) {
        throw Exception(responseData['message'].toString());
      }
      rethrow;
    }
  }

  // register merchant
  Future<MerchantRegisterResponseData> registerMerchant({
  required String userName,
  required String nic,
  required String password,
  required List<String> shopNames,
  required List<String> addresses,
}) async {
  try {
    final response = await dioClient.dio.post(
      ApiEndpoints.merchantRegister,
      data: {
        'userName': userName,
        'nic': nic,
        'password': password,
        'role': 'MERCHANT',

        'shopNames': shopNames,
        'addresses': addresses,
      },
    );

    final data = response.data;

    if (data is! Map<String, dynamic>) {
      throw Exception(
        'Invalid registration response',
      );
    }

    final apiResponse =
        ApiResponse<MerchantRegisterResponseData>.fromJson(
      data,
      (json) =>
          MerchantRegisterResponseData.fromJson(
        json as Map<String, dynamic>,
      ),
    );

    if (!apiResponse.status ||
        apiResponse.resData == null) {
      throw Exception(
        apiResponse.message.isNotEmpty
            ? apiResponse.message
            : 'Registration failed',
      );
    }

    return apiResponse.resData!;

  } on DioException catch (error) {
    final responseData = error.response?.data;
    final statusCode =
        error.response?.statusCode;

    if (statusCode == 409) {
      final code = responseData is Map
          ? responseData['code']?.toString()
          : null;

      switch (code) {
        case 'NIC_ALREADY_EXISTS':
          throw Exception(
            'An account with this NIC already exists',
          );

        default:
          throw Exception(
            'Account already exists',
          );
      }
    }

    if (statusCode == 400) {
      final message = responseData is Map
          ? responseData['message']?.toString()
          : null;

      throw Exception(
        message ??
            'Invalid registration details',
      );
    }

    if (responseData is Map &&
        responseData['message'] != null) {
      throw Exception(
        responseData['message'].toString(),
      );
    }

    rethrow;
  }
}
}
import 'package:client/config/ApiEndpoints.dart';
import 'package:client/config/DioClient.dart';
import 'package:client/models/ApiResponse.dart';
import 'package:dio/dio.dart';

class SellProduct_Service {
  final DioClient dioClient;

  SellProduct_Service({
    required this.dioClient,
  });

  Future<int> createNewOrder({
    required String token,
    required List<Map<String, dynamic>> orderItems,
  }) async {
    try {
      final response = await dioClient.dio.post(
        ApiEndpoints.setNewOrder,
        data: {
          'orderItem': orderItems,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final data = response.data;

      if (data is! Map<String, dynamic>) {
        throw Exception(
          'Invalid create order response',
        );
      }

      final apiResponse =
          ApiResponse<int>.fromJson(
        data,
        (json) => (json as num).toInt(),
      );

      if (!apiResponse.status ||
          apiResponse.resData == null) {
        throw Exception(
          apiResponse.message.isNotEmpty
              ? apiResponse.message
              : 'Order creation failed',
        );
      }

      return apiResponse.resData!;
    } on DioException catch (error) {
      final responseData =
          error.response?.data;

      final statusCode =
          error.response?.statusCode;

      if (statusCode == 400) {
        final message =
            responseData is Map
                ? responseData['message']
                    ?.toString()
                : null;

        throw Exception(
          message ?? 'Invalid order details',
        );
      }

      if (statusCode == 401) {
        throw Exception(
          'Session expired or unauthorized',
        );
      }

      if (statusCode == 403) {
        throw Exception(
          'Only merchants can create orders',
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
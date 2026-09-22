import 'package:client/config/ApiEndpoints.dart';
import 'package:client/config/DioClient.dart';
import 'package:client/models/ApiResponse.dart';
import 'package:client/models/ClaimedOrder.dart';

import 'package:dio/dio.dart';

class CustomerOrder_Service {
  final DioClient dioClient;

  CustomerOrder_Service({
    required this.dioClient,
  });

  Future<ClaimedOrder> claimOrder({
    required String token,
    required int orderId,
  }) async {
    try {
      final response =
          await dioClient.dio.post(
        ApiEndpoints.claimOrder,

        data: {
          'orderId': orderId,
        },

        options: Options(
          headers: {
            'Authorization':
                'Bearer $token',
          },
        ),
      );

      final data =
          response.data;

      if (data is! Map<String, dynamic>) {
        throw Exception(
          'Invalid claim order response',
        );
      }

      final apiResponse =
          ApiResponse<ClaimedOrder>.fromJson(
        data,
        (json) =>
            ClaimedOrder.fromJson(
          json as Map<String, dynamic>,
        ),
      );

      if (!apiResponse.status ||
          apiResponse.resData == null) {
        throw Exception(
          apiResponse.message.isNotEmpty
              ? apiResponse.message
              : 'Unable to claim order',
        );
      }

      return apiResponse.resData!;
    } on DioException catch (error) {
      final statusCode =
          error.response?.statusCode;

      final responseData =
          error.response?.data;

      if (statusCode == 400) {
        throw Exception(
          _extractMessage(
            responseData,
            'Invalid order',
          ),
        );
      }

      if (statusCode == 401) {
        throw Exception(
          'Session expired. Please login again.',
        );
      }

      if (statusCode == 403) {
        throw Exception(
          'Only customers can claim this order.',
        );
      }

      if (statusCode == 404) {
        throw Exception(
          'Order was not found.',
        );
      }

      if (statusCode == 409) {
        throw Exception(
          _extractMessage(
            responseData,
            'This order is no longer available.',
          ),
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

  String _extractMessage(
    dynamic responseData,
    String fallback,
  ) {
    if (responseData is Map &&
        responseData['message'] != null) {
      return responseData['message']
          .toString();
    }

    return fallback;
  }
}
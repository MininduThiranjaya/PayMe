class ApiResponse<T> {
  final bool status;
  final String message;
  final T? resData;

  ApiResponse({
    required this.status,
    required this.message,
    this.resData,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    return ApiResponse<T>(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      resData: json['resData'] != null ? fromJsonT(json['resData']) : null,
    );
  }
}
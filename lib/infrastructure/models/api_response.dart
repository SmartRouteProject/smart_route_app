class ApiResponse<T> {
  final bool success;
  final ApiResponseError error;
  final T? data;

  ApiResponse({
    required this.success,
    required this.error,
    required this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    final errorJson = (json['error'] as Map<String, dynamic>?) ?? {};
    return ApiResponse(
      success: json['success'] ?? false,
      error: ApiResponseError.fromJson(errorJson),
      data: json['data'] == null ? null : fromJsonT(json['data']),
    );
  }

  Map<String, dynamic> toMap({Object? Function(T value)? toMapT}) {
    return {
      'success': success,
      'error': error.toMap(),
      'data': data == null
          ? null
          : toMapT != null
              ? toMapT(data as T)
              : data,
    };
  }

  ApiResponse<T> copyWith({
    bool? success,
    ApiResponseError? error,
    T? data,
    bool setDataNull = false,
  }) {
    return ApiResponse(
      success: success ?? this.success,
      error: error ?? this.error,
      data: setDataNull ? null : data ?? this.data,
    );
  }
}

class ApiResponseError {
  final String code;
  final String message;

  ApiResponseError({
    required this.code,
    required this.message,
  });

  factory ApiResponseError.fromJson(Map<String, dynamic> json) {
    return ApiResponseError(
      code: json['code']?.toString() ?? '',
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'message': message,
    };
  }

  ApiResponseError copyWith({
    String? code,
    String? message,
  }) {
    return ApiResponseError(
      code: code ?? this.code,
      message: message ?? this.message,
    );
  }
}

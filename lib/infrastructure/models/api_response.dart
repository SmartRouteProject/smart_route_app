class ApiResponse<T> {
  final String code;
  final T payload;
  final String error;

  ApiResponse({required this.code, required this.payload, required this.error});
}

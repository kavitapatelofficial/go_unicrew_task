import 'dart:io';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;

  factory ApiException.fromException(dynamic error) {
    if (error is SocketException) {
      return const ApiException('No Internet connection. Please check your network.');
    } else if (error is FormatException) {
      return const ApiException('Bad response format from server.');
    } else if (error is ApiException) {
      return error;
    } else {
      return ApiException(error.toString());
    }
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import 'api_exception.dart';

class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<dynamic> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint').replace(
        queryParameters: queryParameters?.map((k, v) => MapEntry(k, v.toString())),
      );

      final response = await _client
          .get(uri, headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          })
          .timeout(ApiConstants.requestTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw const ApiException('No Internet connection. Please check your connection and retry.');
    } on TimeoutException {
      throw const ApiException('Connection timed out. Please try again.');
    } on FormatException {
      throw const ApiException('Invalid response format received from server.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(e.toString());
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw const ApiException('Resource not found (404)', 404);
    } else if (response.statusCode >= 500) {
      throw ApiException('Server error (${response.statusCode}). Please try again later.', response.statusCode);
    } else {
      throw ApiException('HTTP Error: ${response.statusCode} ${response.reasonPhrase}', response.statusCode);
    }
  }
}

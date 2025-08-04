import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import '../errors/failures.dart';

class ApiClient {
  final http.Client client;
  
  ApiClient({http.Client? client}) : client = client ?? http.Client();
  
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final url = '${ApiConstants.baseUrl}$endpoint';
    
    if (kDebugMode) {
      print('Making GET request to: $url');
    }
    
    try {
      final response = await client
          .get(
            Uri.parse(url),
            headers: headers ?? ApiConstants.headers,
          )
          .timeout(const Duration(milliseconds: ApiConstants.connectionTimeout));
      
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body length: ${response.body.length}');
      }
      
      return _handleResponse(response, url);
    } on SocketException catch (e) {
      if (kDebugMode) {
        print('SocketException: $e');
      }
      throw const NetworkFailure('No internet connection. Please check your network settings.');
    } on HttpException catch (e) {
      if (kDebugMode) {
        print('HttpException: $e');
      }
      throw const NetworkFailure('Network error occurred. Please try again.');
    } on FormatException catch (e) {
      if (kDebugMode) {
        print('FormatException: $e');
      }
      throw const ServerFailure('Invalid response format from server.');
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected error: $e');
      }
      throw NetworkFailure('Unexpected error occurred: ${e.toString()}');
    }
  }
  
  Future<List<dynamic>> getList(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final url = '${ApiConstants.baseUrl}$endpoint';
    
    if (kDebugMode) {
      print('Making GET list request to: $url');
    }
    
    try {
      final response = await client
          .get(
            Uri.parse(url),
            headers: headers ?? ApiConstants.headers,
          )
          .timeout(const Duration(milliseconds: ApiConstants.connectionTimeout));
      
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body.substring(0, response.body.length > 500 ? 500 : response.body.length)}...');
      }
      
      return _handleListResponse(response, url);
    } on SocketException catch (e) {
      if (kDebugMode) {
        print('SocketException: $e');
      }
      throw const NetworkFailure('No internet connection. Please check your network settings.');
    } on HttpException catch (e) {
      if (kDebugMode) {
        print('HttpException: $e');
      }
      throw const NetworkFailure('Network error occurred. Please try again.');
    } on FormatException catch (e) {
      if (kDebugMode) {
        print('FormatException: $e');
      }
      throw const ServerFailure('Invalid response format from server.');
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected error: $e');
      }
      throw NetworkFailure('Unexpected error occurred: ${e.toString()}');
    }
  }
  
  Map<String, dynamic> _handleResponse(http.Response response, String url) {
    try {
      switch (response.statusCode) {
        case 200:
          final jsonData = json.decode(response.body);
          if (jsonData is Map<String, dynamic>) {
            return jsonData;
          } else {
            throw const ServerFailure('Expected object response but got different format');
          }
        case 404:
          throw const ServerFailure('Repository not found. Please check the repository name and owner.');
        case 403:
          final message = _parseErrorMessage(response.body);
          throw ServerFailure('Access forbidden: $message');
        case 401:
          throw const AuthFailure('Authentication required. Invalid or missing token.');
        case 422:
          final message = _parseErrorMessage(response.body);
          throw ServerFailure('Validation error: $message');
        case 500:
          throw const ServerFailure('GitHub server error. Please try again later.');
        default:
          final message = _parseErrorMessage(response.body);
          throw ServerFailure('Server error (${response.statusCode}): $message');
      }
    } on FormatException {
      throw const ServerFailure('Invalid JSON response from server');
    }
  }
  
  List<dynamic> _handleListResponse(http.Response response, String url) {
    try {
      switch (response.statusCode) {
        case 200:
          final jsonData = json.decode(response.body);
          if (jsonData is List) {
            return jsonData;
          } else {
            throw const ServerFailure('Expected list response but got different format');
          }
        case 404:
          throw const ServerFailure('Repository not found. Please check the repository name and owner.');
        case 403:
          final message = _parseErrorMessage(response.body);
          if (message.toLowerCase().contains('rate limit')) {
            throw const ServerFailure('GitHub API rate limit exceeded. Please try again later.');
          }
          throw ServerFailure('Access forbidden: $message');
        case 401:
          throw const AuthFailure('Authentication required. Invalid or missing token.');
        case 422:
          final message = _parseErrorMessage(response.body);
          throw ServerFailure('Validation error: $message');
        case 500:
          throw const ServerFailure('GitHub server error. Please try again later.');
        default:
          final message = _parseErrorMessage(response.body);
          throw ServerFailure('Server error (${response.statusCode}): $message');
      }
    } on FormatException {
      throw const ServerFailure('Invalid JSON response from server');
    }
  }
  
  String _parseErrorMessage(String responseBody) {
    try {
      final jsonData = json.decode(responseBody);
      if (jsonData is Map<String, dynamic>) {
        return jsonData['message'] ?? 'Unknown error occurred';
      }
      return 'Unknown error occurred';
    } catch (e) {
      return 'Unable to parse error message';
    }
  }
  
  void dispose() {
    client.close();
  }
}

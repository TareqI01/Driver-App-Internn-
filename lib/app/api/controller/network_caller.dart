import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter_intern/app/api/controller/network_response.dart';

class NetworkCaller {
  Future<NetworkResponse>? postRequest(
    String url, {
    Map<String, dynamic>? body,
    String? authorizationHeader,
  }) async {
    try {
      print(" POST $url");
      print(" Request Body: $body");

      Map<String, String> headers = {"Content-Type": "application/json"};

      // Add authorization header if provided
      if (authorizationHeader != null && authorizationHeader.isNotEmpty) {
        headers['Authorization'] = authorizationHeader;
      }

      final response = await post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: headers,
      );
      print(response.body);
      if (response.statusCode == 200) {
        return NetworkResponse(
          isSuccess: true,
          statusCode: 200,
          jsonResponse: jsonDecode(response.body),
        );
      }

      return NetworkResponse(
        isSuccess: false,
        statusCode: 401,
        jsonResponse: jsonDecode(response.body),
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<NetworkResponse> getRequest(
    String url, {
    String? authorizationHeader,
  }) async {
    try {
      Map<String, String> headers = {};

      // Add authorization header if provided
      if (authorizationHeader != null && authorizationHeader.isNotEmpty) {
        headers['Authorization'] = authorizationHeader;
      }

      final response = await get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        return NetworkResponse(
          statusCode: 200,
          isSuccess: true,
          jsonResponse: jsonDecode(response.body),
        );
      } else if (response.statusCode == 401) {
        return NetworkResponse(
          isSuccess: false,
          statusCode: 401,
          jsonResponse: jsonDecode(response.body),
        );
      } else {
        return NetworkResponse(
          statusCode: 400,
          isSuccess: false,
          jsonResponse: jsonDecode(response.body),
        );
      }
    } catch (e) {
      return NetworkResponse(isSuccess: false, errorMessage: e.toString());
    }
  }
}

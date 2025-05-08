import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import '../../data/network/base_api_services.dart';
import 'package:http/http.dart' as http;

import '../app_exceptions.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NetworkApiServices extends BaseApiServices {
  @override
  Future<dynamic> getApi(String url) async {
    if (kDebugMode) {
      // print(url);
    }

    dynamic responseJson;
    try {
      final headers = {
        'X-API-KEY': dotenv.env['API_KEY'] ?? '', // Obtener la API_KEY del .env
      };

      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 5));
      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }

    // print(responseJson);
    return responseJson;
  }

  @override
  Future<dynamic> postApi(var data, String url) async {
    if (kDebugMode) {
      print(url);
      print(data);
    }

    dynamic responseJson;
    try {
      final headers = {
        'Content-Type': 'application/json',
        'X-API-KEY': dotenv.env['API_KEY'] ?? '', // Obtener la API_KEY del .env
      };

      final response = await http
          .post(Uri.parse(url), headers: headers, body: jsonEncode(data))
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }

    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;

      default:
        throw FetchDataException(
          'Error occurred while communicating with server ' +
              response.statusCode.toString(),
        );
    }
  }
}

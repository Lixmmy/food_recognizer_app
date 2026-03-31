import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:food_recognizer_app/error/exceptions.dart';
import 'package:food_recognizer_app/models/meal_response.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';


class ApiService {
  Future<bool> _ensureInternetConnection() async {
    if (kIsWeb) {
      return true;
    }
    var connectivityResult = await (Connectivity().checkConnectivity());

    // ignore: unrelated_type_equality_checks
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      bool hasInternet = await InternetConnection().hasInternetAccess;
      if (!hasInternet) {
        throw NetworkException('Tidak ada WIFI atau internet yang tersambung');
      }
      return true;
    }
  }

  Future<dynamic> _requestGet(
    String endpoint,
    String message, {
    String? queryParameters,
  }) async {
    try {
      await _ensureInternetConnection();
      Uri uri = Uri(
        scheme: 'https',
        host: 'themealdb.com',
        path: 'api/json/v1/1/$endpoint',
        queryParameters: {'s': queryParameters},
      );

      final Map<String, String> headers = {'Accept': 'application/json'};

      final response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } on NetworkException {
      rethrow;
    } on TimeoutException {
      throw Exception('Koneksi timeout, silakan coba lagi.');
    } catch (e) {
      throw Exception(message);
    }
  }

  Future<MealsResponse> getClassificationName(String classification) async {
    final response = await _requestGet(
      'search.php',
      'Tidak Ada restaurant yang ditemukan',
      queryParameters: classification,
    );
    return MealsResponse.fromJson(response);
  }

}

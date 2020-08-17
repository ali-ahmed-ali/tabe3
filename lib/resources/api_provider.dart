import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:tabee/utils/lang.dart';

enum Method { GET, POST, PATCH, DELETE } // HEAD Methods

class ApiProvider {
  static String _baseUrl = "http://167.71.71.0:8069";
  String apiUrl = "$_baseUrl/app_api/";
  int keepOnCache = 0; // Day
  Dio dio = new Dio();
  CancelToken cancelToken = new CancelToken();

  ApiProvider() {
    initDioOptions();
  }

  void initDioOptions() async {
    dio.options.baseUrl = apiUrl;
    dio.options.connectTimeout = 50000; //50s
    dio.options.receiveTimeout = 50000; //50s
    dio.options.contentType = "application/json";
    dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: apiUrl)).interceptor);
    dio.options.headers = {
      "Content-Type": "application/json",
    };
  }

  Future<Map<String, dynamic>> getCountryAndState() async {
    return await _doRequest("getCountyAndState?", Method.POST, {});
  }

  Future<Map<String, dynamic>> registerCustomer(
      Map<String, dynamic> request) async {
    return await _doRequest("/RegisterCustomer", Method.POST, request);
  }

  Future<Map<String, dynamic>> loginCustomer(
      String mobile, String password) async {
    return await _doRequest("/LoginCustomer", Method.POST, {
      "mobile": mobile,
      "password": password,
    });
  }

  Future<Map<String, dynamic>> sendVerifyPin(String mobile) async {
    return await _doRequest("/SendverifyPin", Method.POST, {
      "mobile": mobile,
    });
  }

  Future<Map<String, dynamic>> updatePassword(
      String mobile, String password, String pin) async {
    return await _doRequest("/updatePassword", Method.POST, {
      "mobile": mobile,
      "password": password,
      "pin": pin,
    });
  }

  Future<Map<String, dynamic>> verifyPin(String mobile, String pin) async {
    return await _doRequest("/verifyPin", Method.POST, {
      "mobile": mobile,
      "pin": pin,
    });
  }

  Future<Map<String, dynamic>> updateToken(
      String customerId, String newToken) async {
    return await _doRequest("/updatetoken", Method.POST, {
      "customer_id": customerId,
      "token": newToken,
    });
  }

  Future<Map<String, dynamic>> _doRequest(String path, Method method,
      [Map<String, dynamic> requestFromUser]) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    Map<String, dynamic> request = {};
    request["params"] = requestFromUser;
    print('Checking network status: ${connectivityResult.toString()}');
    if (connectivityResult == ConnectivityResult.none) {
      print('No internet connection');
      return {
        "success": false,
        "code": -1,
        "msg": lang.text("No internet connectivity"),
      };
    } else {
      print('You connected via: ${connectivityResult.toString()}');
    }

    try {
      Response response;
      if (method == Method.POST) {
        response = await dio.post(
          path,
          data: request,
          cancelToken: cancelToken,
          options: buildCacheOptions(
            Duration(days: keepOnCache),
            maxStale: Duration(days: keepOnCache),
            forceRefresh: true,
          ),
        );
      } else if (method == Method.PATCH) {
        response = await dio.patch(
          path,
          cancelToken: cancelToken,
          data: request,
          options: buildCacheOptions(
            Duration(days: keepOnCache),
            maxStale: Duration(days: keepOnCache),
            forceRefresh: true,
          ),
        );
      } else if (method == Method.GET) {
        response = await dio.get(
          path,
          cancelToken: cancelToken,
          options: buildCacheOptions(
            Duration(days: keepOnCache),
            maxStale: Duration(days: keepOnCache),
            forceRefresh: true,
          ),
        );
      } else if (method == Method.DELETE) {
        response = await dio.delete(
          path,
          cancelToken: cancelToken,
          data: request,
          options: buildCacheOptions(
            Duration(days: keepOnCache),
            maxStale: Duration(days: keepOnCache),
            forceRefresh: true,
          ),
        );
      }

      print('Response from provider: $response');
      if (response != null) {
        print('response.statusCode: ${response.statusCode}');
        print('response.data: ${response.data}');
        if (response.statusCode == 200) {
          var responseData = response.data;
          Map data;
          if (responseData is String) {
            data = json.decode(responseData);
          } else {
            data = responseData;
          }

          data = data["result"];

          if (method != Method.GET) {
            if (data.containsKey("status") && data["status"] == 1) {
              data["success"] = true;
            } else {
              data["success"] = false;
            }
          } else {
            data["success"] = true;
          }
          return data;
        } else {
          return {
            "success": false,
            "code": -1,
            "error_code": response.statusCode, // 500
            "msg": lang.text("No internet connectivity")
          };
        }
      }
    } catch (e) {
      print('Exception: $e');
    }

    return {
      "success": false,
      "code": -1,
      "error_code": -1, // 500
      "msg": lang.text("No internet connectivity")
    };
  }
}

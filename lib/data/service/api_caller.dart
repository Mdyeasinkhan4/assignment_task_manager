import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:assignment_task_manager/controller/auth_controller.dart';
import 'package:assignment_task_manager/data/model/api_response.dart';
import 'package:http/http.dart';

class ApiCaller {

  static Future<ApiResponse> getRequest({required String url}) async {
    try {
      Response response = await get(
        Uri.parse(url),
        headers: {
          'token': AuthController.accessToken ?? ''
        },
      ).timeout(Duration(seconds: 15));

      print('URL=== $url');
      print('response === ${response.body}');

      if (response.statusCode == 200) {
        return ApiResponse(responseCode: response.statusCode, responseData: jsonDecode(response.body), isSuccess: true);
      } else {
        dynamic data;
        try {
          data = jsonDecode(response.body);
        } catch (_) {
          data = {'data': 'Something went wrong (${response.statusCode})'};
        }
        return ApiResponse(responseCode: response.statusCode, responseData: data, isSuccess: false, errorMessage: data.toString());
      }
    } on TimeoutException {
      return ApiResponse(responseCode: -1, responseData: {'data': 'Request timeout, Try Again'}, isSuccess: false, errorMessage: 'timeout');
    } on SocketException {
      return ApiResponse(responseCode: -1, responseData: {'data': 'Connection Error! Check Internet connection'}, isSuccess: false, errorMessage: 'no internet');
    } catch (e) {
      return ApiResponse(responseCode: -1, responseData: {'data': 'Something went wrong'}, isSuccess: false, errorMessage: e.toString());
    }
  }




  static Future<ApiResponse> PostRequest({required String url, Map<String,dynamic>? body}) async {
    try {
      Response response = await post(
        Uri.parse(url),
        headers: {
          'token': AuthController.accessToken ?? '',
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: body != null ? jsonEncode(body) : null,
      ).timeout(Duration(seconds: 15));

      print('URL=== $url');
      print('response === ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(responseCode: response.statusCode, responseData: jsonDecode(response.body), isSuccess: true);
      } else {
        dynamic data;
        try {
          data = jsonDecode(response.body);
        } catch (_) {
          data = {'data': 'Something went wrong (${response.statusCode})'};
        }
        return ApiResponse(responseCode: response.statusCode, responseData: data, isSuccess: false, errorMessage: data.toString());
      }
    } on TimeoutException {
      return ApiResponse(responseCode: -1, responseData: {'data': 'Request timeout, Try Again'}, isSuccess: false, errorMessage: 'timeout');
    } on SocketException {
      return ApiResponse(responseCode: -1, responseData: {'data': 'Error! Check Internet connection'}, isSuccess: false, errorMessage: 'no internet');
    } catch (e) {
      return ApiResponse(responseCode: -1, responseData: {'data': 'Something went wrong'}, isSuccess: false, errorMessage: e.toString());
    }
  }

}
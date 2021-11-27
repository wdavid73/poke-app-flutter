import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class RestClientServices {
  final _headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Token '
  };

  String base = "https://laravel-poke-api.herokuapp.com/api/";
  int durationTimeOut = 30;

  Future<GenericResponse> get(String path, String token) async {
    try {
      _headers["Authorization"] = "Token $token";
      final response = await http
          .get(
            Uri.parse(base + path),
            headers: _headers,
          )
          .timeout(
            Duration(seconds: durationTimeOut),
          );
      if (response.statusCode == 200) {
        return _genericResponseFromJson(0, "", response.body);
      }
      return _genericResponseFromJson(1, response.body, null);
    } on TimeoutException catch (_) {
      return _genericResponseFromJson(
        1,
        'The connection has timed out, Please try again!',
        null,
      );
    } catch (e) {
      if (e.toString().contains("No route to host") ||
          e.toString().contains("No address associated with hostname") ||
          e.toString().contains("Connection refused") ||
          e.toString().contains("Network is unreachable")) {
        return _genericResponseFromJson(
          1,
          "Check your device's data or Wi-Fi connection.",
          null,
        );
      } else {
        return _genericResponseFromJson(
          1,
          'Internal error. Contact support.',
          null,
        );
      }
    }
  }

  Future<GenericResponse> post(
    String path,
    Map<String, dynamic> data,
    String token,
  ) async {
    try {
      _headers["Authorization"] = "Token $token";
      final response = await http
          .post(
            Uri.parse(base + path),
            headers: _headers,
            body: jsonEncode(data),
          )
          .timeout(
            Duration(seconds: durationTimeOut),
          );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return _genericResponseFromJson(0, "", response.body);
      } else {
        return _genericResponseFromJson(1, response.body, null);
      }
    } on TimeoutException catch (_) {
      return _genericResponseFromJson(
        1,
        'The connection has timed out, Please try again!',
        null,
      );
    } catch (e) {
      if (e.toString().contains("No route to host") ||
          e.toString().contains("No address associated with hostname") ||
          e.toString().contains("Connection refused") ||
          e.toString().contains("Network is unreachable")) {
        return _genericResponseFromJson(
          1,
          "Check your device's data or Wi-Fi connection.",
          null,
        );
      } else {
        return _genericResponseFromJson(
          1,
          'Internal error. Contact support.',
          null,
        );
      }
    }
  }

  Future<GenericResponse> postWithImage(
    String path,
    Map<String, dynamic> data,
    String token,
    String filePath,
  ) async {
    print("post with image");
    try {
      _headers["Authorization"] = "Token $token";

      var request = http.MultipartRequest(
        "POST",
        Uri.parse(base + path),
      );
      request.fields["name"] = data["name"];
      //"photo": _image,
      request.fields["ps"] = data["ps"].toString();
      request.fields["atq"] = data["atq"].toString();
      request.fields["df"] = data["df"].toString();
      request.fields["atq_spl"] = data["atqSql"].toString();
      request.fields["df_spl"] = data["dfSql"].toString();
      request.fields["spl"] = data["spl"].toString();
      request.fields["vel"] = data["vel"].toString();
      request.fields["acc"] = data["acc"].toString();
      request.fields["evs"] = data["evs"].toString();
      request.headers["Authorization"] = "Token $token";
      var pic = await http.MultipartFile.fromPath("photo", filePath);
      request.files.add(pic);
      final response = await request.send().timeout(
            Duration(seconds: durationTimeOut),
          );
      var responseData = await response.stream.toBytes();
      if (response.statusCode == 201 || response.statusCode == 200) {
        return _genericResponseFromJson(0, "", responseData);
      } else {
        var responseString = String.fromCharCodes(responseData);
        return _genericResponseFromJson(1, responseString, null);
      }
    } on TimeoutException catch (_) {
      return _genericResponseFromJson(
        1,
        'The connection has timed out, Please try again!',
        null,
      );
    } catch (e) {
      print(e);
      if (e.toString().contains("No route to host") ||
          e.toString().contains("No address associated with hostname") ||
          e.toString().contains("Connection refused") ||
          e.toString().contains("Network is unreachable")) {
        return _genericResponseFromJson(
          1,
          "Check your device's data or Wi-Fi connection.",
          null,
        );
      } else {
        return _genericResponseFromJson(
          1,
          'Internal error. Contact support.',
          null,
        );
      }
    }
  }

  Future<GenericResponse> put(
    String path,
    Map<String, dynamic> data,
    String token,
  ) async {
    try {
      _headers["Authorization"] = "Token $token";
      final response = await http
          .put(
            Uri.parse(base + path),
            headers: _headers,
            body: jsonEncode(data),
          )
          .timeout(
            Duration(seconds: durationTimeOut),
          );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return _genericResponseFromJson(0, "", response.body);
      } else {
        return _genericResponseFromJson(1, response.body, null);
      }
    } on TimeoutException catch (_) {
      return _genericResponseFromJson(
        1,
        'The connection has timed out, Please try again!',
        null,
      );
    } catch (e) {
      if (e.toString().contains("No route to host") ||
          e.toString().contains("No address associated with hostname") ||
          e.toString().contains("Connection refused") ||
          e.toString().contains("Network is unreachable")) {
        return _genericResponseFromJson(
          1,
          "Check your device's data or Wi-Fi connection.",
          null,
        );
      } else {
        return _genericResponseFromJson(
          1,
          'Internal error. Contact support.',
          null,
        );
      }
    }
  }

  Future<GenericResponse> delete(String path, String token) async {
    try {
      _headers["Authorization"] = "Token $token";
      final response = await http
          .delete(
            Uri.parse(base + path),
            headers: _headers,
          )
          .timeout(
            Duration(seconds: durationTimeOut),
          );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return _genericResponseFromJson(0, "", response.body);
      } else {
        return _genericResponseFromJson(1, response.body, null);
      }
    } on TimeoutException catch (_) {
      return _genericResponseFromJson(
        1,
        'The connection has timed out, Please try again!',
        null,
      );
    } catch (e) {
      if (e.toString().contains("No route to host") ||
          e.toString().contains("No address associated with hostname") ||
          e.toString().contains("Connection refused") ||
          e.toString().contains("Network is unreachable")) {
        return _genericResponseFromJson(
          1,
          "Check your device's data or Wi-Fi connection.",
          null,
        );
      } else {
        return _genericResponseFromJson(
          1,
          'Internal error. Contact support.',
          null,
        );
      }
    }
  }

  Future<GenericResponse> login(String path, Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            Uri.parse(base + path),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(data),
          )
          .timeout(
            Duration(
              seconds: durationTimeOut,
            ),
          );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return _genericResponseFromJson(0, "", response.body);
      } else {
        return _genericResponseFromJson(1, response.body, null);
      }
    } on TimeoutException catch (_) {
      return _genericResponseFromJson(
        1,
        'The connection has timed out, Please try again!',
        null,
      );
    } catch (e) {
      if (e.toString().contains("No route to host") ||
          e.toString().contains("No address associated with hostname") ||
          e.toString().contains("Connection refused") ||
          e.toString().contains("Network is unreachable")) {
        return _genericResponseFromJson(
          1,
          "Check your device's data or Wi-Fi connection.",
          null,
        );
      } else {
        return _genericResponseFromJson(
          1,
          'Internal error. Contact support.',
          null,
        );
      }
    }
  }

  Future<GenericResponse> logout(String token) async {
    try {
      _headers["Authorization"] = "Token $token";
      final response = await http
          .post(
            Uri.parse(base + "logout"),
            headers: _headers,
          )
          .timeout(
            Duration(seconds: durationTimeOut),
          );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return _genericResponseFromJson(0, "", response.body);
      } else {
        return _genericResponseFromJson(1, response.body, null);
      }
    } on TimeoutException catch (_) {
      return _genericResponseFromJson(
        1,
        'The connection has timed out, Please try again!',
        null,
      );
    } catch (e) {
      if (e.toString().contains("No route to host") ||
          e.toString().contains("No address associated with hostname") ||
          e.toString().contains("Connection refused") ||
          e.toString().contains("Network is unreachable")) {
        return _genericResponseFromJson(
          1,
          "Check your device's data or Wi-Fi connection.",
          null,
        );
      } else {
        return _genericResponseFromJson(
          1,
          'Internal error. Contact support.',
          null,
        );
      }
    }
  }

  GenericResponse _genericResponseFromJson(
      int statusCode, String message, dynamic data) {
    var genericResponse = new GenericResponse(
      statusCode: statusCode,
      message: message,
      data: data,
    );
    return genericResponse;
  }
}

class GenericResponse {
  int statusCode;
  String message;
  dynamic data;

  GenericResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  @override
  String toString() {
    return 'statusCode : $statusCode\nmessage: $message\ndata: $data';
  }
}

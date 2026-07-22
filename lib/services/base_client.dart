import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:sanmiwago_user/constants/api_constants.dart';
import 'package:sanmiwago_user/utils/enums.dart';

import 'app_exceptions.dart';

class BaseClient {
  static const int timeOutDuration = 20;
  //GET
  Future<dynamic> get(String baseUrl, String api) async {
    var uri = Uri.parse(baseUrl + api);
    log("uri -- get: $uri");
    try {
      var response = await http.get(uri).timeout(const Duration(seconds: timeOutDuration));
      // log("SIMPLE RESPONSE \n  ${response.body}");
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException('API not responded in time', uri.toString());
    } catch (e) {
      log("ERROR in after catch \n  $e}");
    }
  }

  //POST
  Future<dynamic> postOriginal(String baseUrl, String api, dynamic payloadObj) async {
    var uri = Uri.parse(baseUrl + api);
    var payload = json.encode(payloadObj);
    try {
      var response = await http.post(uri, body: payload).timeout(const Duration(seconds: timeOutDuration));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException('API not responded in time', uri.toString());
    }
  }

  Future<dynamic> post(
    String baseUrl,
    String endpoint,
    Map<String, dynamic> body, {
    bool shouldEncode = false,
    bool isStripe = false,
    Map<String, String>? headers,
  }) async {
    Uri uri = Uri.parse(baseUrl + endpoint);

    body.putIfAbsent("request_from", () => ApiConstants.apiRequestFrom);

    log("Generated Url  $uri");
    log("body is  $body");
    // log("body is  ${jsonEncode(body)}");
    // Map<String, String> header = {"content-type": "text/plain"};
    // var payload = json.encode(payloadObj);

    try {
      var response = await http
          .post(
            uri,
            headers: headers,
            body: shouldEncode ? jsonEncode(body) : body,
          )
          .timeout(const Duration(seconds: timeOutDuration));
      log("SIMPLE RESPONSE :  --- $uri \n  ${response.body}");
      log("SIMPLE RESPONSE \n  ${response.statusCode}");
      log("SIMPLE RESPONSE \n  ${response.body.runtimeType}");
      log("SIMPLE RESPONSE \n  ${response.headers}");

      return isStripe ? _processStripeResponse(response) : _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException('API did not responded in time', uri.toString());
    }
  }

  /// POST MULTIPART request function
  Future<dynamic> multipartPostRequest(
      String baseUrl,
      String endpoint,
      Map<String, String> body, {
        required String fileFieldName,
        required String filePath,
        Map<String, String>? headers,
      }) async {
    Uri uri = Uri.parse(baseUrl + endpoint);

    body.putIfAbsent("request_from", () => ApiConstants.apiRequestFrom);

    log("Generated Url  $uri");
    log("body is  $body");

    try {
      var request = http.MultipartRequest('POST', uri)
        ..fields.addAll(body)
        ..files.add(
          await http.MultipartFile.fromPath(
            fileFieldName,
            filePath,
            contentType: MediaType('image', 'jpeg'),
          ),
        );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      // log("SIMPLE RESPONSE \n  ${response.body}");
      // log("SIMPLE RESPONSE \n  ${response.statusCode}");
      // log("SIMPLE RESPONSE \n  ${response.body.runtimeType}");
      // log("SIMPLE RESPONSE \n  ${response.headers}");

      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('Slow or No internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException('API did not respond in time', uri.toString());
    } on FormatException {
      throw FormatException('Response was not properly formatted', uri.toString());
    } catch (e) {
      log("ERROR in post after all probable catches \n  $e and ${uri.toString()}");
    }
  }

  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        // var responseJson = utf8.decode(response.bodyBytes);
        // var responseJson = jsonDecode(response.body);
        // log("response my : $response");
        // log("response my reasonPhrase: ${response.reasonPhrase}");
        // log("response my request: ${response.request.toString()}");
        // log("response my url: ${response.request?.url}");
        // log("response my runtimeType: ${response.body.runtimeType}");
        // log("response my length: ${response.body.length}");
        // log("response my toString: ${response.body.toString()}");

        if (response.body.isNotEmpty) {
          Map<String, dynamic> responseJson = Map<String, dynamic>.from(json.decode(response.body));
          return responseJson;
        } else {
          return {
            "responce": {
              "status": "error",
              "message": "Could not fetch data for ${response.request!.url.pathSegments.last}.",
            }
          };
        }
      case 201:
        var responseJson = utf8.decode(response.bodyBytes);
        return responseJson;
      case 400:
        throw BadRequestException(utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 401:
      case 403:
        throw UnAuthorizedException(utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 422:
        throw BadRequestException(utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 500:
      default:
        throw FetchDataException('Error occurred with code : ${response.statusCode}', response.request!.url.toString());
    }
  }

  dynamic _processStripeResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 400:
      case 402:
        // var responseJson = utf8.decode(response.bodyBytes);

        // var responseJson = jsonDecode(response.body);
        Map<String, dynamic> responseJson = Map<String, dynamic>.from(json.decode(response.body));
        return responseJson;
      case 201:
        var responseJson = utf8.decode(response.bodyBytes);
        return responseJson;
      // case 400:
      //   throw BadRequestException(utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 401:
      case 403:
        throw UnAuthorizedException(utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 422:
        throw BadRequestException(utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 500:
      default:
        throw FetchDataException('Error occurred with code : ${response.statusCode}', response.request!.url.toString());
    }
  }

  Future<dynamic> getUnprocessed(String baseUrl, String api) async {
    var uri = Uri.parse(baseUrl + api);
    log("uri -- get: $uri");
    try {
      var response = await http.get(uri).timeout(const Duration(seconds: timeOutDuration));
      // log("SIMPLE RESPONSE \n  ${response.body}");
      return response.body;
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException('API not responded in time', uri.toString());
    } catch (e) {
      log("ERROR in after catch \n  $e}");
    }
  }
}

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:pokemon_api_v1/core/network/api_adapter.dart';
import 'package:pokemon_api_v1/core/error/failure.dart';
import 'package:pokemon_api_v1/core/network/either.dart';

part 'parse_response_body.dart';
part 'logs.dart';

class ApiClient implements ApiAdapter {
  final http.Client _client;
  final String _baseUrl;

  ApiClient({required http.Client client, required String baseUrl})
    : _client = client,
      _baseUrl = baseUrl;

  @override
  Future<Either<Failure, S>> request<S>(
    String path, {
    required S Function(dynamic responseBody) onSuccess,
    HttpMethod method = HttpMethod.get,
    Map<String, String> headers = const {},
    Map<String, String> queryParameters = const {},
    Map<String, dynamic> body = const {},
    bool useApiKey = false,
    Duration timeOut = const Duration(seconds: 10),
  }) async {
    Map<String, dynamic> logs = {};
    // StackTrace? stackTrace;
    try {
      Uri url = Uri.parse(
        path.startsWith('http') ? path : '$_baseUrl$path',
      ).replace(queryParameters: queryParameters);
      headers = {'Content-Type': 'application/json', ...headers};
      final bodyString = jsonEncode(body);
      logs = {
        'url': url.toString(),
        'method': method.name,
        'body': body,
        'startTime': DateTime.now().toString(),
      };
      final response = await switch (method) {
        HttpMethod.get => _client.get(url, headers: headers).timeout(timeOut),
        HttpMethod.post =>
          _client
              .post(url, headers: headers, body: bodyString)
              .timeout(timeOut),
        HttpMethod.patch =>
          _client
              .patch(url, headers: headers, body: bodyString)
              .timeout(timeOut),
        HttpMethod.delete =>
          _client
              .delete(url, headers: headers, body: bodyString)
              .timeout(timeOut),
        HttpMethod.put =>
          _client.put(url, headers: headers, body: bodyString).timeout(timeOut),
      };
      final statusCode = response.statusCode;
      final responseBody = _parseResponseBody(response.body);
      logs = {...logs, 'statusCode': statusCode, 'responseBody': responseBody};

      if (statusCode >= 200 && statusCode < 300) {
        return Rigth(onSuccess(responseBody));
      }
      return Left(ServerFailure('${response.statusCode}'));
    } catch (e) {
      if (e is SocketException || e is http.ClientException) {
        logs = {...logs, 'exception': 'UnknownFailure'};
        return Left(NetworkFailure(e.toString()));
      }
      logs = {...logs, 'exception': 'UnknowFailure'};
      return Left(UnknownFailure(e.toString()));
    } finally {
      logs = {...logs, 'endTime': DateTime.now().toString()};
      // _printLogs(logs, stackTrace);
    }
  }
}

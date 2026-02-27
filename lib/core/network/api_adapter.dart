import 'package:pokemon_api_v1/core/error/failure.dart';
import 'package:pokemon_api_v1/core/network/either.dart';

enum HttpMethod { get, post, patch, delete, put }

abstract class ApiAdapter {
  Future<Either<Failure, S>> request<S>(
    String path, {
    required S Function(dynamic responseBody) onSuccess,
    HttpMethod method = HttpMethod.get,
    Map<String, String> headers = const {},
    Map<String, String> queryParameters = const {},
    Map<String, dynamic> body = const {},
    bool useApiKey = false,
    Duration timeOut = const Duration(seconds: 10),
  });
}

import 'package:pokemon_api_v1/core/constans/app_constans.dart';
import 'package:pokemon_api_v1/core/network/api_client.dart';
import 'package:http/http.dart' as http;

final apiClientProvider = ApiClient(
  client: http.Client(), 
  baseUrl: AppConstans.baseUrl
);

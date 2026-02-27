part of 'api_client.dart';

bool showHttpErrors = true;

void _printLogs(Map<String, dynamic> logs, StackTrace? stackTrace) {
  if (kDebugMode) {
    if (Platform.environment.containsKey('FLUTTER_TEST') &&
        logs.containsKey('exception') &&
        showHttpErrors) {
      print(const JsonEncoder.withIndent(' ').convert(logs));
      print(stackTrace);
    }
    log('''
---------------------------------------------------------------------
${const JsonEncoder.withIndent(' ').convert(logs)}
---------------------------------------------------------------------
        ''', stackTrace: stackTrace);
  }
}

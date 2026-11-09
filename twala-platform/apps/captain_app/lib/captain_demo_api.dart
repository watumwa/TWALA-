import 'dart:convert';
import 'dart:io';

/// Fictional single-server demo only. Android emulator uses 10.0.2.2.
class CaptainDemoApi {
  const CaptainDemoApi();

  static const baseUrl = String.fromEnvironment(
    'TWALA_DEMO_API_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );

  Future<Map<String, dynamic>> getState() => _request('GET', null);

  Future<Map<String, dynamic>> action(Map<String, dynamic> body) =>
      _request('POST', body);

  Future<Map<String, dynamic>> _request(
    String method,
    Map<String, dynamic>? body,
  ) async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 5);
    try {
      final request = await client.openUrl(method, Uri.parse('$baseUrl/api/demo'));
      request.headers.contentType = ContentType.json;
      if (body != null) request.write(jsonEncode(body));
      final response = await request.close().timeout(const Duration(seconds: 8));
      final decoded = jsonDecode(await utf8.decoder.bind(response).join());
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Invalid TWALA demo API response');
      }
      if (response.statusCode >= 400) {
        throw StateError(decoded['error']?.toString() ?? 'Demo action failed');
      }
      return decoded;
    } finally {
      client.close(force: true);
    }
  }
}

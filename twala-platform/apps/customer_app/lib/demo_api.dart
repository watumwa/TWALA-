import 'dart:convert';
import 'dart:io';

/// Local stakeholder-demo connector. Never use for real customer or payment data.
/// Android emulator: --dart-define=TWALA_DEMO_API=http://10.0.2.2:3000
/// iOS simulator: --dart-define=TWALA_DEMO_API=http://localhost:3000
/// Physical phones: use a reachable development-server LAN address.
class TwalaDemoApi {
  TwalaDemoApi({String? baseUrl, HttpClient? client})
      : baseUrl = baseUrl ??
            const String.fromEnvironment(
              'TWALA_DEMO_API',
              defaultValue: 'http://10.0.2.2:3000',
            ),
        _client = client ?? HttpClient();

  final String baseUrl;
  final HttpClient _client;

  Future<Map<String, dynamic>> snapshot() => _request('GET');

  Future<Map<String, dynamic>> createBooking({
    required String passenger,
    required String pickup,
    required String destination,
    required String service,
    required String paymentMethod,
    required int fare,
    String pairing = 'standard',
    String? requestedCaptainId,
  }) =>
      action('create_booking', {
        'passenger': passenger,
        'pickup': pickup,
        'destination': destination,
        'service': service,
        'paymentMethod': paymentMethod,
        'fare': fare,
        'pairing': pairing,
        if (requestedCaptainId != null)
          'requestedCaptainId': requestedCaptainId,
      });

  Future<Map<String, dynamic>> acceptBooking(
          String bookingId, String captainId) =>
      action('accept_booking', {
        'bookingId': bookingId,
        'captainId': captainId,
      });

  Future<Map<String, dynamic>> advanceBooking(String bookingId) =>
      action('advance_booking', {'bookingId': bookingId});

  Future<Map<String, dynamic>> action(
          String name, Map<String, dynamic> fields) =>
      _request('POST', {'action': name, ...fields});

  Future<Map<String, dynamic>> _request(
      String method, [Map<String, dynamic>? payload]) async {
    final uri = Uri.parse('${baseUrl.replaceFirst(RegExp(r"/+$"), "")}/api/demo');
    final request = await _client.openUrl(method, uri);
    request.headers.set(HttpHeaders.acceptHeader, 'application/json');
    if (payload != null) {
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(payload));
    }
    final response = await request.close();
    final body = await utf8.decoder.bind(response).join();
    final decoded = jsonDecode(body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid TWALA demo API response');
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException(
        decoded['error']?.toString() ?? 'TWALA demo API error',
        uri: uri,
      );
    }
    return decoded;
  }

  void close() => _client.close();
}

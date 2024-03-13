import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

/// adds type casting, throwing on non-2xx result,
/// abstracts body encoding, jsonDecode, enforce
/// query param strict type and more
class SmartApiClient {
  final http.Client _client = http.Client();
  final String host;

  SmartApiClient(this.host);

  Future<T> get<T extends Object?>(
    String path, {
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) =>
      _client
          .get(
            Uri.https(host, path, queryParams),
            headers: headers,
          )
          .then(_handleResponse<T>);

  Future<T> put<T extends Object?>(
    String path, {
    Object? body,
    Map<String, String> queryParams = const {},
  }) =>
      _client.put(
        Uri.https(host, path, queryParams),
        body: jsonEncode(body),
        headers: {
          if (body != null) 'Content-Type': 'application/json',
        },
      ).then(_handleResponse<T>);

  Future<T> post<T extends Object?>(
    String path, {
    Object? body,
    Map<String, String> queryParams = const {},
    Map<String, String> headers = const {},
  }) =>
      _client.post(
        Uri.https(host, path, queryParams),
        body: jsonEncode(body),
        headers: {
          if (body != null) 'Content-Type': 'application/json',
          ...headers,
        },
      ).then(_handleResponse<T>);

  Future<T> delete<T extends Object?>(
    String path, {
    Object? body,
    Map<String, String> queryParams = const {},
  }) =>
      _client.delete(
        Uri.https(host, path, queryParams),
        body: jsonEncode(body),
        headers: {
          if (body != null) 'Content-Type': 'application/json',
        },
      ).then(_handleResponse<T>);

  Future<T> _handleResponse<T extends Object?>(
    http.Response response,
  ) async {
    late final dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (err) {
      body = null;
    }
    // ignore: avoid_print
    print(response.request?.url);
    if (response.statusCode.toString().startsWith('2')) return body as T;
    if (body is! Map) throw response.statusCode;
    throw <String>["An unknown error occurred."];
  }
}

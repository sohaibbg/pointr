import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsWrapper<T> {
  const SharedPrefsWrapper({
    required this.key,
    required this.fromJson,
    required this.extractId,
  });

  static SharedPreferences? _sp;
  final String key;
  final T Function(dynamic json) fromJson;
  final Object Function(T e) extractId;

  Future<void> insert(T e) async {
    _sp ??= await SharedPreferences.getInstance();
    final id = extractId(e);
    await _sp!.setString(
      "$key.$id",
      jsonEncode(e),
    );
  }

  Future<List<T>> getAll() async {
    _sp ??= await SharedPreferences.getInstance();
    final source = _sp!.getString(key);
    if (source == null) return [];
    final json = jsonDecode(source) as List;
    return json.map(fromJson).toList();
  }
}

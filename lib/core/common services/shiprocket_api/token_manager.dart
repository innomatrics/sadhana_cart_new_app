import 'dart:convert';

class TokenManager {
  String? _token;

  String? get token => _token;

  void setToken(String token) {
    _token = token;
  }

  bool isTokenExpired() {
    if (_token == null) return true;
    try {
      final parts = _token!.split('.');
      if (parts.length != 3) return true;

      final payload =
          json.decode(
                utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
              )
              as Map<String, dynamic>;
      final exp = payload['exp'] as int;
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      return now >= exp;
    } catch (_) {
      return true;
    }
  }
}

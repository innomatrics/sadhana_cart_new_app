import 'package:flutter_riverpod/flutter_riverpod.dart';

final tokenProvider = StateProvider<String?>((ref) => null);
const String tokenBox = 'auth_token_box';
const String tokenKey = 'auth_token';
const String expiryKey = 'auth_token_expiry';

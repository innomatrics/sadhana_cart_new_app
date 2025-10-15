//footwear

import 'package:flutter_riverpod/legacy.dart';

final footwearColorSelection = StateProvider<int>((ref) {
  final ink = ref.keepAlive();
  Future.delayed(const Duration(minutes: 3), () => ink.close());
  return 0;
});

final footWearSizeSelection = StateProvider<int>((ref) {
  final ink = ref.keepAlive();
  Future.delayed(const Duration(minutes: 3), () => ink.close());
  return 0;
});

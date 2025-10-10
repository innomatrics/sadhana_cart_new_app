import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/helper/hive_helper.dart';

final onboardProvider = AsyncNotifierProvider<OnboardNotifier, bool>(
  OnboardNotifier.new,
);

class OnboardNotifier extends AsyncNotifier<bool> {
  static const String hasSeenOnboarding = "hasSeenOnboarding";

  @override
  Future<bool> build() async {
    final seen = HiveHelper.getLocalData<bool>(key: hasSeenOnboarding) ?? false;
    return seen;
  }

  Future<void> setSeen() async {
    await HiveHelper.storeLocalData<bool>(key: hasSeenOnboarding, value: true);
    state = const AsyncValue.data(true);
  }
}

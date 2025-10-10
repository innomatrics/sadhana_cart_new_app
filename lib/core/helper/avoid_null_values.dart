class AvoidNullValues {
  static Map<String, dynamic> removeNullValuesDeep(Map<String, dynamic> data) {
    final newMap = <String, dynamic>{};
    data.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        final nested = removeNullValuesDeep(value);
        if (nested.isNotEmpty) {
          newMap[key] = nested;
        }
      } else if (value != null) {
        newMap[key] = value;
      }
    });
    return newMap;
  }
}

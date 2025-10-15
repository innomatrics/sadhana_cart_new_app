class StringHelper {
  static String maskCardNumber(String cardNumber) {
    final cleaned = cardNumber.replaceAll(RegExp(r'\s+'), '');
    if (cleaned.length < 4) return '****';

    final last4 = cleaned.substring(cleaned.length - 4);
    return '**** **** **** $last4';
  }

  static String cleanCardNumber(String cardNumber) {
    if (cardNumber.contains('*')) {
      return '';
    }
    return cardNumber.replaceAll(' ', '');
  }

  static String firstLetterCapital({required String input}) {
    if (input.isEmpty) return "";
    return input[0].toUpperCase() + input.substring(1);
  }
}

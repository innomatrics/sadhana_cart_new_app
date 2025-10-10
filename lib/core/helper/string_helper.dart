import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:sadhana_cart/core/constants/app_images.dart';

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

  static String getImageByCardBrand({required CardType card}) {
    switch (card) {
      case CardType.visa:
        return CreditCardImages.visa;

      case CardType.mastercard:
        return CreditCardImages.masterCard;

      case CardType.americanExpress:
        return CreditCardImages.americanExpress;

      case CardType.discover:
        return CreditCardImages.discover;

      case CardType.mir:
        return CreditCardImages.mir;

      case CardType.unionpay:
        return CreditCardImages.unionpay;

      default:
        return CreditCardImages.masterCard;
    }
  }

  static String firstLetterCapital({required String input}) {
    if (input.isEmpty) return "";
    return input[0].toUpperCase() + input.substring(1);
  }
}

enum CreditCardType {
  otherBrand,
  mastercard,
  visa,
  rupay,
  americanExpress,
  unionpay,
  discover,
  elo,
  hipercard,
  mir,
}

extension CreditCardTypeExtension on CreditCardType {
  String get label {
    switch (this) {
      case CreditCardType.americanExpress:
        return "American Express";
      case CreditCardType.discover:
        return "Discover";
      case CreditCardType.elo:
        return "Elo";
      case CreditCardType.hipercard:
        return "Hipercard";
      case CreditCardType.mir:
        return "Mir";
      case CreditCardType.rupay:
        return "Rupay";
      case CreditCardType.unionpay:
        return "Unionpay";
      case CreditCardType.mastercard:
        return "Mastercard";
      case CreditCardType.visa:
        return "Visa";
      case CreditCardType.otherBrand:
        return "Other";
    }
  }
}

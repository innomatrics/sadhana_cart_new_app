import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:sadhana_cart/core/constants/app_images.dart';

enum CardEnums {
  americanExpress,
  discover,
  elo,
  hipercard,
  mir,
  rupay,
  unionpay,
  masterCard,
  visa,
}

extension CardEnumsExntesion on CardEnums {
  String get label {
    switch (this) {
      case CardEnums.americanExpress:
        return "American Express";
      case CardEnums.discover:
        return "Discover";
      case CardEnums.elo:
        return "Elo";
      case CardEnums.hipercard:
        return "Hipercard";
      case CardEnums.mir:
        return "Mir";
      case CardEnums.rupay:
        return "Rupay";
      case CardEnums.unionpay:
        return "Unionpay";
      case CardEnums.masterCard:
        return "Master Card";
      case CardEnums.visa:
        return "Visa";
    }
  }
}

extension CardEnumsExtenion on CardEnums {
  String get image {
    switch (this) {
      case CardEnums.americanExpress:
        return CreditCardImages.americanExpress;
      case CardEnums.discover:
        return CreditCardImages.discover;
      case CardEnums.elo:
        return CreditCardImages.elo;
      case CardEnums.hipercard:
        return CreditCardImages.hipercard;
      case CardEnums.mir:
        return CreditCardImages.mir;
      case CardEnums.rupay:
        return CreditCardImages.rupay;
      case CardEnums.unionpay:
        return CreditCardImages.unionpay;
      case CardEnums.masterCard:
        return CreditCardImages.masterCard;
      case CardEnums.visa:
        return CreditCardImages.visa;
    }
  }
}

CardType mapCardEnumToCardType(CardEnums cardEnum) {
  switch (cardEnum) {
    case CardEnums.visa:
      return CardType.visa;
    case CardEnums.masterCard:
      return CardType.mastercard;
    case CardEnums.americanExpress:
      return CardType.americanExpress;
    case CardEnums.discover:
      return CardType.discover;
    case CardEnums.mir:
      return CardType.mir;
    case CardEnums.unionpay:
      return CardType.unionpay;
    default:
      return CardType.mastercard;
  }
}

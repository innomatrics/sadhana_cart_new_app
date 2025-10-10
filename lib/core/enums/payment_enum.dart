enum PaymentEnum { cash, online }

extension PaymentEnumExtension on PaymentEnum {
  String get label {
    switch (this) {
      case PaymentEnum.cash:
        return "Cash";
      case PaymentEnum.online:
        return "Online";
    }
  }
}

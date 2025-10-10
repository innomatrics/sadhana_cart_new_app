import 'package:sadhana_cart/core/common%20model/banner/banner_model.dart';

class AppImages {
  //cart
  static const String emptyCart = "assets/images/empty_cart.png";
  //favorite
  static const String emptyFavorite = "assets/images/no-favorites.png";
  //images
  static const String onboard = "assets/images/onboard.png";
  static const String onboard1 = "assets/images/onboard1.png";
  static const String onboard2 = "assets/images/onboard2.png";
  static const String onboard3 = "assets/images/onboard3.png";

  static const String appLogo = "assets/images/logo.png";

  //lottie
  static const String successLottie = "assets/lottie/success.json";

  //order status
  static const String orderCompleted = "assets/order/order_completed.png";
  static const String orderPending = "assets/order/order_pending.png";
  static const String orderProcessing = "assets/order/order_processing.png";
  static const String orderShipped = "assets/order/order_shipped.png";
  static const String orderDelivered = "assets/order/order-delivered.png";
  static const String orderCanceled = "assets/order/order_canceled.png";

  //order image with white color
  static const String orderCanceledWhite =
      "assets/order/order_canceled_white.png";
  static const String orderPendingWhite =
      "assets/order/order_pending_white.png";
  static const String orderCompletedWhite =
      "assets/order/order_completed_white.png";
  static const String orderShippedWhite =
      "assets/order/order_shipped_white.png";
  static const String orderProcessingWhite =
      "assets/order/order_processing_white.png";
  static const String orderDeliveredWhite =
      "assets/order/order-delivered_white.png";
  //vectors
  static const String googleSvg = "assets/vectors/google.svg";
  static const String appleSvg = "assets/vectors/apple.svg";

  //icons
  static const String drawerIcons = "assets/icons/drawer.png";

  //testing purpose only
  static const String carousel = "assets/images/carousel.png";

  static const String noProfile = "assets/images/noprofile.jpg";

  static List<BannerModel> bannerImages = [
    BannerModel(
      bannerId: "1",
      bannerName: "banner1",
      image: carousel,
      productId: "1",
      status: "",
    ),
    BannerModel(
      bannerId: "2",
      bannerName: "banner2",
      image: onboard,
      productId: "3",
      status: "",
    ),
  ];

  //credit card images
  static const String creditCard = "assets/images/credit_card.png";
  static const String money = "assets/images/money.png";
  static const String more = "assets/images/more.png";
}

class CreditCardImages {
  static const String americanExpress = "assets/cards/american.png";
  static const String discover = "assets/cards/discover.jpg";
  static const String elo = "assets/cards/elo.jpg";
  static const String hipercard = "assets/cards/hipercard.png";
  static const String mir = "assets/cards/mir.png";
  static const String rupay = "assets/cards/rupay.png";
  static const String unionpay = "assets/cards/unionpay.png";
  static const String masterCard = "assets/cards/mastercard.png";
  static const String visa = "assets/cards/visa.png";
}

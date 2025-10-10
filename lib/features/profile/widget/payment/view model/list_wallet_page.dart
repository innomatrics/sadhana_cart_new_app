import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/enums/card_colors_enum.dart';
import 'package:sadhana_cart/core/helper/string_helper.dart';
import 'package:sadhana_cart/features/profile/widget/payment/view%20model/wallet_loading_page.dart';
import 'package:sadhana_cart/features/profile/widget/payment/view%20model/wallet_notifier.dart';

class ListWalletPage extends ConsumerStatefulWidget {
  const ListWalletPage({super.key});

  @override
  ConsumerState<ListWalletPage> createState() => _ListWalletPageState();
}

class _ListWalletPageState extends ConsumerState<ListWalletPage> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(walletStateProvider.notifier).fetchWallet();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final walletData = ref.watch(walletStateProvider);

    if (walletData.isLoading) {
      return const WalletLoadingPage();
    }
    if (walletData.wallet.isEmpty) {
      return const Expanded(child: Center(child: Text("No Wallet Added")));
    }

    if (walletData.wallet.length == 1) {
      final cardNumber = StringHelper.cleanCardNumber(
        walletData.wallet.first.maskedNumber,
      );
      final cardType = CardType.values.firstWhere(
        (card) => card.name == walletData.wallet.first.cardBrand,
      );
      final cardColor = CardColorsEnum.values.firstWhere(
        (e) => e.label == walletData.wallet.first.color,
      );
      final Color color = cardColor.color;
      final cardImage = StringHelper.getImageByCardBrand(card: cardType);
      return CreditCardWidget(
        cardBgColor: color,
        enableFloatingCard: false,
        bankName: '',
        cardNumber: cardNumber,
        expiryDate: walletData.wallet.first.expiryDate,
        cardHolderName: walletData.wallet.first.cardHolderName,
        cvvCode: walletData.wallet.first.paymentToken,
        obscureCardNumber: true,
        obscureCardCvv: true,
        isHolderNameVisible: true,
        isSwipeGestureEnabled: true,
        showBackView: false,
        cardType: cardType,
        onCreditCardWidgetChange: (_) {},
        customCardTypeIcons: <CustomCardTypeIcon>[
          CustomCardTypeIcon(
            cardType: cardType,
            cardImage: Image.asset(cardImage, height: 48, width: 48),
          ),
        ],
      );
    }
    return CarouselSlider(
      items: walletData.wallet.map((e) {
        final cardNumber = StringHelper.cleanCardNumber(e.maskedNumber);
        final cardType = CardType.values.firstWhere(
          (card) => card.name == e.cardBrand,
        );
        final cardImage = StringHelper.getImageByCardBrand(card: cardType);
        final cardColor = CardColorsEnum.values.firstWhere(
          (co) => co.label == e.color,
        );
        final color = cardColor.color;
        return CreditCardWidget(
          cardBgColor: color,
          enableFloatingCard: false,
          bankName: '',
          cardNumber: cardNumber,
          expiryDate: e.expiryDate,
          cardHolderName: e.cardHolderName,
          cvvCode: e.paymentToken,
          showBackView: false,
          obscureCardNumber: true,
          obscureCardCvv: true,
          isHolderNameVisible: true,
          isSwipeGestureEnabled: true,
          cardType: cardType,
          onCreditCardWidgetChange: (_) {},
          customCardTypeIcons: <CustomCardTypeIcon>[
            CustomCardTypeIcon(
              cardType: cardType,
              cardImage: Image.asset(cardImage, height: 48, width: 48),
            ),
          ],
        );
      }).toList(),
      options: CarouselOptions(
        height: size.height * 0.3,
        autoPlayInterval: const Duration(seconds: 4),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        enlargeCenterPage: true,
        viewportFraction: 1,
        aspectRatio: 16 / 9,
        scrollDirection: Axis.horizontal,
        enableInfiniteScroll: true,
        pauseAutoPlayOnTouch: true,
        scrollPhysics: const BouncingScrollPhysics(),
      ),
    );
  }
}

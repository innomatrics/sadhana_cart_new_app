import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/disposable/disposable.dart';
import 'package:sadhana_cart/core/enums/card_colors_enum.dart';
import 'package:sadhana_cart/core/enums/card_enums.dart';
import 'package:sadhana_cart/core/helper/navigation_helper.dart';
import 'package:sadhana_cart/core/widgets/custom_drop_down.dart';
import 'package:sadhana_cart/core/widgets/custom_elevated_button.dart';
import 'package:sadhana_cart/core/widgets/loader.dart';
import 'package:sadhana_cart/features/profile/widget/payment/service/wallet_service.dart';
import 'package:sadhana_cart/features/profile/widget/payment/view%20model/wallet_notifier.dart';

class AddPaymentMethod extends StatefulWidget {
  const AddPaymentMethod({super.key});

  @override
  State<AddPaymentMethod> createState() => _AddPaymentMethodState();
}

class _AddPaymentMethodState extends State<AddPaymentMethod> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Add Money to Wallet',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: Consumer(
          builder: (context, ref, child) {
            final loader = ref.watch(walletLoader);
            final cardBrand = ref.watch(creditCardTypeProvider).name;
            final color = ref.watch(creditCardColorProvider).label;
            return CustomElevatedButton(
              onPressed: () async {
                final isValid = formKey.currentState!.validate();
                if (!isValid) return;
                final bool isSuccess = await WalletService.addWallet(
                  color: color,
                  context: context,
                  maskedNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  paymentToken: cvvCode,
                  cardBrand: cardBrand,
                  last4Digits: cvvCode.substring(cvvCode.length - 4),
                  ref: ref,
                );
                if (isSuccess && context.mounted) {
                  navigateBack(context: context);
                }
              },
              child: loader
                  ? const Loader()
                  : const Text(
                      "Add Your Card",
                      style: customElevatedButtonTextStyle,
                    ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Consumer(
              builder: (context, ref, child) {
                final cardType = ref.watch(creditCardTypeProvider);
                final cardImage = ref.watch(creditCardImageProvider);
                final cardColor = ref.watch(creditCardColorProvider);
                return CreditCardWidget(
                  cardBgColor: cardColor.color,
                  enableFloatingCard: false,
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  bankName: '',
                  cardType: cardType,
                  showBackView: isCvvFocused,
                  obscureCardNumber: true,
                  obscureCardCvv: true,
                  isHolderNameVisible: true,
                  isSwipeGestureEnabled: true,
                  onCreditCardWidgetChange: (CreditCardBrand _) {},
                  customCardTypeIcons: <CustomCardTypeIcon>[
                    CustomCardTypeIcon(
                      cardType: cardType,
                      cardImage: Image.asset(
                        cardImage.image,
                        height: 48,
                        width: 48,
                      ),
                    ),
                  ],
                );
              },
            ),

            CreditCardForm(
              cardNumber: cardNumber,
              cvvCode: cvvCode,
              isHolderNameVisible: true,
              isCardNumberVisible: true,
              isExpiryDateVisible: true,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              formKey: formKey,
              onCreditCardModelChange: onCreditCardModelChange,
              inputConfiguration: const InputConfiguration(
                cardNumberDecoration: InputDecoration(
                  labelText: 'Number',
                  hintText: 'XXXX XXXX XXXX XXXX',
                ),
                expiryDateDecoration: InputDecoration(
                  labelText: 'Expired Date',
                  hintText: 'MM/YY',
                ),
                cvvCodeDecoration: InputDecoration(
                  labelText: 'CVV',
                  hintText: 'XXX',
                ),
                cardHolderDecoration: InputDecoration(labelText: 'Card Holder'),
              ),
            ),
            const SizedBox(height: 10),
            Consumer(
              builder: (context, ref, child) {
                final creditCardType = ref.watch(creditCardImageProvider);
                final items = CardEnums.values
                    .map(
                      (e) => DropdownMenuItem(value: e, child: Text(e.label)),
                    )
                    .toList();
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: CustomDropDown<CardEnums>(
                    labelText: "Card Type",
                    items: items,
                    value: creditCardType,
                    onChanged: (CardEnums? value) {
                      if (value == null) return;
                      log("Card Type: $value");
                      ref.read(creditCardImageProvider.notifier).state = value;
                      final mappedCardType = mapCardEnumToCardType(value);
                      ref.read(creditCardTypeProvider.notifier).state =
                          mappedCardType;
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 15),
            Consumer(
              builder: (context, ref, child) {
                final color = ref.watch(creditCardColorProvider);
                final items = CardColorsEnum.values
                    .map(
                      (e) => DropdownMenuItem<CardColorsEnum>(
                        value: e,
                        child: Text(e.label),
                      ),
                    )
                    .toList();
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: CustomDropDown<CardColorsEnum>(
                    items: items,
                    onChanged: (value) {
                      ref.read(creditCardColorProvider.notifier).state = value!;
                    },
                    value: color,
                    labelText: "Card Color",
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/colors/app_color.dart';
import 'package:sadhana_cart/core/disposable/disposable.dart';

class CheckoutTotalAmountContainer extends StatelessWidget {
  const CheckoutTotalAmountContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(30),
      width: size.width * 1,
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border.fromBorderSide(BorderSide.none),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Consumer(
        builder: (context, ref, child) {
          final index = ref.watch(orderStepperPageProvider);
          return Column(
            spacing: index == 1 ? 10 : 20,
            children: [
              _price(text: "Product Price", value: "1000"),
              _customDivider(),
              _price(text: "Shipping", value: "Freeship"),
              _customDivider(),
              _price(
                text: "Subtotal",
                color: Colors.black,
                fontWight: FontWeight.bold,
                value: "1000",
              ),
              _customDivider(),
            ],
          );
        },
      ),
    );
  }

  Widget _price({
    required String text,
    required String value,
    Color? color = const Color(0xff8A8A8F),
    FontWeight? fontWight = FontWeight.w400,
  }) {
    final TextStyle textStyle = TextStyle(
      color: color,
      fontSize: 16,
      fontWeight: fontWight,
    );
    const TextStyle valueStyle = TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: textStyle),
        Text(value, style: valueStyle),
      ],
    );
  }

  Widget _customDivider() {
    return const Divider(color: AppColor.tileColor, thickness: 1.2);
  }
}

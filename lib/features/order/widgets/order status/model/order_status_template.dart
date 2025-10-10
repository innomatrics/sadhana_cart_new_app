import 'package:flutter/material.dart';
import 'package:sadhana_cart/core/constants/app_images.dart';
import 'package:sadhana_cart/core/constants/constants.dart';
import 'package:sadhana_cart/core/enums/order_status_enums.dart';
import 'package:sadhana_cart/core/widgets/custom_elevated_button.dart';

class OrderStatusTemplate extends StatelessWidget {
  final String status;
  const OrderStatusTemplate({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    const TextStyle customTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.w400,
    );
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () {},
          child: const Text("Go to Home", style: customElevatedButtonTextStyle),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          status,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 50),
          Text(
            "Order $status",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          if (status == OrderStatusEnums.pending.label)
            Column(
              children: [
                Center(
                  child: SizedBox(
                    height: size.height * 0.3,
                    width: size.width * 0.5,
                    child: Image.asset(
                      AppImages.orderPending,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const Text(Constants.orderPendingText, style: customTextStyle),
              ],
            )
          else if (status == OrderStatusEnums.processing.label)
            Column(
              children: [
                Center(
                  child: SizedBox(
                    height: size.height * 0.3,
                    width: size.width * 0.5,
                    child: Image.asset(
                      AppImages.orderProcessing,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const Text(
                  Constants.orderProcessingText,
                  style: customTextStyle,
                ),
              ],
            )
          else if (status == OrderStatusEnums.delivered.label)
            Column(
              children: [
                Center(
                  child: SizedBox(
                    height: size.height * 0.3,
                    width: size.width * 0.5,
                    child: Image.asset(
                      AppImages.orderDelivered,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const Text(
                  Constants.orderDeliveredText,
                  style: customTextStyle,
                ),
              ],
            )
          else if (status == OrderStatusEnums.shipped.label)
            Column(
              children: [
                Center(
                  child: SizedBox(
                    height: size.height * 0.3,
                    width: size.width * 0.5,
                    child: Image.asset(
                      AppImages.orderShipped,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const Text(Constants.orderShippedText, style: customTextStyle),
              ],
            )
          else if (status == OrderStatusEnums.cancelled.label)
            Column(
              children: [
                Center(
                  child: SizedBox(
                    height: size.height * 0.3,
                    width: size.width * 0.5,
                    child: Image.asset(
                      AppImages.orderCanceled,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Text(
                  Constants.orderCancelledText,
                  style: customTextStyle,
                ),
              ],
            )
          else
            Column(
              children: [
                Center(
                  child: SizedBox(
                    height: size.height * 0.3,
                    width: size.width * 0.5,
                    child: Image.asset(
                      AppImages.orderProcessing,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Text(
                  Constants.orderProcessingText,
                  style: customTextStyle,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

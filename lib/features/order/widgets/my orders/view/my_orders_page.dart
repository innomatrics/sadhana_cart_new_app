import 'package:flutter/material.dart';
import 'package:sadhana_cart/core/enums/order_status_enums.dart';
import 'package:sadhana_cart/core/widgets/custom_order_status_button.dart';
import 'package:sadhana_cart/features/order/widgets/my%20orders/view/custom_orders_list_tile.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "My Orders",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          SizedBox(
            height: 60,
            width: double.infinity,
            child: ListView.builder(
              itemCount: OrderStatusEnums.values.length,
              scrollDirection: Axis.horizontal,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return CustomOrderStatusButton(index: index);
              },
            ),
          ),
          const SizedBox(height: 10),
          const Expanded(child: CustomOrdersListTile()),
        ],
      ),
    );
  }
}

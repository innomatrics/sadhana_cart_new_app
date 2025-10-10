import 'package:flutter/material.dart';
import 'package:sadhana_cart/features/profile/widget/address/model/address_model.dart';

class UserAddressTile extends StatelessWidget {
  final AddressModel address;
  final EdgeInsetsGeometry? margin;
  final double? height;
  const UserAddressTile({
    super.key,
    required this.address,
    this.margin = const EdgeInsets.all(16),
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final icons = IconData(address.icon ?? 0, fontFamily: 'MaterialIcons');
    final Size size = MediaQuery.of(context).size;
    return Container(
      margin: margin,
      padding: const EdgeInsets.all(12),
      height: height ?? size.height * 0.15,
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(icons, size: 40),
            title: Text(address.title ?? ""),
            subtitle: Text(address.city),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "${address.streetName} ${address.city}, ${address.state},",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

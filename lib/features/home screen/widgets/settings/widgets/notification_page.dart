import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/disposable/disposable.dart';
import 'package:sadhana_cart/core/widgets/custom_switch_tile.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Notification Settings",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Consumer(
          builder: (context, ref, child) {
            final showNotify = ref.watch(showNotificationProvider);
            final showLockedNotify = ref.watch(
              showLockedScreennotificationProvider,
            );
            return Column(
              children: [
                CustomSwitchTile(
                  value: showNotify,
                  title: "Show Notifications",
                  onChanged: (value) =>
                      ref.read(showNotificationProvider.notifier).state = value,
                ),
                CustomSwitchTile(
                  value: showLockedNotify,
                  title: "Show Locked Screen Notification",
                  onChanged: (value) =>
                      ref
                              .read(
                                showLockedScreennotificationProvider.notifier,
                              )
                              .state =
                          value,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

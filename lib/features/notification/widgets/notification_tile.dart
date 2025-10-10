import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sadhana_cart/core/colors/app_color.dart';
import 'package:sadhana_cart/core/constants/app_images.dart';
import 'package:sadhana_cart/core/helper/navigation_helper.dart';
import 'package:sadhana_cart/features/notification/view%20model/notification_notifier.dart';

class NotificationTile extends ConsumerWidget {
  const NotificationTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notification = ref.watch(notificationProvider);
    final Size size = MediaQuery.of(context).size;

    if (notification.isEmpty) {
      return const Expanded(child: Center(child: Text("No Notification")));
    }
    return Expanded(
      child: ListView.builder(
        itemCount: notification.length,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          final notify = notification[index];
          return GestureDetector(
            onTap: () {
              navigateWithRoute(context: context, screenPath: notify.screen);
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              height: size.height * 0.1,
              width: size.width * 1,
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
              child: Slidable(
                closeOnScroll: true,
                direction: Axis.horizontal,
                endActionPane: ActionPane(
                  dragDismissible: true,
                  closeThreshold: 0.5,
                  motion: const BehindMotion(),
                  children: [
                    SlidableAction(
                      icon: Icons.delete,
                      label: "Delete",
                      backgroundColor: AppColor.onboardButtonColor,
                      borderRadius: BorderRadius.circular(12),
                      autoClose: true,
                      onPressed: (context) async {
                        ref
                            .read(notificationProvider.notifier)
                            .deleteNotification(index);
                      },
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    notify.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  subtitle: Text(
                    notify.body,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  leading: Image.asset(
                    AppImages.appLogo,
                    height: 40,
                    width: 40,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

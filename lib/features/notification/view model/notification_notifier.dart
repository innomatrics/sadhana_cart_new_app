import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:sadhana_cart/core/common%20model/notification/notification_model.dart';

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, List<NotificationModel>>((ref) {
      return NotificationNotifier();
    });

class NotificationNotifier extends StateNotifier<List<NotificationModel>> {
  NotificationNotifier() : super([]) {
    _loadNotifications();
  }

  final Box<NotificationModel> _box = Hive.box<NotificationModel>(
    'notificationBox',
  );

  void _loadNotifications() {
    state = _box.values.toList().reversed.toList();
  }

  void addNotification(NotificationModel notification) {
    _box.add(notification);
    _loadNotifications();
  }

  void deleteNotification(int index) {
    _box.deleteAt(index);
    _loadNotifications();
  }

  void clearAll() {
    _box.clear();
    _loadNotifications();
  }
}

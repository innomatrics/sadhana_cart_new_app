import 'dart:convert';
import 'package:hive/hive.dart';

part 'notification_model.g.dart';

@HiveType(typeId: 8)
class NotificationModel extends HiveObject {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String body;
  @HiveField(2)
  final String date;
  @HiveField(3)
  final String screen;
  NotificationModel({
    required this.title,
    required this.body,
    required this.date,
    required this.screen,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'body': body,
      'date': date,
      'screen': screen,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      title: map['title'] as String,
      body: map['body'] as String,
      date: map['date'] as String,
      screen: map['screen'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String conversationId;
  final String message;
  final String senderId;
  final String senderName;
  final String senderType;
  final String recipientId;
  final String recipientName;
  final String status;
  final DateTime timestamp;

  Message({
    required this.conversationId,
    required this.message,
    required this.senderId,
    required this.senderName,
    required this.senderType,
    required this.recipientId,
    required this.recipientName,
    required this.status,
    required this.timestamp,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      conversationId: map['conversationId'] ?? '',
      message: map['message'] ?? '',
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      senderType: map['senderType'] ?? 'user',
      recipientId: map['recipientId'] ?? '',
      recipientName: map['recipientName'] ?? '',
      status: map['status'] ?? 'sent',
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'conversationId': conversationId,
    'message': message,
    'senderId': senderId,
    'senderName': senderName,
    'senderType': senderType,
    'recipientId': recipientId,
    'recipientName': recipientName,
    'status': status,
    'timestamp': Timestamp.fromDate(timestamp),
  };
}

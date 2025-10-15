import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sadhana_cart/core/common model/chat/chat_model.dart';
import 'package:sadhana_cart/core/common services/chat_support/chat_service.dart';

final chatProvider = StateNotifierProvider<ChatNotifier, List<Message>>(
  (ref) => ChatNotifier(ref),
);

class ChatNotifier extends StateNotifier<List<Message>> {
  final Ref ref;
  ChatNotifier(this.ref) : super([]);

  /// 🔹 Listen to all messages in a conversation
  Stream<List<Message>> listenMessages(String conversationId) {
    final stream = ChatService.getMessages(conversationId);
    stream.listen((messages) {
      state = messages; // update state whenever Firestore changes
    });
    return stream;
  }

  /// 🔹 Send a message into "messages" collection
  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String senderName,
    required String recipientId,
    required String recipientName,
    required String messageText,
  }) async {
    final message = Message(
      conversationId: conversationId,
      message: messageText,
      senderId: senderId,
      senderName: senderName,
      senderType: "user", // default user side
      recipientId: recipientId,
      recipientName: recipientName,
      status: "sent",
      timestamp: DateTime.now(),
    );

    // Optimistically update UI
    state = [...state, message];

    try {
      await ChatService.sendMessage(
        conversationId: conversationId,
        senderId: senderId,
        senderName: senderName,
        senderType: "user",
        recipientId: recipientId,
        recipientName: recipientName,
        message: messageText,
      );
    } catch (e) {
      // Rollback on failure
      state = state.where((m) => m != message).toList();
      rethrow;
    }
  }
}

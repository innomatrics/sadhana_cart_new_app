import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sadhana_cart/core/common%20model/chat/chat_model.dart';

class ChatService {
  static final conversationsRef = FirebaseFirestore.instance.collection(
    'conversations',
  );

  /// Generate or return an existing conversation document
  static Future<String> getOrCreateConversation(String recipientId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    final conversationId = user.uid.hashCode <= recipientId.hashCode
        ? "${user.uid}_$recipientId"
        : "${recipientId}_${user.uid}";

    final docRef = conversationsRef.doc(conversationId);
    final doc = await docRef.get();

    if (!doc.exists) {
      // Create conversation document
      await docRef.set({
        'participants': [user.uid, recipientId],
        'lastMessage': '',
        'lastTimestamp': FieldValue.serverTimestamp(),
      });
    }

    return conversationId;
  }

  /// Send a message in a conversation
  static Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String senderName,
    required String recipientId,
    required String recipientName,
    required String message,
    String senderType = "user", // or "admin"
  }) async {
    final msgData = {
      "senderId": senderId,
      "senderName": senderName,
      "recipientId": recipientId,
      "recipientName": recipientName,
      "senderType": senderType,
      "message": message,
      "status": "sent",
      "timestamp": FieldValue.serverTimestamp(),
    };

    final messagesRef = conversationsRef
        .doc(conversationId)
        .collection('messages');

    await messagesRef.add(msgData);

    // Update conversation with last message
    await conversationsRef.doc(conversationId).update({
      'lastMessage': message,
      'lastTimestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Stream all messages in a conversation
  static Stream<List<Message>> getMessages(String conversationId) {
    final messagesRef = conversationsRef
        .doc(conversationId)
        .collection('messages');

    return messagesRef
        .orderBy("timestamp")
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Message.fromMap(doc.data())).toList(),
        );
  }

  /// Stream all conversations for the current user
  static Stream<List<Map<String, dynamic>>> getUserConversations() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    return conversationsRef
        .where('participants', arrayContains: user.uid)
        .orderBy('lastTimestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}

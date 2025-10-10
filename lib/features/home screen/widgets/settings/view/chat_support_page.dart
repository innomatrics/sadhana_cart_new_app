import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sadhana_cart/core/common%20services/chat_support/chat_notifier.dart';
import 'package:sadhana_cart/core/helper/dat_time_helper.dart';
import 'package:sadhana_cart/core/widgets/snack_bar.dart';

class ChatSupportPage extends ConsumerStatefulWidget {
  final String chatId;
  const ChatSupportPage({super.key, required this.chatId});

  @override
  ConsumerState<ChatSupportPage> createState() => _ChatSupportPageState();
}

class _ChatSupportPageState extends ConsumerState<ChatSupportPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    // final user = FirebaseAuth.instance.currentUser;
    // if (user != null) {
    //   log("ChatSupportPage: Current User UID: ${user.uid}");
    //   log("ChatSupportPage: Current User Name: ${user.displayName}");
    //   log("ChatSupportPage: Current User Email: ${user.email}");
    // } else {
    //   log("ChatSupportPage: No user is logged in");
    // }
    // Start listening messages
    ref.read(chatProvider.notifier).listenMessages(widget.chatId);
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSending = true);

    try {
      await ref
          .read(chatProvider.notifier)
          .sendMessage(
            conversationId: widget.chatId,
            senderId: currentUserId,
            senderName:
                FirebaseAuth.instance.currentUser?.displayName ?? "User",
            recipientId: "support", // adjust as needed
            recipientName: "Support",
            messageText: text,
          );

      _messageController.clear();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent + 60,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      if (mounted) {
        showCustomSnackbar(
          context: context,
          message: e.toString(),
          type: ToastType.error,
        );
      }
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Chat Support'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: messages.isEmpty
                  ? const Center(
                      child: Text(
                        "How can I support you?",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: messages.length,
                      padding: const EdgeInsets.all(10),
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isMe = message.senderId == currentUserId;

                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Column(
                              crossAxisAlignment: isMe
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 14,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isMe
                                        ? Colors.blue
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    message.message,
                                    style: TextStyle(
                                      color: isMe
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    formatTime(message.timestamp),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: _isSending
                        ? const CircularProgressIndicator(
                            strokeWidth: 4,
                            color: Colors.blue,
                          )
                        : const Icon(Icons.send, color: Colors.blue),
                    onPressed: _isSending ? null : _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

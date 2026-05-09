import 'package:flutter/foundation.dart';
import 'package:ethio_iq/core/models/chat_message.dart';

class ConversationPreview {
  final String conversationId;
  final String participantId;
  final String participantName;
  final String participantRole;
  final String lastMessage;
  final DateTime lastMessageAt;
  final int unreadForAdmin;

  const ConversationPreview({
    required this.conversationId,
    required this.participantId,
    required this.participantName,
    required this.participantRole,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.unreadForAdmin,
  });
}

/// Application-scoped chat bridge for admin, tutors, and families.
class ChatRepository {
  ChatRepository._internal();

  static final ChatRepository instance = ChatRepository._internal();

  final ValueNotifier<Map<String, List<ChatMessage>>> _conversations =
      ValueNotifier<Map<String, List<ChatMessage>>>({});
  final ValueNotifier<Map<String, int>> _adminUnreadByConversation =
      ValueNotifier<Map<String, int>>({});
  final ValueNotifier<Map<String, Map<String, String>>> _participantMeta =
      ValueNotifier<Map<String, Map<String, String>>>({});

  ValueListenable<Map<String, List<ChatMessage>>> get conversations =>
      _conversations;
  ValueListenable<Map<String, int>> get adminUnreadByConversation =>
      _adminUnreadByConversation;

  String conversationIdForParticipant(String participantId) =>
      'admin_$participantId';

  List<ChatMessage> getMessagesForConversation(String conversationId) {
    return List.unmodifiable(_conversations.value[conversationId] ?? []);
  }

  List<ConversationPreview> getAdminConversationPreviews() {
    final previews = <ConversationPreview>[];
    for (final entry in _conversations.value.entries) {
      final messages = entry.value;
      if (messages.isEmpty) continue;
      final last = messages.last;
      final meta = _participantMeta.value[entry.key] ?? const {};
      previews.add(
        ConversationPreview(
          conversationId: entry.key,
          participantId: meta['participantId'] ?? last.senderId,
          participantName: meta['participantName'] ?? 'Unknown User',
          participantRole: meta['participantRole'] ?? 'user',
          lastMessage: last.text,
          lastMessageAt: last.timestamp,
          unreadForAdmin: _adminUnreadByConversation.value[entry.key] ?? 0,
        ),
      );
    }
    previews.sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));
    return previews;
  }

  void sendMessage({
    required String conversationId,
    required String senderId,
    required String senderName,
    required String receiverId,
    required String receiverName,
    required String body,
    required String conversationType,
    required bool incrementAdminUnread,
    String? participantId,
    String? participantName,
    String? participantRole,
  }) {
    final timeline = List<ChatMessage>.from(
      _conversations.value[conversationId] ?? [],
    );
    timeline.add(
      ChatMessage(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        senderId: senderId,
        senderName: senderName,
        receiverId: receiverId,
        receiverName: receiverName,
        text: body,
        timestamp: DateTime.now(),
        conversationType: conversationType,
      ),
    );
    _conversations.value = {..._conversations.value, conversationId: timeline};

    if (participantId != null) {
      _participantMeta.value = {
        ..._participantMeta.value,
        conversationId: {
          'participantId': participantId,
          'participantName': participantName ?? participantId,
          'participantRole': participantRole ?? 'user',
        },
      };
    }

    if (incrementAdminUnread) {
      _adminUnreadByConversation.value = {
        ..._adminUnreadByConversation.value,
        conversationId:
            (_adminUnreadByConversation.value[conversationId] ?? 0) + 1,
      };
    }
  }

  void sendUserMessageToAdmin({
    required String userId,
    required String userName,
    required String userRole,
    required String body,
  }) {
    final conversationId = conversationIdForParticipant(userId);
    sendMessage(
      conversationId: conversationId,
      senderId: userId,
      senderName: userName,
      receiverId: 'admin',
      receiverName: 'Admin Team',
      body: body,
      conversationType: userRole,
      incrementAdminUnread: true,
      participantId: userId,
      participantName: userName,
      participantRole: userRole,
    );
  }

  void sendAdminMessageToUser({
    required String userId,
    required String userName,
    required String userRole,
    required String body,
  }) {
    final conversationId = conversationIdForParticipant(userId);
    sendMessage(
      conversationId: conversationId,
      senderId: 'admin',
      senderName: 'Admin Team',
      receiverId: userId,
      receiverName: userName,
      body: body,
      conversationType: userRole,
      incrementAdminUnread: false,
      participantId: userId,
      participantName: userName,
      participantRole: userRole,
    );
  }

  void markConversationReadByAdmin(String conversationId) {
    if ((_adminUnreadByConversation.value[conversationId] ?? 0) == 0) return;
    _adminUnreadByConversation.value = {
      ..._adminUnreadByConversation.value,
      conversationId: 0,
    };
  }
}

import 'package:flutter/material.dart';
import 'package:ethio_iq/core/theme/app_theme.dart';
import 'package:ethio_iq/core/models/chat_message.dart';
import 'package:ethio_iq/features/chat/data/chat_repository.dart';

/// Centralized Chat Screen for Admin-Tutor and Admin-Family conversations
class ChatScreen extends StatefulWidget {
  final String conversationId;
  final String otherUserId;
  final String otherUserName;
  final String conversationType;
  final String currentUserId;
  final String currentUserName;

  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.otherUserId,
    required this.otherUserName,
    required this.conversationType,
    required this.currentUserId,
    required this.currentUserName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final ChatRepository _chatRepository;

  @override
  void initState() {
    super.initState();
    _chatRepository = ChatRepository.instance;
    if (widget.currentUserId == 'admin') {
      _chatRepository.markConversationReadByAdmin(widget.conversationId);
    }
  }

  void _sendMessage() {
    final body = _messageController.text.trim();
    if (body.isEmpty) return;
    if (widget.currentUserId == 'admin') {
      _chatRepository.sendAdminMessageToUser(
        userId: widget.otherUserId,
        userName: widget.otherUserName,
        userRole: widget.conversationType,
        body: body,
      );
    } else {
      _chatRepository.sendUserMessageToAdmin(
        userId: widget.currentUserId,
        userName: widget.currentUserName,
        userRole: widget.conversationType,
        body: body,
      );
    }
    _messageController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _getConversationTitle() {
    switch (widget.conversationType) {
      case 'recruitment':
        return 'Recruitment Discussion';
      case 'matching':
        return 'Tutor Matching';
      case 'requirements':
        return 'Family Requirements';
      default:
        return 'Chat';
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Chat'),
            Text(
              widget.otherUserName,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.spacingS),
            color: AppTheme.lightBlueCard,
            child: Center(
              child: Chip(
                label: Text(
                  _getConversationTitle(),
                  style: const TextStyle(fontSize: 12),
                ),
                backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.1),
                labelStyle: TextStyle(color: AppTheme.primaryBlue),
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<Map<String, List<ChatMessage>>>(
              valueListenable: _chatRepository.conversations,
              builder: (context, conversations, _) {
                final messages =
                    conversations[widget.conversationId] ?? const <ChatMessage>[];
                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      'No messages yet. Start the conversation.',
                      style: AppTheme.bodyMedium,
                    ),
                  );
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(AppTheme.spacingL),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isCurrentUser = message.senderId == widget.currentUserId;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
                      child: Align(
                        alignment: isCurrentUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: isCurrentUser
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(message.senderName, style: AppTheme.bodySmall),
                            const SizedBox(height: 4),
                            Container(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.7,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppTheme.spacingL,
                                vertical: AppTheme.spacingS,
                              ),
                              decoration: BoxDecoration(
                                color: isCurrentUser
                                    ? AppTheme.primaryBlue
                                    : AppTheme.lightBlueCard,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                message.text,
                                style: TextStyle(
                                  color: isCurrentUser
                                      ? Colors.white
                                      : AppTheme.textDark,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatTime(message.timestamp),
                              style: AppTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            decoration: BoxDecoration(
              color: AppTheme.backgroundLight,
              border: Border(top: BorderSide(color: Colors.grey[300]!, width: 1)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppTheme.backgroundWhite,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingL,
                        vertical: AppTheme.spacingM,
                      ),
                    ),
                    minLines: 1,
                    maxLines: 3,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingL),
                Container(
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

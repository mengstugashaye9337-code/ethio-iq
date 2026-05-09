import 'package:flutter/material.dart';
import 'package:ethio_iq/core/models/user_model.dart';
import 'package:ethio_iq/features/chat/presentation/screens/chat_screen.dart';

class AdminTutorChatScreen extends StatefulWidget {
  final UserModel tutor;

  const AdminTutorChatScreen({super.key, required this.tutor});

  @override
  State<AdminTutorChatScreen> createState() => _AdminTutorChatScreenState();
}

class _AdminTutorChatScreenState extends State<AdminTutorChatScreen> {
  @override
  Widget build(BuildContext context) {
    return ChatScreen(
      conversationId: 'admin_${widget.tutor.id}',
      otherUserId: widget.tutor.id,
      otherUserName: widget.tutor.name,
      conversationType: 'tutor',
      currentUserId: 'admin',
      currentUserName: 'Admin Team',
    );
  }
}

/// Chat Message Model for conversations between Admin, Tutors, and Families
class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String receiverId;
  final String receiverName;
  final String text;
  final DateTime timestamp;
  final String conversationType;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.receiverName,
    required this.text,
    required this.timestamp,
    required this.conversationType,
    this.isRead = false,
  });

  ChatMessage copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? receiverId,
    String? receiverName,
    String? text,
    DateTime? timestamp,
    String? conversationType,
    bool? isRead,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      receiverId: receiverId ?? this.receiverId,
      receiverName: receiverName ?? this.receiverName,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      conversationType: conversationType ?? this.conversationType,
      isRead: isRead ?? this.isRead,
    );
  }
}

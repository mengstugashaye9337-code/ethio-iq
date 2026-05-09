import 'package:flutter/material.dart';
import 'package:ethio_iq/core/theme/app_theme.dart';
import 'package:ethio_iq/core/constants/app_constants.dart';
import 'package:ethio_iq/core/extensions/gradient_extension.dart';
import 'package:ethio_iq/core/models/user_model.dart';
import 'package:ethio_iq/features/admin/presentation/screens/assign_tutor_screen.dart';
import 'package:ethio_iq/features/admin/presentation/screens/tutor_application_detail_screen.dart';
import 'package:ethio_iq/features/bookings/data/booking_repository.dart';
import 'package:ethio_iq/features/auth/data/auth_service.dart';
import 'package:ethio_iq/features/chat/data/chat_repository.dart';
import 'package:ethio_iq/features/chat/presentation/screens/chat_screen.dart';

class AdminDashboard extends StatefulWidget {
  final UserModel user;

  const AdminDashboard({super.key, required this.user});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    final tutors = AuthService.registeredUsers
        .where((user) => user.role == UserRole.tutor)
        .toList()
      ..sort(
        (a, b) => (a.registrationDate ?? DateTime.now()).compareTo(
          b.registrationDate ?? DateTime.now(),
        ),
      );

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(AppConstants.appName, style: AppTheme.titleMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications coming soon!')),
              );
            },
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(AppTheme.paddingStandard),
              padding: const EdgeInsets.all(AppTheme.paddingLarge),
              decoration: AppTheme.softBlueGradient.toBoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selam, ${widget.user.name}!',
                    style: AppTheme.titleLarge.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    'Manage FIFO queues and admin communication',
                    style: AppTheme.bodyMedium.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const TabBar(
              tabs: [
                Tab(text: 'Tutor Applications'),
                Tab(text: 'Family Requests'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ListView.builder(
                    padding: const EdgeInsets.all(AppTheme.paddingStandard),
                    itemCount: tutors.length,
                    itemBuilder: (context, index) {
                      final tutor = tutors[index];
                      return _buildQueueCard(
                        title: tutor.name,
                        subtitle:
                            '${tutor.email} • ${tutor.registrationDate?.toLocal().toString().split(' ').first ?? 'Unknown'}',
                        queueLabel: '#${index + 1}',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  TutorApplicationDetailScreen(tutor: tutor),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: BookingRepository.instance.requests,
                    builder: (context, requests, _) {
                      final familyRequests = requests
                          .where((request) => request.isPending)
                          .toList()
                        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
                      return ListView.builder(
                        padding: const EdgeInsets.all(AppTheme.paddingStandard),
                        itemCount: familyRequests.length,
                        itemBuilder: (context, index) {
                          final request = familyRequests[index];
                          return _buildQueueCard(
                            title: request.familyName,
                            subtitle:
                                '${request.subject} • ${request.grade} • ${request.createdAt.toLocal().toString().split(' ').first}',
                            queueLabel: '#${index + 1}',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AssignTutorScreen(requestId: request.id),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.paddingStandard),
              child: Text('Admin Chat Inbox', style: AppTheme.titleMedium),
            ),
            ValueListenableBuilder(
              valueListenable: ChatRepository.instance.conversations,
              builder: (context, _, _) {
                final conversations =
                    ChatRepository.instance.getAdminConversationPreviews();
                return SizedBox(
                  height: 180,
                  child: conversations.isEmpty
                      ? Center(
                          child: Text(
                            'No chat threads yet.',
                            style: AppTheme.bodyMedium,
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.paddingStandard,
                          ),
                          itemCount: conversations.length,
                          itemBuilder: (context, index) {
                            final thread = conversations[index];
                            return Container(
                              width: 260,
                              margin: const EdgeInsets.only(
                                right: AppTheme.spacingM,
                              ),
                              padding:
                                  const EdgeInsets.all(AppTheme.paddingStandard),
                              decoration: AppTheme.whiteCardDecoration,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          thread.participantName,
                                          style: AppTheme.titleSmall,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (thread.unreadForAdmin > 0)
                                        CircleAvatar(
                                          radius: 12,
                                          backgroundColor: AppTheme.errorColor,
                                          child: Text(
                                            '${thread.unreadForAdmin}',
                                            style: AppTheme.bodySmall.copyWith(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: AppTheme.spacingXS),
                                  Text(
                                    thread.participantRole.toUpperCase(),
                                    style: AppTheme.bodySmall,
                                  ),
                                  const SizedBox(height: AppTheme.spacingS),
                                  Text(
                                    thread.lastMessage,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTheme.bodyMedium,
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        ChatRepository.instance
                                            .markConversationReadByAdmin(
                                          thread.conversationId,
                                        );
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ChatScreen(
                                              conversationId:
                                                  thread.conversationId,
                                              otherUserId: thread.participantId,
                                              otherUserName:
                                                  thread.participantName,
                                              conversationType:
                                                  thread.participantRole,
                                              currentUserId: 'admin',
                                              currentUserName: 'Admin Team',
                                            ),
                                          ),
                                        );
                                      },
                                      style: AppTheme.elevatedButtonStyle,
                                      child: Text(
                                        'Reply',
                                        style: AppTheme.buttonText,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                );
              },
            ),
            const SizedBox(height: AppTheme.spacingM),
          ],
        ),
      ),
    );
  }

  Widget _buildQueueCard({
    required String title,
    required String subtitle,
    required String queueLabel,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppTheme.spacingL),
      padding: const EdgeInsets.all(AppTheme.paddingStandard),
      decoration: AppTheme.whiteCardDecoration,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingM,
              vertical: AppTheme.spacingXS,
            ),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppTheme.radiusS),
            ),
            child: Text(queueLabel, style: AppTheme.titleSmall),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTheme.titleSmall),
                const SizedBox(height: AppTheme.spacingXS),
                Text(subtitle, style: AppTheme.bodySmall),
              ],
            ),
          ),
          IconButton(onPressed: onTap, icon: const Icon(Icons.arrow_forward_ios)),
        ],
      ),
    );
  }
}

/// Extension to add InkWell to Container
extension ContainerInkWell on Container {
  Widget addInkWell({required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusM),
      child: this,
    );
  }
}

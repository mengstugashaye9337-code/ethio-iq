import 'package:flutter/material.dart';
import 'package:ethio_iq/core/theme/app_theme.dart';
import 'package:ethio_iq/core/constants/app_constants.dart';
import 'package:ethio_iq/core/extensions/gradient_extension.dart';
import 'package:ethio_iq/core/models/user_model.dart';
import 'package:ethio_iq/features/chat/presentation/screens/chat_screen.dart';

/// Tutor Dashboard - For Tutor role
///
/// Focuses on:
/// - My Profile
/// - My Assignments
/// - Earnings
/// - Availability
class TutorDashboard extends StatefulWidget {
  final UserModel user;

  const TutorDashboard({super.key, required this.user});

  @override
  State<TutorDashboard> createState() => _TutorDashboardState();
}

class _TutorDashboardState extends State<TutorDashboard> {
  int _selectedIndex = 0;
  late final PageController _pageController;

  bool get _showPendingStatus =>
      widget.user.role == UserRole.tutor &&
      (widget.user.verificationStatus == null ||
          widget.user.verificationStatus == VerificationStatus.pending);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildHomePage(context),
          _buildAssignmentsPage(context),
          _buildEarningsPage(context),
          _buildProfilePage(context),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.primaryBlue,
        unselectedItemColor: AppTheme.textSecondary,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Assignments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Earnings',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildHomePage(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.paddingStandard),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.paddingLarge),
            decoration: AppTheme.softBlueGradient.toBoxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selam, ${widget.user.name}!',
                            style: AppTheme.titleLarge.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingS),
                          Text(
                            'Manage your teaching assignments',
                            style: AppTheme.bodyMedium.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingS,
                        vertical: AppTheme.spacingXS,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(AppTheme.radiusS),
                      ),
                      child: Text(
                        '👨‍🏫 Tutor',
                        style: AppTheme.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_showPendingStatus) ...[
            const SizedBox(height: AppTheme.spacingM),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.paddingStandard),
              decoration: BoxDecoration(
                color: AppTheme.warningColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                border: Border.all(
                  color: AppTheme.warningColor.withValues(alpha: 0.35),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.hourglass_top, color: AppTheme.warningColor),
                  const SizedBox(width: AppTheme.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pending',
                          style: AppTheme.titleSmall.copyWith(
                            color: AppTheme.warningColor,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingXS),
                        Text(
                          'Your tutor profile is not verified yet. An admin will review your application.',
                          style: AppTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppTheme.spacingXL),

          // Quick Stats
          Text('Your Stats', style: AppTheme.titleMedium),
          const SizedBox(height: AppTheme.spacingL),

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Active\nAssignments',
                  '3',
                  Icons.assignment,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: _buildStatCard(
                  'This Month\nEarnings',
                  '2,500 ETB',
                  Icons.attach_money,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingXL),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(
                      conversationId: 'admin_${widget.user.id}',
                      otherUserId: 'admin',
                      otherUserName: 'Admin Team',
                      conversationType: 'tutor',
                      currentUserId: widget.user.id,
                      currentUserName: widget.user.name,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.support_agent),
              label: const Text('Message Admin'),
            ),
          ),
          const SizedBox(height: AppTheme.spacingXL),

          // Main Actions
          Text('Manage Your Work', style: AppTheme.titleMedium),
          const SizedBox(height: AppTheme.spacingL),

          // My Profile Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.paddingStandard),
            decoration: AppTheme.whiteCardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacingM),
                      decoration: AppTheme.cardDecoration,
                      child: const Icon(
                        Icons.person,
                        color: AppTheme.primaryBlue,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingL),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('My Profile', style: AppTheme.titleSmall),
                          const SizedBox(height: AppTheme.spacingXS),
                          Text(
                            'Update your profile and subjects',
                            style: AppTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppTheme.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ).addInkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile management coming soon!'),
                ),
              );
            },
          ),
          const SizedBox(height: AppTheme.spacingL),

          // My Assignments Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.paddingStandard),
            decoration: AppTheme.whiteCardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacingM),
                      decoration: AppTheme.cardDecoration,
                      child: const Icon(
                        Icons.assignment_turned_in,
                        color: AppTheme.primaryBlue,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingL),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('My Assignments', style: AppTheme.titleSmall),
                          const SizedBox(height: AppTheme.spacingXS),
                          Text(
                            'View and manage your teaching assignments',
                            style: AppTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppTheme.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ).addInkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Assignments management coming soon!'),
                ),
              );
            },
          ),
          const SizedBox(height: AppTheme.spacingL),

          // Earnings Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.paddingStandard),
            decoration: AppTheme.whiteCardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacingM),
                      decoration: AppTheme.cardDecoration,
                      child: const Icon(
                        Icons.account_balance_wallet,
                        color: AppTheme.primaryBlue,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingL),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Earnings', style: AppTheme.titleSmall),
                          const SizedBox(height: AppTheme.spacingXS),
                          Text(
                            'Track your payments and earnings',
                            style: AppTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppTheme.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ).addInkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Earnings tracking coming soon!')),
              );
            },
          ),
          const SizedBox(height: AppTheme.spacingXL),

          // Availability Toggle
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.paddingStandard),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
              border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingL),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available for New Assignments',
                        style: AppTheme.titleSmall.copyWith(
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingXS),
                      Text(
                        'You are currently accepting new students',
                        style: AppTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: true,
                  onChanged: (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          value
                              ? 'You are now available for assignments'
                              : 'You are now unavailable',
                          style: AppTheme.bodyMedium.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: value ? Colors.green : Colors.orange,
                      ),
                    );
                  },
                  activeThumbColor: Colors.green,
                  activeTrackColor: Colors.green.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingXL),
        ],
      ),
    );
  }

  Widget _buildAssignmentsPage(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.paddingStandard),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Assignments', style: AppTheme.titleMedium),
          const SizedBox(height: AppTheme.spacingL),
          Text(
            'View active assignments and manage upcoming sessions.',
            style: AppTheme.bodyMedium,
          ),
          const SizedBox(height: AppTheme.spacingXL),
          _buildStatCard(
            'Active Assignments',
            '3',
            Icons.assignment_turned_in,
            Colors.blue,
          ),
          const SizedBox(height: AppTheme.spacingL),
          _buildStatCard(
            'Pending Reviews',
            '2',
            Icons.rate_review,
            Colors.orange,
          ),
          const SizedBox(height: AppTheme.spacingXL),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Assignment management coming soon!'),
                  ),
                );
              },
              style: AppTheme.elevatedButtonStyle,
              child: Text('Manage Assignments', style: AppTheme.buttonText),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsPage(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.paddingStandard),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Earnings', style: AppTheme.titleMedium),
          const SizedBox(height: AppTheme.spacingL),
          Text(
            'Monitor your earnings and payout status for the current month.',
            style: AppTheme.bodyMedium,
          ),
          const SizedBox(height: AppTheme.spacingXL),
          _buildStatCard(
            'This Month',
            '2,500 ETB',
            Icons.attach_money,
            Colors.green,
          ),
          const SizedBox(height: AppTheme.spacingL),
          _buildStatCard(
            'Total Revenue',
            '15,000 ETB',
            Icons.paid,
            Colors.purple,
          ),
          const SizedBox(height: AppTheme.spacingXL),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Payout details coming soon!')),
                );
              },
              style: AppTheme.elevatedButtonStyle,
              child: Text('View Payouts', style: AppTheme.buttonText),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePage(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.paddingStandard),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Profile', style: AppTheme.titleMedium),
          const SizedBox(height: AppTheme.spacingL),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.paddingStandard),
            decoration: AppTheme.whiteCardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Account', style: AppTheme.titleSmall),
                const SizedBox(height: AppTheme.spacingS),
                Text('Name: ${widget.user.name}', style: AppTheme.bodyMedium),
                const SizedBox(height: AppTheme.spacingS),
                Text('Role: Tutor', style: AppTheme.bodyMedium),
                const SizedBox(height: AppTheme.spacingXL),
                Text(
                  'Profile management coming soon. You can manage assignments, earnings, and your availability from this dashboard.',
                  style: AppTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingXL),
        ],
      ),
    );
  }

  /// Build stat card
  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingStandard),
      decoration: AppTheme.whiteCardDecoration,
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            value,
            style: AppTheme.titleLarge.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingXS),
          Text(title, style: AppTheme.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  /// Handle bottom navigation tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
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

import 'package:flutter/material.dart';
import 'package:ethio_iq/core/theme/app_theme.dart';

/// Admin Panel Screen - Broker/Admin view for managing requests
///
/// DATA FLOW:
/// 1. DashboardScreen (if userName == "Mengstu_Admin") → Admin Panel button
/// 2. Shows all incoming tutor requests from families
/// 3. Admin can Approve/Assign tutors to requests
class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  // Sample incoming requests
  final List<Map<String, dynamic>> incomingRequests = [
    {
      'id': 1,
      'familyName': 'Kebede Family',
      'subject': 'Mathematics',
      'grade': 'Grade 10',
      'location': 'Addis Ababa, Bole',
      'requestDate': '2024-01-20',
      'status': 'Pending',
    },
    {
      'id': 2,
      'familyName': 'Alemayehu Family',
      'subject': 'Science',
      'grade': 'Grade 9',
      'location': 'Addis Ababa, Nifas Silk',
      'requestDate': '2024-01-19',
      'status': 'Pending',
    },
    {
      'id': 3,
      'familyName': 'Haile Family',
      'subject': 'English',
      'grade': 'High School',
      'location': 'Dire Dawa',
      'requestDate': '2024-01-18',
      'status': 'Assigned',
      'assignedTutor': 'Dr. Alemayehu',
    },
    {
      'id': 4,
      'familyName': 'Tadesse Family',
      'subject': 'Coding',
      'grade': 'High School',
      'location': 'Addis Ababa, Gulale',
      'requestDate': '2024-01-17',
      'status': 'Pending',
    },
  ];

  // Available tutors for assignment
  final List<String> availableTutors = [
    'Dr. Alemayehu',
    'Hana Bekele',
    'Meron Haile',
    'Sami Yusuf',
    'Abel Leul',
    'Mengstu Yaregal',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text('Broker Admin Panel', style: AppTheme.titleMedium),
        backgroundColor: AppTheme.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.paddingStandard),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppTheme.spacingL),

            // Header
            Text('Incoming Requests', style: AppTheme.titleLarge),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              'Manage family requests and assign tutors',
              style: AppTheme.bodyMedium,
            ),
            const SizedBox(height: AppTheme.spacingXL),

            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Pending',
                    incomingRequests
                        .where((r) => r['status'] == 'Pending')
                        .length
                        .toString(),
                    AppTheme.warningColor,
                    Icons.schedule,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingL),
                Expanded(
                  child: _buildStatCard(
                    'Assigned',
                    incomingRequests
                        .where((r) => r['status'] == 'Assigned')
                        .length
                        .toString(),
                    AppTheme.successColor,
                    Icons.check_circle,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppTheme.spacingXL),

            // Requests List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: incomingRequests.length,
              itemBuilder: (context, index) {
                final request = incomingRequests[index];
                return _buildRequestCard(request);
              },
            ),

            const SizedBox(height: AppTheme.spacingXL),
          ],
        ),
      ),
    );
  }

  /// Build stat card
  Widget _buildStatCard(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingStandard),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppTheme.spacingS),
          Text(value, style: AppTheme.titleMedium.copyWith(color: color)),
          const SizedBox(height: AppTheme.spacingXS),
          Text(label, style: AppTheme.bodySmall),
        ],
      ),
    );
  }

  /// Build request card
  Widget _buildRequestCard(Map<String, dynamic> request) {
    final isPending = request['status'] == 'Pending';
    final statusColor = isPending
        ? AppTheme.warningColor
        : AppTheme.successColor;

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingL),
      padding: const EdgeInsets.all(AppTheme.paddingStandard),
      decoration: AppTheme.whiteCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(request['familyName'], style: AppTheme.titleSmall),
                    const SizedBox(height: AppTheme.spacingXS),
                    Text(
                      '${request['subject']} - ${request['grade']}',
                      style: AppTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM,
                  vertical: AppTheme.spacingXS,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusS),
                ),
                child: Text(
                  request['status'],
                  style: AppTheme.bodySmall.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacingS),

          // Location and date
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: AppTheme.textSecondary,
              ),
              const SizedBox(width: AppTheme.spacingXS),
              Expanded(
                child: Text(request['location'], style: AppTheme.bodySmall),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacingXS),

          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: AppTheme.textSecondary,
              ),
              const SizedBox(width: AppTheme.spacingXS),
              Text(request['requestDate'], style: AppTheme.bodySmall),
            ],
          ),

          // Show assigned tutor if assigned
          if (!isPending) ...[
            const SizedBox(height: AppTheme.spacingS),
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingS),
              decoration: BoxDecoration(
                color: AppTheme.successColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusS),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.verified_user,
                    color: AppTheme.successColor,
                    size: 18,
                  ),
                  const SizedBox(width: AppTheme.spacingS),
                  Text(
                    'Assigned: ${request['assignedTutor']}',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.successColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Action buttons
          if (isPending)
            Column(
              children: [
                const SizedBox(height: AppTheme.spacingL),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Request declined'),
                              backgroundColor: AppTheme.errorColor,
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppTheme.errorColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusM,
                            ),
                          ),
                        ),
                        child: Text(
                          'Decline',
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.errorColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingL),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _showAssignTutorDialog(context, request);
                        },
                        style: AppTheme.elevatedButtonStyle,
                        child: Text('Assign Tutor', style: AppTheme.buttonText),
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  /// Show dialog to assign tutor
  void _showAssignTutorDialog(
    BuildContext context,
    Map<String, dynamic> request,
  ) {
    String? selectedTutor;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Assign Tutor to ${request['familyName']}',
                style: AppTheme.titleMedium,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Request: ${request['subject']} - ${request['grade']}',
                    style: AppTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppTheme.spacingL),
                  Text('Select Tutor:', style: AppTheme.bodyMedium),
                  const SizedBox(height: AppTheme.spacingS),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: selectedTutor,
                    hint: Text('Choose a tutor...', style: AppTheme.bodyMedium),
                    onChanged: (String? value) {
                      setState(() {
                        selectedTutor = value;
                      });
                    },
                    items: availableTutors.map((String tutor) {
                      return DropdownMenuItem<String>(
                        value: tutor,
                        child: Text(tutor),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ),
                ElevatedButton(
                  onPressed: selectedTutor != null
                      ? () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Assigned $selectedTutor to ${request['familyName']}',
                                style: AppTheme.bodyMedium.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: AppTheme.successColor,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppTheme.radiusM,
                                ),
                              ),
                            ),
                          );
                        }
                      : null,
                  style: AppTheme.elevatedButtonStyle,
                  child: Text('Assign', style: AppTheme.buttonText),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

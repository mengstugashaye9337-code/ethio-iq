import 'package:flutter/material.dart';
import 'package:ethio_iq/core/theme/app_theme.dart';
import 'tutor_profile_screen.dart';

/// Tutor List Screen - Browse all tutors
///
/// DATA FLOW:
/// 1. DashboardScreen "12 Tutors" card OR "View Tutors" button → here
/// 2. Shows "Top Ranked" section with horizontal scroll
/// 3. Shows "All Tutors" section with vertical list + pagination
class TutorListScreen extends StatefulWidget {
  const TutorListScreen({super.key});

  @override
  State<TutorListScreen> createState() => _TutorListScreenState();
}

class _TutorListScreenState extends State<TutorListScreen> {
  // Top ranked tutors
  final List<Map<String, dynamic>> topRankedTutors = [
    {
      'name': 'Dr. Alemayehu',
      'subject': 'Mathematics',
      'rating': 4.9,
      'price': 500,
      'image': '👨‍🎓',
    },
    {
      'name': 'Hana Bekele',
      'subject': 'Science',
      'rating': 4.8,
      'price': 480,
      'image': '👩‍🎓',
    },
    {
      'name': 'Meron Haile',
      'subject': 'Languages',
      'rating': 4.9,
      'price': 450,
      'image': '👩‍🏫',
    },
    {
      'name': 'Sami Yusuf',
      'subject': 'Coding',
      'rating': 4.8,
      'price': 550,
      'image': '👨‍💻',
    },
  ];

  // All tutors (sample data - can be paginated)
  final List<Map<String, dynamic>> allTutors = [
    {
      'name': 'Dr. Alemayehu',
      'subject': 'Mathematics',
      'rating': 4.9,
      'price': 500,
    },
    {'name': 'Hana Bekele', 'subject': 'Science', 'rating': 4.8, 'price': 480},
    {
      'name': 'Meron Haile',
      'subject': 'Languages',
      'rating': 4.9,
      'price': 450,
    },
    {'name': 'Sami Yusuf', 'subject': 'Coding', 'rating': 4.8, 'price': 550},
    {
      'name': 'Abel Leul',
      'subject': 'Mathematics',
      'rating': 4.7,
      'price': 400,
    },
    {
      'name': 'Mengstu Yaregal',
      'subject': 'English',
      'rating': 4.6,
      'price': 420,
    },
  ];

  int displayedCount = 4; // Show first 4 tutors, load more on demand

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text('Browse Tutors', style: AppTheme.titleMedium),
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

            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingM,
                vertical: AppTheme.spacingS,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                border: Border.all(color: AppTheme.lightAccent),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppTheme.textSecondary),
                  const SizedBox(width: AppTheme.spacingS),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search tutors by name or subject',
                        border: InputBorder.none,
                        hintStyle: AppTheme.bodyMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacingXL),

            // Top Ranked Section
            Text('⭐ Top Ranked', style: AppTheme.titleMedium),
            const SizedBox(height: AppTheme.spacingL),

            // Horizontal scrollable list of top ranked tutors
            SizedBox(
              height: 260,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: topRankedTutors.length,
                itemBuilder: (context, index) {
                  final tutor = topRankedTutors[index];
                  return _buildTopRankedTutorCard(tutor);
                },
              ),
            ),

            const SizedBox(height: AppTheme.spacingXL),

            // All Tutors Section
            Text('All Tutors', style: AppTheme.titleMedium),
            const SizedBox(height: AppTheme.spacingL),

            // Vertical list of all tutors
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: displayedCount > allTutors.length
                  ? allTutors.length
                  : displayedCount,
              itemBuilder: (context, index) {
                final tutor = allTutors[index];
                return _buildTutorListItem(tutor);
              },
            ),

            const SizedBox(height: AppTheme.spacingL),

            // Load More Button (if there are more tutors)
            if (displayedCount < allTutors.length)
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      displayedCount += 4;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.primaryBlue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    ),
                  ),
                  child: Text(
                    'Load More',
                    style: AppTheme.buttonText.copyWith(
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: AppTheme.spacingXL),
          ],
        ),
      ),
    );
  }

  /// Build top ranked tutor card (horizontal)
  Widget _buildTopRankedTutorCard(Map<String, dynamic> tutor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TutorProfileScreen(
              name: tutor['name'],
              subject: tutor['subject'],
              rating: tutor['rating'],
              price: tutor['price'],
            ),
          ),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: AppTheme.spacingL),
        padding: const EdgeInsets.all(AppTheme.paddingStandard),
        decoration: BoxDecoration(
          gradient: AppTheme.softBlueGradient,
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  tutor['image'],
                  style: const TextStyle(fontSize: 40),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingS),

            // Name
            Text(
              tutor['name'],
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingXS),

            // Subject
            Text(
              tutor['subject'],
              textAlign: TextAlign.center,
              style: AppTheme.bodySmall.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: AppTheme.spacingXS),

            // Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${tutor['rating']}',
                  style: AppTheme.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build tutor list item (vertical)
  Widget _buildTutorListItem(Map<String, dynamic> tutor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TutorProfileScreen(
              name: tutor['name'],
              subject: tutor['subject'],
              rating: tutor['rating'],
              price: tutor['price'],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.spacingL),
        padding: const EdgeInsets.all(AppTheme.paddingStandard),
        decoration: AppTheme.whiteCardDecoration,
        child: Row(
          children: [
            // Avatar
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: AppTheme.lightBlueCard,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: AppTheme.primaryBlue,
                size: 28,
              ),
            ),
            const SizedBox(width: AppTheme.spacingL),

            // Tutor info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tutor['name'], style: AppTheme.titleSmall),
                  const SizedBox(height: AppTheme.spacingXS),
                  Text(tutor['subject'], style: AppTheme.bodyMedium),
                  const SizedBox(height: AppTheme.spacingXS),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: AppTheme.ratingColor,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${tutor['rating']}',
                        style: AppTheme.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingM),
                      Text(
                        'ETB ${tutor['price']}/hr',
                        style: AppTheme.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Arrow icon
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

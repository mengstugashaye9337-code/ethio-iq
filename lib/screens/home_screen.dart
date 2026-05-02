import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'tutor_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Subject categories
  final List<String> subjects = [
    'All Subjects',
    'Math',
    'English',
    'Science',
    'Languages',
  ];

  int selectedSubjectIndex = 0;

  // Tutor data
  final List<Map<String, dynamic>> tutors = [
    {
      'name': 'Abel Leul',
      'subject': 'Mathematics',
      'rating': 4.9,
      'price': 150,
      'icon': Icons.person,
    },
    {
      'name': 'Mengstu Yaregal',
      'subject': 'English',
      'rating': 4.8,
      'price': 120,
      'icon': Icons.person,
    },
    {
      'name': 'Hana Bekele ',
      'subject': 'Science',
      'rating': 4.7,
      'price': 180,
      'icon': Icons.person,
    },
    {
      'name': 'Meron Haile',
      'subject': 'Languages',
      'rating': 4.9,
      'price': 200,
      'icon': Icons.person,
    },
    {
      'name': 'Sami Yusuf',
      'subject': 'Mathematics',
      'rating': 4.6,
      'price': 130,
      'icon': Icons.person,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(
        title: const Text(
          'Ethio IQ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      // Main body
      body: Column(
        children: [
          // Welcome Section with Soft Gradient
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: AppTheme.softBlueGradient,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find the Best Tutor for Your Family',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Trusted tutors across Ethiopia',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search tutor or subject',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppTheme.backgroundLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusXL),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ),

          // Subject Categories
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingL,
              ),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final isSelected = index == selectedSubjectIndex;
                return Padding(
                  padding: const EdgeInsets.only(right: AppTheme.spacingS),
                  child: FilterChip(
                    label: Text(subjects[index]),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedSubjectIndex = index;
                      });
                    },
                    selectedColor: AppTheme.primaryBlue.withValues(alpha: 0.2),
                    checkmarkColor: AppTheme.primaryBlue,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppTheme.primaryBlue
                          : AppTheme.textSecondary,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: AppTheme.spacingS),

          // Tutor List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              itemCount: tutors.length,
              itemBuilder: (context, index) {
                final tutor = tutors[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: AppTheme.spacingL),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingL),
                    child: Row(
                      children: [
                        // Tutor Avatar
                        CircleAvatar(
                          radius: AppTheme.avatarL,
                          backgroundColor: AppTheme.primaryBlue.withValues(
                            alpha: 0.1,
                          ),
                          child: Icon(
                            tutor['icon'],
                            size: AppTheme.iconL,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacingL),

                        // Tutor Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tutor['name'], style: AppTheme.titleSmall),
                              const SizedBox(height: AppTheme.spacingXS),
                              Text(
                                tutor['subject'],
                                style: AppTheme.bodyMedium,
                              ),
                              const SizedBox(height: AppTheme.spacingS),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: AppTheme.iconS,
                                    color: AppTheme.ratingColor,
                                  ),
                                  const SizedBox(width: AppTheme.spacingXS),
                                  Text(
                                    '${tutor['rating']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: AppTheme.spacingL),
                                  Text(
                                    'ETB ${tutor['price']}/hr',
                                    style: TextStyle(
                                      color: AppTheme.primaryBlue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // View Profile Button
                        ElevatedButton(
                          onPressed: () {
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusS,
                              ),
                            ),
                          ),
                          child: const Text('View Profile'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: AppTheme.primaryBlue,
        unselectedItemColor: AppTheme.textSecondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

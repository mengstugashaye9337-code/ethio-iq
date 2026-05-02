# Ethio IQ Managed Broker Model - Advanced Features

## Overview
This document outlines the advanced features of the Ethio IQ Managed Broker Model, including the Subject Library, Tutor Discovery System, and Admin Panel for broker management.

---

## 1. Subject Library Integration

### Purpose
The Subject Library allows families to browse available subjects before submitting a tutor request. This creates awareness and helps families make informed decisions.

### Structure
```
features/subjects/
└── presentation/
    └── screens/
        └── subject_library_screen.dart
```

### Features
- **Core Curriculum**: Academic subjects (Math, Physics, Chemistry, Biology, English, History, Geography, Economics)
- **Beyond Curriculum**: Skill-based learning (Graphic Design, Coding, Web Development, Music, Public Speaking, Leadership)
- **Interactive Cards**: Each subject card is tappable and shows visual feedback
- **Color-Coded**: Each subject has a unique color for visual distinction

### User Flow
1. Family navigates to Dashboard
2. Clicks "5 Subjects" card in stats section
3. Browsed subjects are displayed in grid format
4. Can tap a subject to filter tutors (future enhancement)

---

## 2. Merged Tutor Navigation

### Problem Solved
Previously, tutor browsing was scattered. Now there's a single entry point for all tutor discovery.

### Implementation
```
features/tutor_profile/presentation/screens/
├── tutor_profile_screen.dart      (Individual profile view)
└── tutor_list_screen.dart         (NEW: List view with pagination)
```

### Entry Points
1. **"12 Tutors" Card** (Dashboard stats) → TutorListScreen
2. **"View Tutors" Button** (Dashboard) → TutorListScreen
3. **Bottom Navigation "Tutors" Tab** → TutorListScreen

### TutorListScreen Structure
```
TutorListScreen
├── Search Bar
├── ⭐ Top Ranked Section (Horizontal scroll)
│   └── Shows 4-6 best-rated tutors
└── All Tutors Section (Vertical list)
    ├── Paginated display (4 tutors per load)
    └── "Load More" button for pagination
```

### Data Flow
```
DashboardScreen
    ↓
TutorListScreen
    ├── Tap Top Ranked Tutor Card → TutorProfileScreen
    └── Tap All Tutors Item → TutorProfileScreen
```

---

## 3. Admin Panel (Broker Management)

### Access Control
- **Hidden Entry Point**: Only accessible if `userName == "Mengstu_Admin"`
- Shows special "Admin" badge in greeting
- "Admin Control Center" card displays in dashboard

### Admin Panel Features
- **Request Dashboard**: View all incoming family requests
- **Status Tracking**: Pending vs. Assigned requests
- **Tutor Assignment**: Dropdown to assign available tutors
- **Request History**: Track all decisions and assignments

### Request Lifecycle
```
Family submits "General Request"
    ↓
Admin Panel shows "Pending" request
    ↓
Admin clicks "Assign Tutor" → Dialog with tutor dropdown
    ↓
Admin selects tutor → Request status changes to "Assigned"
    ↓
Family receives notification (in MyRequestsScreen)
```

### Admin Features
1. **Pending Requests**: Accept or Decline
2. **Assignment**: Choose from available tutors
3. **Statistics**: Quick view of Pending/Assigned counts
4. **Request Details**: Location, grade, subject, date

---

## 4. Making Tutor Count Dynamic

### Current Static Implementation
```dart
// Dashboard stats shows hardcoded "12"
_buildStatItem('12', 'Tutors', Icons.people)
```

### Future Database Integration
When connected to a backend (Firebase, REST API, etc.):

#### Step 1: Create Data Service
```dart
// lib/features/tutors/data/tutor_service.dart
class TutorService {
  Future<int> getTutorCount() async {
    // API call to backend
    final response = await _api.get('/tutors/count');
    return response.data['count'];
  }
  
  Future<List<Tutor>> getTopRankedTutors() async {
    // API call to backend
    final response = await _api.get('/tutors/top-ranked');
    return response.data.map((t) => Tutor.fromJson(t)).toList();
  }
}
```

#### Step 2: Make Dashboard Dynamic
```dart
// Update DashboardScreen to use provider/riverpod
class _DashboardScreenState extends State<DashboardScreen> {
  late Future<int> tutorCountFuture;
  
  @override
  void initState() {
    super.initState();
    tutorCountFuture = TutorService().getTutorCount();
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: tutorCountFuture,
      builder: (context, snapshot) {
        String tutorCount = snapshot.data?.toString() ?? '12';
        return _buildStatItem(tutorCount, 'Tutors', Icons.people);
      },
    );
  }
}
```

#### Step 3: Real-time Updates with State Management
```dart
// Using Riverpod for reactive updates
final tutorCountProvider = FutureProvider<int>((ref) async {
  return await TutorService().getTutorCount();
});

// In dashboard
@override
Widget build(BuildContext context) {
  return ref.watch(tutorCountProvider).when(
    data: (count) => _buildStatItem(count.toString(), 'Tutors', Icons.people),
    loading: () => _buildStatItem('...', 'Tutors', Icons.people),
    error: (err, stack) => _buildStatItem('12', 'Tutors', Icons.people),
  );
}
```

---

## 5. Subject Library & Tutor List Connection

### Current Implementation
```
SubjectLibraryScreen
    ↓ (taps subject)
    → Future: Filter TutorListScreen by subject
```

### Future Enhancement: Subject-Based Filtering
```dart
// lib/features/tutor_profile/presentation/screens/tutor_list_screen.dart

class TutorListScreen extends StatefulWidget {
  final String? selectedSubject; // Optional subject filter
  
  const TutorListScreen({this.selectedSubject});
}

// In build:
// If selectedSubject != null, filter allTutors by subject
final filteredTutors = selectedSubject == null
    ? allTutors
    : allTutors.where((t) => t.subject == selectedSubject).toList();
```

### Navigation with Subject Filter
```dart
// From SubjectLibraryScreen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => TutorListScreen(
      selectedSubject: subject['name'],
    ),
  ),
);
```

### Connection Map
```
Dashboard
├── "5 Subjects" card
│   ↓
└── SubjectLibraryScreen
    ├── Display all subjects
    └── Tap subject
        ↓
        TutorListScreen (filtered by subject)
        ├── Show only tutors matching subject
        ├── Top Ranked section (filtered)
        └── All Tutors section (filtered)

Dashboard
├── "12 Tutors" card
│   ↓
└── TutorListScreen (no filter)
    ├── Show all tutors
    ├── Top Ranked section
    └── All Tutors section
```

---

## 6. Registration Requirement for Tutor Requests

### Implementation
```dart
void _handleRequestTutor(BuildContext context) {
  // Check if user is registered
  if (widget.userName.isEmpty || widget.userName == 'Guest') {
    // Show login/register requirement dialog
    showDialog(...);
  } else {
    // User is logged in, proceed with request
    _showTutorRequestDialog(context);
  }
}
```

### Logic Flow
```
User clicks "Submit Request"
    ↓
Check: Is userName empty or "Guest"?
    ├─ YES → Show registration dialog + redirect to login
    └─ NO → Show tutor request form
        ↓
        Submit request → Add to Pending requests
```

---

## 7. Admin User Identification

### Current Implementation
```dart
_isAdmin = widget.userName == 'Mengstu_Admin';
```

### Future Enhancement: Role-Based Access
```dart
// When database is connected
class User {
  String id;
  String name;
  UserRole role; // FAMILY, TUTOR, ADMIN
  
  bool get isAdmin => role == UserRole.admin;
  bool get isTutor => role == UserRole.tutor;
  bool get isFamily => role == UserRole.family;
}

// In Dashboard
if (user.isAdmin) {
  showAdminPanel();
}
```

---

## 8. Folder Interconnection Map (Complete)

```
lib/
├── features/
│   ├── auth/
│   │   └── presentation/screens/
│   │       └── login_screen.dart
│   │           → DashboardScreen (with userName)
│   │
│   ├── dashboard/                     [HUB]
│   │   └── presentation/screens/
│   │       └── dashboard_screen.dart
│   │           ├── "12 Tutors" card → TutorListScreen
│   │           ├── "5 Subjects" card → SubjectLibraryScreen
│   │           ├── "View Tutors" button → TutorListScreen
│   │           ├── "Request a Tutor" button → [Login check] → Dialog
│   │           ├── Bottom nav "Tutors" → TutorListScreen
│   │           ├── Bottom nav "Requests" → MyRequestsScreen
│   │           └── Admin Panel button (Mengstu_Admin only) → AdminPanelScreen
│   │
│   ├── subjects/                      [NEW]
│   │   └── presentation/screens/
│   │       └── subject_library_screen.dart
│   │           ├── Display subjects grid
│   │           └── Tap subject → TutorListScreen (filtered by subject)
│   │
│   ├── tutor_profile/
│   │   └── presentation/screens/
│   │       ├── tutor_profile_screen.dart (Individual view)
│   │       │   ├── Back → TutorListScreen (via back button)
│   │       │   └── Concierge note (no direct booking)
│   │       │
│   │       └── tutor_list_screen.dart    [NEW: Merged navigation]
│   │           ├── Search bar
│   │           ├── Top Ranked section (horizontal scroll)
│   │           ├── All Tutors section (vertical + pagination)
│   │           └── Tap tutor → TutorProfileScreen
│   │
│   ├── bookings/
│   │   └── presentation/screens/
│   │       ├── my_requests_screen.dart
│   │       │   ├── Show family's requests
│   │       │   ├── Status: Pending/Assigned
│   │       │   └── Back → DashboardScreen
│   │       │
│   │       └── admin_panel_screen.dart   [NEW]
│   │           ├── Show all incoming requests
│   │           ├── Pending/Assigned stats
│   │           ├── Assign tutor dropdown
│   │           └── Back → DashboardScreen
│   │
│   └── tutors/
│       └── (Data models and services)
│
├── core/
│   ├── theme/
│   │   └── app_theme.dart
│   ├── constants/
│   └── extensions/
│
└── main.dart
    → LoginScreen → DashboardScreen [Hub]
```

---

## 9. Data Flow Summary

### Family User Journey
```
1. Login → DashboardScreen
2. Browse subjects → SubjectLibraryScreen (optional)
3. Browse tutors → TutorListScreen → TutorProfileScreen (read-only)
4. View tutor quality, ratings, pricing
5. Click "Request a Tutor" → [Must be registered] → Dialog
6. Fill Subject/Grade/Location → Submit request
7. Request appears as "Pending" in MyRequestsScreen
8. Admin assigns tutor → Request becomes "Assigned"
9. Family sees "Tutor Assigned: [Name]" in MyRequestsScreen
```

### Admin (Broker) Journey
```
1. Login with "Mengstu_Admin" → DashboardScreen
2. See "Admin Control Center" card (hidden from families)
3. Click "Open" → AdminPanelScreen
4. View all "Pending" requests from families
5. For each request: Click "Assign Tutor"
6. Select from available tutors (dropdown)
7. Confirm assignment → Status changes to "Assigned"
8. Family receives notification (automatic)
```

---

## 10. Future Enhancements

### Short Term
- [ ] Implement subject filtering in TutorListScreen
- [ ] Add real-time notifications when tutor assigned
- [ ] Store requests in local database (SQLite)
- [ ] Add tutor availability calendar

### Medium Term
- [ ] Connect to backend API for dynamic data
- [ ] Implement real authentication system
- [ ] Add payment integration
- [ ] Create tutor dashboard
- [ ] Add rating and review system

### Long Term
- [ ] Machine learning for better tutor matching
- [ ] Video interview feature
- [ ] In-app messaging/video calls
- [ ] Analytics dashboard for family and tutor metrics
- [ ] Mobile app version

---

## Configuration & Testing

### Test Admin Access
```
Use userName: "Mengstu_Admin" during login
Expected: Admin badge + Admin Control Center card visible
```

### Test Family Access
```
Use userName: "TestFamily" during login
Expected: Regular dashboard without admin features
```

### Test Pagination
```
TutorListScreen initially shows 4 tutors
Click "Load More" → Shows 8 tutors
Click "Load More" → Shows 12 tutors (all)
```

---

## Notes

- All hardcoded data will be replaced with API calls when backend is ready
- The "Concierge Note" in TutorProfileScreen prevents direct bookings
- Admin panel is hidden from regular families (not just disabled)
- Subject filtering in TutorListScreen is prepared for implementation
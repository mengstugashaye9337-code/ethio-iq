# Ethio IQ Multi-Role System Architecture

## Overview
Ethio IQ implements a comprehensive multi-role system supporting three user types: Family (Users), Tutors, and Admins. Each role has distinct dashboards, permissions, and interactions within the platform.

## User Roles

### 1. Family (User) Role 👨‍👩‍👧‍👦
**Primary Users**: Parents and students seeking tutoring services

**Key Features**:
- Request a Tutor: Submit detailed tutoring requests
- Subject Library: Browse subjects to initiate requests
- My Requests: Track submitted requests and matches
- Browse Tutors: View available tutors

**Dashboard Focus**:
- Request submission interface
- Subject exploration for lead generation
- Request tracking and management

### 2. Tutor Role 👨‍🏫
**Service Providers**: Qualified educators offering tutoring services

**Key Features**:
- My Profile: Manage personal and professional information
- My Assignments: View and manage teaching assignments
- Earnings: Track payments and financial information
- Availability Toggle: Control assignment acceptance

**Dashboard Focus**:
- Assignment management
- Profile maintenance
- Earnings tracking
- Availability management

### 3. Admin Role 👨‍💼
**Platform Managers**: System administrators managing operations

**Key Features**:
- Total Requests: View all platform requests
- Assigning Tutors: Match tutors with student requests
- Tutor Verification: Validate tutor credentials
- Platform Analytics: Monitor system performance

**Dashboard Focus**:
- Request management and assignment
- Tutor verification workflow
- Platform oversight and analytics

## System Interactions

### Broker (Admin) as Central Coordinator
The Admin role serves as the "Broker" in the Ethio IQ ecosystem:

```
Family Requests → Admin Review → Tutor Assignment → Match Completion
      ↑                ↓                ↓
   Feedback      Verification      Service Delivery
```

**Admin Responsibilities**:
1. **Request Intake**: Receive and validate family requests
2. **Tutor Matching**: Assign qualified tutors based on subject, location, and availability
3. **Quality Assurance**: Verify tutor credentials and monitor service quality
4. **Platform Management**: Oversee system operations and user management

### Ethiopian Context Considerations
- **Universal Tutoring**: One tutor covers all subjects (Ethiopian education model)
- **Subject Library as Lead Generator**: Subjects showcase expertise rather than filter tutors
- **Location-Based Matching**: Geographic considerations for in-person tutoring
- **Quality Verification**: Emphasis on tutor credential validation

## Navigation Flow

### Registration Process
```
Login Screen → Register Option → Role Selection → Dashboard
```

### Post-Login Routing
```
Login → Role Detection → Appropriate Dashboard
Family → FamilyDashboard
Tutor → TutorDashboard
Admin → AdminDashboard
```

### Subject Library Flow (Lead Generation)
```
Subject Library → Subject Selection → Request Match Form (Pre-filled)
```

## Technical Implementation

### Role-Based Routing
- User model with `UserRole` enum
- Dashboard selection based on `user.role`
- Navigation guards for role-appropriate features

### Data Models
```dart
enum UserRole { family, tutor, admin }

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  // ... other fields
}
```

### Dashboard Architecture
- Separate dashboard widgets for each role
- Role-specific navigation and features
- Consistent theming across all dashboards

## Future Enhancements

### Planned Features
- Advanced matching algorithms
- Real-time availability updates
- Payment processing integration
- Review and rating systems
- Mobile app optimization

### Scalability Considerations
- Modular dashboard components
- Role-based permission system
- API-driven user management
- Analytics integration

## Conclusion

The Ethio IQ multi-role system provides a structured approach to connecting families with qualified tutors through an admin-mediated platform. The broker model ensures quality control while the subject library serves as an effective lead generation tool in the Ethiopian education context.
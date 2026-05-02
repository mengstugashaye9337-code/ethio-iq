# Ethio IQ Concierge Matching System

## Overview
The Concierge Matching system transforms Ethio IQ from a direct booking platform to a premium service where Ethio IQ acts as the broker, ensuring quality matches between families and tutors.

## Business Logic Flow

### 1. Family Discovery Phase
- Families browse `TutorProfileScreen` to see tutor qualifications and quality
- **No direct booking allowed** - builds trust in Ethio IQ's expertise
- Transparent pricing and ratings visible for informed decision-making

### 2. Service Request Submission
- Families submit "General Requests" via `DashboardScreen`
- Request includes: Subject, Grade Level, Location
- Request sent to Ethio IQ's concierge system (backend processing)

### 3. Concierge Matching Process
- Ethio IQ reviews request against tutor database
- Considers: Subject expertise, grade level compatibility, location, availability
- Quality verification: Background checks, teaching credentials, performance history
- Manual matching by education specialists

### 4. Assignment & Notification
- Once match is verified, status changes from "Pending" to "Assigned"
- Family receives notification with assigned tutor details
- Tutor also notified of assignment

### 5. Service Delivery
- Families can view assigned tutors in "My Service Requests"
- Direct communication facilitated through Ethio IQ platform
- Quality monitoring and support throughout engagement

## Folder Interconnection Map

```
lib/
├── features/
│   ├── auth/                          # User authentication
│   │   └── presentation/screens/
│   │       └── login_screen.dart      # → DashboardScreen
│   │
│   ├── dashboard/                     # Main hub after login
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   └── dashboard_screen.dart
│   │   │   │       ├── → tutor_profile (Browse tutors)
│   │   │   │       ├── → bookings (View requests)
│   │   │   │       └── → Show "Request a Tutor" dialog
│   │   │   └── widgets/
│   │
│   ├── tutor_profile/                 # Tutor browsing (read-only)
│   │   └── presentation/screens/
│   │       └── tutor_profile_screen.dart
│   │           └── Shows concierge note instead of booking
│   │
│   ├── bookings/                      # Service requests management
│   │   └── presentation/screens/
│   │       └── my_requests_screen.dart
│   │           └── Shows Pending/Assigned status
│   │
│   └── tutors/                        # Tutor data/models
│
├── core/
│   ├── theme/
│   │   └── app_theme.dart             # UI constants (warningColor, successColor)
│   ├── constants/
│   └── extensions/
│
└── screens/                           # Legacy screens (being phased out)
    ├── booking_screen.dart           # Old direct booking (deprecated)
    ├── home_screen.dart              # Old home (deprecated)
    └── payment_screen.dart           # Payment processing
```

## Key Changes Made

### 1. TutorProfileScreen (`features/tutor_profile/`)
- **Removed**: "Book Now" button
- **Added**: Concierge note explaining Ethio IQ matching
- **Purpose**: Build trust without allowing direct bookings

### 2. DashboardScreen (`features/dashboard/`)
- **Added**: Prominent "Request a Tutor" action card
- **Added**: Dialog form for Subject/Grade/Location
- **Updated**: Stats show "Requests" instead of "Bookings"
- **Added**: Bottom navigation with functional Requests tab

### 3. MyRequestsScreen (`features/bookings/`)
- **Created**: New screen for service requests
- **Features**: Status indicators (Pending/Assigned)
- **Colors**: `AppTheme.warningColor` for pending, `AppTheme.successColor` for assigned
- **Content**: Shows concierge matching workflow

## Data Flow

```
LoginScreen → DashboardScreen → [Browse Tutors] → TutorProfileScreen
                        ↓
               [Request Tutor] → Dialog → Submit General Request
                        ↓
            MyRequestsScreen ← Shows Pending → Assigned status
```

## Status Definitions

- **Pending**: `"Ethio IQ is finding your perfect match."`
- **Assigned**: `"Tutor Assigned: [Tutor Name]. Ethio IQ has verified this match."`

## Benefits of Concierge Model

1. **Quality Assurance**: Ethio IQ vets all matches
2. **Trust Building**: Families see tutor quality before requesting
3. **Scalability**: Broker model allows better resource allocation
4. **Support**: Ongoing concierge support during engagements
5. **Premium Positioning**: Positions Ethio IQ as education experts
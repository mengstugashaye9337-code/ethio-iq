# FIFO Operations Model - Implementation Guide

## Overview
This document describes the FIFO (First-In-First-Out) operations model implemented for Ethio IQ, which enables the Admin to manage queues for both Family Requests and Tutor Applications, with a centralized chat system.

---

## 1. Models & Data Structures

### 1.1 ChatMessage Model (`lib/models/chat_message.dart`)
Handles all conversations between Admin, Tutors, and Families.

**Key Fields:**
- `id`: Unique identifier
- `senderId` / `receiverId`: User identifiers
- `senderName` / `receiverName`: Display names
- `text`: Message content
- `timestamp`: When the message was sent
- `conversationType`: 'recruitment', 'matching', or 'requirements'
- `isRead`: Message read status

**Usage:** Used by the centralized chat system to track all conversations.

### 1.2 ClientRequest Model (`lib/models/client_request.dart`)
Represents family service requests in the FIFO queue.

**Key Fields:**
- `id`: Unique request identifier
- `familyName` / `familyEmail`: Family contact info
- `subject`: Request topic
- `message`: Request description
- `createdAt`: Request timestamp (used for FIFO sorting)
- `status`: 'pending', 'in_progress', 'resolved'
- `queueNumber`: Position in queue

**Special Methods:**
- `waitDuration`: Calculates how long the request has been waiting
- `waitTimeString`: Human-readable wait time (e.g., "Waiting 2 hours 30 min")

### 1.3 TutorApplication Model (`lib/models/tutor_application.dart`)
Represents tutor applications in the recruitment FIFO queue.

**Key Fields:**
- `id`: Unique application identifier
- `tutorName` / `tutorEmail`: Tutor contact info
- `subject`: Teaching subject
- `experience` / `qualification`: Tutor credentials
- `appliedAt`: Application timestamp (used for FIFO sorting)
- `status`: 'pending', 'reviewing', 'approved', 'rejected'
- `queueNumber`: Position in queue

**Special Methods:**
- `waitDuration`: Time since application
- `waitTimeString`: Human-readable display (e.g., "Applied 3 hours ago")

---

## 2. Centralized Chat System

### 2.1 ChatScreen (`lib/features/chat/chat_screen.dart`)
Reusable chat interface supporting three conversation types.

**Features:**
- Real-time message display with sender/receiver distinction
- Topic-based conversations (Recruitment/Matching/Requirements)
- Conversation type badges
- Mock message responses (simulates user interaction)
- Timestamp formatting
- Responsive layout

**Conversation Types:**
1. **Recruitment**: Admin ↔ Tutor (about applications/exams)
2. **Matching**: Admin ↔ Family (about tutor-family matching)
3. **Requirements**: Admin ↔ Family (about specific needs)

**Constructor Parameters:**
```dart
ChatScreen(
  conversationId: 'family_123',           // Unique conversation ID
  otherUserId: 'family_email@example.com', // Other participant ID
  otherUserName: 'Abebe Family',           // Display name
  conversationType: 'matching',             // 'recruitment', 'matching', or 'requirements'
  currentUserId: 'admin_001',              // Current user ID
  currentUserName: 'Ethio IQ Admin',       // Current user display name
)
```

---

## 3. Admin Dashboard

### 3.1 AdminDashboard (`lib/screens/admin/admin_dashboard.dart`)
Main admin interface with tabbed navigation.

**Tab 1: Client Requests (FIFO Queue)**
- Displays all family requests sorted by `createdAt` (earliest first)
- Each request card shows:
  - Queue number badge with wait time (e.g., "Request #1 - Waiting 2 hours")
  - Family name and request subject
  - Message preview
  - Status indicator (pending/in_progress/resolved)
  - "Chat with Family" button → Opens ChatScreen for matching/requirements

**Tab 2: Tutor Applications (FIFO Queue)**
- Displays all tutor applications sorted by `appliedAt` (earliest first)
- Each application card shows:
  - Queue number badge with application time (e.g., "Application #1 - Applied 3 hours ago")
  - Tutor name and teaching subject
  - Experience and qualification details
  - Status indicator (pending/reviewing/approved/rejected)
  - "Chat with Applicant" button → Opens ChatScreen for recruitment

**Status Color Coding:**
- Grey: Pending
- Orange: In Progress / Reviewing
- Green: Approved / Resolved
- Red: Rejected

---

## 4. User Dashboards

### 4.1 FamilyDashboard (`lib/screens/admin/family_dashboard.dart`)
Dashboard for family users.

**Features:**
- Welcome card with soft blue gradient
- Quick stats cards:
  - Active requests count
  - Pending matches count
  - Completed sessions count
- "Message Admin" button in AppBar
  - Opens ChatScreen with 'requirements' conversation type
  - Allows families to reach Ethio IQ Office directly

**Navigation:**
- Family → Message Admin → ChatScreen (requirements type)

### 4.2 TutorDashboard (`lib/screens/admin/tutor_dashboard.dart`)
Dashboard for tutor users.

**Features:**
- Welcome card with soft blue gradient
- Quick stats cards:
  - Scheduled sessions count
  - Student rating
  - Total hours taught
- Application status display (verified/pending/rejected)
- "Message Admin" button in AppBar
  - Opens ChatScreen with 'recruitment' conversation type
  - Allows tutors to reach Ethio IQ Office directly

**Navigation:**
- Tutor → Message Admin → ChatScreen (recruitment type)

---

## 5. FIFO Queue Implementation Details

### 5.1 Sorting Mechanism
Both queues use the following sorting:

```dart
// Client Requests (sorted by createdAt)
final sortedRequests = List<ClientRequest>.from(clientRequests)
  ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

// Tutor Applications (sorted by appliedAt)
final sortedApplications = List<TutorApplication>.from(tutorApplications)
  ..sort((a, b) => a.appliedAt.compareTo(b.appliedAt));
```

**Result:** Earliest requests/applications appear first (FIFO principle).

### 5.2 Queue Number Assignment
Queue numbers are assigned based on creation order:
- Request #1, #2, #3... (sequential by creation time)
- Application #1, #2, #3... (sequential by application time)

Queue numbers help users understand their position and estimated wait time.

---

## 6. Communication Flow

### Admin ↔ Family
```
Family (FamilyDashboard)
    ↓
[Message Admin Button]
    ↓
ChatScreen (conversationType: 'requirements')
    ↓
Mock conversation storage
```

### Admin ↔ Tutor
```
Tutor (TutorDashboard)
    ↓
[Message Admin Button]
    ↓
ChatScreen (conversationType: 'recruitment')
    ↓
Mock conversation storage
```

### Admin Controls
```
AdminDashboard
    ├── Tab 1: Client Requests (FIFO)
    │   └── [Chat with Family] → ChatScreen (matching)
    │
    └── Tab 2: Tutor Applications (FIFO)
        └── [Chat with Applicant] → ChatScreen (recruitment)
```

---

## 7. Integration Instructions

### Step 1: Import Required Files
```dart
import 'lib/models/chat_message.dart';
import 'lib/models/client_request.dart';
import 'lib/models/tutor_application.dart';
import 'lib/features/chat/chat_screen.dart';
import 'lib/screens/admin/admin_dashboard.dart';
import 'lib/screens/admin/family_dashboard.dart';
import 'lib/screens/admin/tutor_dashboard.dart';
```

### Step 2: Add Navigation Routes
Update `lib/main.dart` to include routes:
```dart
routes: {
  '/admin-dashboard': (context) => const AdminDashboard(),
  '/family-dashboard': (context) => FamilyDashboard(
    familyId: 'family_001',
    familyName: 'Abebe Family',
    familyEmail: 'abebe@example.com',
  ),
  '/tutor-dashboard': (context) => TutorDashboard(
    tutorId: 'tutor_001',
    tutorName: 'Yohannes Assefa',
    tutorEmail: 'yohannes@example.com',
  ),
}
```

### Step 3: Use Theme System
All dashboards and chat screens use `AppTheme` for consistency:
- Primary color: Soft blue (#6C8DFF)
- Light accent: (#B6C7FF)
- Background: Light grey-blue (#F7F9FC)

---

## 8. Data Flow Overview

```
┌─────────────────────────────────────────────┐
│          Ethio IQ Operations Model           │
└─────────────────────────────────────────────┘

                    ↓

        ┌───────────────────────┐
        │   Admin Dashboard     │
        ├───────────────────────┤
        │ Tab 1: Client Queue   │
        │ Tab 2: Tutor Queue    │
        └───────────────────────┘
                ↓
        ┌───────────────────────┐
        │   ChatScreen Module   │
        ├───────────────────────┤
        │ - Message Storage     │
        │ - Conversation Types  │
        │ - Mock Responses      │
        └───────────────────────┘
                ↓
        ┌───────────────────────┐
        │   User Dashboards     │
        ├───────────────────────┤
        │ - Family Dashboard    │
        │ - Tutor Dashboard     │
        │ - Message Admin Btn   │
        └───────────────────────┘
```

---

## 9. Key Features Implemented

✓ **FIFO Queues**: Both client requests and tutor applications sorted by creation time
✓ **Queue Visualization**: Visual badges showing queue number and wait time
✓ **Centralized Chat**: Single ChatScreen component handling all conversation types
✓ **Two-way Communication**: Admin can chat with families and tutors independently
✓ **User Dashboards**: Family and Tutor dashboards with direct admin messaging
✓ **Status Tracking**: Multiple status states for both requests and applications
✓ **Mock Data**: Pre-populated with realistic sample data
✓ **Responsive Design**: Works across different screen sizes using AppTheme

---

## 10. Future Enhancements

- Real-time messaging with Firebase Firestore
- Message notifications and push alerts
- File sharing in chat (documents, certificates)
- Chat search and message history
- Automated queue management based on response time
- Admin reassignment of queue items
- Rate limiting and priority tiers
- Conversation analytics and insights

---

## 11. File Structure

```
lib/
├── models/
│   ├── chat_message.dart           # Chat message model
│   ├── client_request.dart         # Family request model
│   └── tutor_application.dart      # Tutor application model
│
├── features/
│   └── chat/
│       └── chat_screen.dart        # Centralized chat component
│
└── screens/
    └── admin/
        ├── admin_dashboard.dart    # Admin queue management
        ├── family_dashboard.dart   # Family user dashboard
        └── tutor_dashboard.dart    # Tutor user dashboard
```

---

## Version: 1.0
Last Updated: May 8, 2026

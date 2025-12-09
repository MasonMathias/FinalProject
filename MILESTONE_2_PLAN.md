# Milestone 2 Implementation Plan

## Overview
Milestone 2 focuses on implementing full functionality, database integration, and testing. This document breaks down tasks by area.

---

## 🔐 Authentication (Skip for now - handle separately)

**Status:** ⏸️ To be handled separately

**Tasks:**
- [ ] Firebase project setup
- [ ] Firebase Authentication configuration
- [ ] Email/Password authentication
- [ ] User registration flow
- [ ] Login flow
- [ ] Sign out functionality
- [ ] Password reset
- [ ] Auth state management

**Note:** Since you mentioned you can't do authentication, this can be handled by your partner (Andrew) or we can tackle it together later.

---

## 📊 Database Setup & Models (Your Part)

### 1. Firebase Project Setup
- [ ] Create Firebase project in Firebase Console
- [ ] Add Flutter app to Firebase project
- [ ] Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
- [ ] Add Firebase configuration files to project
- [ ] Install Firebase packages in `pubspec.yaml`:
  ```yaml
  firebase_core: ^latest
  cloud_firestore: ^latest
  firebase_auth: ^latest  # (Even if you're not implementing auth, it's needed)
  ```

### 2. Data Models
Create Dart model classes for your data structures:

**Files to create:**
- `lib/models/mood_entry.dart` - For mood tracking data
- `lib/models/journal_entry.dart` - For journal entries
- `lib/models/reminder.dart` - For wellness reminders
- `lib/models/user_profile.dart` - For user settings/preferences

**Example structure for `mood_entry.dart`:**
```dart
class MoodEntry {
  final String id;
  final String userId;
  final String mood; // 'great', 'good', 'okay', 'down', 'struggling'
  final String? note;
  final DateTime timestamp;
  
  // Constructor, toMap, fromMap methods
  // This will be used to save/load from Firestore
}
```

---

## 🎯 Core Features Implementation (Your Part)

### 3. Mood Tracking - Full Functionality
**File:** `lib/pages/mood_tracking_page.dart`

**Tasks:**
- [ ] Connect mood selection to save to Firestore
- [ ] Create `MoodEntry` model
- [ ] Implement save functionality
- [ ] Add loading states
- [ ] Show success/error messages
- [ ] Prevent duplicate entries for same day
- [ ] Load existing mood for today (if already logged)

**Firestore Collection:** `mood_entries`
**Document Structure:**
```json
{
  "userId": "user123",
  "mood": "good",
  "note": "Feeling okay today",
  "timestamp": "2025-01-15T10:30:00Z"
}
```

### 4. Journal Entry - Full Functionality
**File:** `lib/pages/journal_entry_page.dart`

**Tasks:**
- [ ] Connect form to save to Firestore
- [ ] Create `JournalEntry` model
- [ ] Implement save functionality
- [ ] Add loading states
- [ ] Implement tag system (save tags with entry)
- [ ] Add edit functionality (load existing entries)
- [ ] Add delete functionality
- [ ] Create list view of past entries

**Firestore Collection:** `journal_entries`
**Document Structure:**
```json
{
  "userId": "user123",
  "title": "My Journal Entry",
  "content": "Today I felt...",
  "tags": ["gratitude", "reflection"],
  "timestamp": "2025-01-15T10:30:00Z"
}
```

### 5. Analytics - Data Visualization
**File:** `lib/pages/analytics_page.dart`

**Tasks:**
- [ ] Install chart library (e.g., `fl_chart` or `charts_flutter`)
- [ ] Fetch mood data from Firestore
- [ ] Calculate statistics (average mood, days tracked, etc.)
- [ ] Create mood trend chart (line/bar chart)
- [ ] Display real statistics in stat cards
- [ ] Show weekly summary with actual data
- [ ] Add date range filtering

**Dependencies to add:**
```yaml
fl_chart: ^latest  # or charts_flutter
```

**Data Queries:**
- Query mood entries by date range
- Aggregate mood data by week/month
- Count journal entries
- Calculate averages

### 6. Reminders - Local Notifications
**File:** `lib/pages/reminders_page.dart`

**Tasks:**
- [ ] Install local notifications package
- [ ] Create `Reminder` model
- [ ] Save reminders to Firestore (for sync across devices)
- [ ] Implement local notification scheduling
- [ ] Handle notification permissions
- [ ] Create notification service
- [ ] Implement reminder editing
- [ ] Implement reminder deletion
- [ ] Add smart timing suggestions (optional)

**Dependencies to add:**
```yaml
flutter_local_notifications: ^latest
```

**Firestore Collection:** `reminders`
**Document Structure:**
```json
{
  "userId": "user123",
  "type": "Journal Entry",
  "message": "Time to journal!",
  "time": "09:00",
  "enabled": true,
  "createdAt": "2025-01-15T10:30:00Z"
}
```

### 7. Settings - Data Persistence
**File:** `lib/pages/settings_page.dart`

**Tasks:**
- [ ] Save settings to Firestore or SharedPreferences
- [ ] Load settings on app start
- [ ] Implement theme switching (if adding light mode)
- [ ] Implement language switching
- [ ] Connect sign out button to auth
- [ ] Implement data export (generate JSON/CSV)
- [ ] Add profile editing functionality

**Dependencies to add:**
```yaml
shared_preferences: ^latest  # For local settings
```

---

## 🔄 State Management (Your Part)

### 8. Choose and Implement State Management
**Options:**
- Provider (easiest, recommended for beginners)
- Riverpod (modern alternative)
- Bloc (more complex, but powerful)

**Recommended:** Provider

**Tasks:**
- [ ] Install Provider package
- [ ] Create providers for:
  - [ ] Mood data provider
  - [ ] Journal entries provider
  - [ ] Reminders provider
  - [ ] Settings provider
- [ ] Replace setState with Provider where appropriate
- [ ] Implement real-time listeners for Firestore

**Dependencies:**
```yaml
provider: ^latest
```

---

## 🧪 Testing (Your Part)

### 9. Testing Implementation
**Tasks:**
- [ ] Write unit tests for models
- [ ] Write unit tests for providers/services
- [ ] Write widget tests for key pages
- [ ] Test Firestore read/write operations
- [ ] Test error handling
- [ ] Test offline functionality (if implementing)

**Files to create:**
- `test/models/mood_entry_test.dart`
- `test/models/journal_entry_test.dart`
- `test/services/mood_service_test.dart`
- `test/widgets/mood_tracking_page_test.dart`

---

## 🚀 Services Layer (Your Part)

### 10. Create Service Classes
Organize Firebase operations into service classes:

**Files to create:**
- `lib/services/mood_service.dart` - Handle mood entry CRUD
- `lib/services/journal_service.dart` - Handle journal entry CRUD
- `lib/services/reminder_service.dart` - Handle reminder CRUD
- `lib/services/analytics_service.dart` - Handle analytics calculations
- `lib/services/notification_service.dart` - Handle local notifications

**Example structure for `mood_service.dart`:**
```dart
class MoodService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<void> saveMoodEntry(MoodEntry entry) async {
    // Save to Firestore
  }
  
  Stream<List<MoodEntry>> getMoodEntries(String userId) {
    // Return stream of mood entries
  }
  
  // Other CRUD operations
}
```

---

## 📱 UI Enhancements (Your Part)

### 11. Polish Existing UI
**Tasks:**
- [ ] Add loading indicators
- [ ] Add error states
- [ ] Add empty states
- [ ] Improve animations
- [ ] Add pull-to-refresh
- [ ] Add search functionality for journal entries
- [ ] Add filtering for mood entries

---

## 🔒 Security Rules (Your Part)

### 12. Firestore Security Rules
**File:** `firestore.rules` (in Firebase Console)

**Tasks:**
- [ ] Write security rules to protect user data
- [ ] Ensure users can only access their own data
- [ ] Test security rules

**Example rules:**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /mood_entries/{entryId} {
      allow read, write: if request.auth != null && 
        request.resource.data.userId == request.auth.uid;
    }
    // Similar rules for other collections
  }
}
```

---

## 📋 Suggested Implementation Order

1. **Week 1:**
   - Firebase setup
   - Create data models
   - Implement mood tracking functionality
   - Implement journal entry functionality

2. **Week 2:**
   - Implement reminders with notifications
   - Implement analytics with charts
   - Add state management (Provider)

3. **Week 3:**
   - Settings persistence
   - UI polish
   - Testing
   - Bug fixes

---

## 🛠️ Dependencies to Add

Add these to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Firebase
  firebase_core: ^3.0.0
  cloud_firestore: ^5.0.0
  firebase_auth: ^5.0.0  # Even if not implementing auth yourself
  
  # State Management
  provider: ^6.1.0
  
  # Charts
  fl_chart: ^0.68.0
  
  # Notifications
  flutter_local_notifications: ^17.0.0
  
  # Local Storage
  shared_preferences: ^2.2.0
  
  # Utilities
  intl: ^0.19.0  # For date formatting
  
  cupertino_icons: ^1.0.8
```

---

## 📝 Notes

- **Authentication:** Since you can't do this part, coordinate with your partner (Andrew) or we can implement it together later
- **Focus Areas:** You can focus on the core features (mood tracking, journal, analytics, reminders) while authentication is handled separately
- **Testing:** Make sure to test on real devices, not just emulators
- **Documentation:** Update README as you implement features

---

## ✅ Milestone 2 Checklist

- [ ] Firebase project created and configured
- [ ] All data models created
- [ ] Mood tracking fully functional
- [ ] Journal entries fully functional
- [ ] Analytics with real charts
- [ ] Reminders with notifications
- [ ] Settings persistence
- [ ] State management implemented
- [ ] Testing completed
- [ ] Security rules configured
- [ ] Code documented
- [ ] README updated

---

**Remember:** You can work on all the features above while authentication is handled separately. The features can be built to work with a placeholder user ID initially, and then connected to real authentication later.


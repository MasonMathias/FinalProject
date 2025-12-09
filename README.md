# Mental Zen - Mental Wellness Journal

A private, secure harbor for your thoughts and emotions, providing gentle insights through structured journaling and mood tracking to help users understand their inner world and cultivate lasting mental wellness.

## 📱 Project Overview

Mental Zen is a Flutter mobile application designed to support mental wellness through:
- **Daily Mood Tracking** - Log and track your emotional state over time
- **Journal Entries** - Express your thoughts in a safe, private space
- **Analytics & Insights** - Visualize patterns in your wellness journey
- **Customizable Reminders** - Set gentle reminders for journaling, breathing exercises, and positive affirmations
- **Mindfulness Resources** - Access tools to support your mental wellness

## 👥 Team Members

- **Mason Mathias**
- **Andrew Alvarez**

## 🔗 Repository

GitHub: [https://github.com/MasonMathias/FinalProject](https://github.com/MasonMathias/FinalProject)

## 🎯 Project Status

### Milestone 1: ✅ COMPLETE
- UI Design & Layout
- Navigation Structure
- Theme Configuration
- All Feature Pages (UI Only)

### Milestone 2: ✅ COMPLETE
- ✅ Firebase Integration (Firestore)
- ⏳ Authentication System (Placeholder in place)
- ✅ Database Implementation
- ✅ Full Functionality
- ✅ State Management (Provider)
- ✅ Real-time Data Updates
- ✅ Analytics with Charts
- ✅ Local Notifications

## 🛠️ Technology Stack

- **Framework:** Flutter (Dart)
- **Backend:** Firebase
  - Firestore (Database) ✅
  - Authentication (Placeholder) ⏳
  - Cloud Storage
- **State Management:** Provider ✅
- **Charts:** fl_chart ✅
- **Notifications:** flutter_local_notifications ✅

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── theme/
│   └── app_theme.dart        # Theme configuration
└── pages/
    ├── home_page.dart        # Main navigation hub
    ├── mood_tracking_page.dart
    ├── journal_entry_page.dart
    ├── analytics_page.dart
    ├── reminders_page.dart
    └── settings_page.dart
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- An emulator or physical device for testing

### Installation

1. Clone the repository:
```bash
git clone https://github.com/MasonMathias/FinalProject.git
cd FinalProject
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 📋 Features (Milestone 2 - Fully Functional)

### Home Page
- Central navigation hub with feature cards
- Beautiful gradient cards for each feature
- Quick access to all app sections

### Mood Tracking ✅
- Visual mood selection with emojis
- Save to Firestore
- Load existing entries
- Update today's mood
- Real-time updates

### Journal Entries ✅
- Create, edit, delete entries
- Rich text input
- Tag system (fully functional)
- Search functionality
- List view of all entries
- Full CRUD operations

### Analytics ✅
- Real charts (line chart, pie chart)
- 7-day mood trend visualization
- Mood distribution analysis
- Statistics cards with real data
- Weekly summary
- Real-time updates

### Reminders ✅ (Signature Feature)
- Create customizable reminders
- Save to Firestore
- Local notifications (daily repeating)
- Multiple reminder types
- Custom messages
- Delete reminders

### Settings ✅
- Settings persistence (SharedPreferences)
- Notification preferences
- Appearance settings
- Language selection
- Privacy & data management

## 🎨 Design Theme

Mental Zen uses a calming dark theme with:
- **Primary Colors:** Purple (#6B46C1) and Blue (#3B82F6)
- **Accent Color:** Pink (#EC4899)
- **Background:** Dark (#1E1B2E) with card backgrounds (#2D2A3E)
- **Typography:** Clean, readable fonts with proper hierarchy

## 📝 Development Notes

### Milestone 1 Focus
- Complete UI/UX design
- Navigation structure
- Theme consistency
- Placeholder functionality

### Milestone 2 Plans
- Firebase project setup
- Authentication implementation
- Firestore database integration
- Real-time data synchronization
- Local notifications for reminders
- Chart library integration for analytics
- Testing and bug fixes

## 🤖 AI Usage

This project used AI assistance for implementation guidance. See [AI_USAGE_LOG.md](AI_USAGE_LOG.md) for detailed documentation of all AI interactions.

## 📄 License

This project is part of a Flutter & Firebase course assignment.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- Course instructors for project guidance

---

## 🚀 Getting Started with Firebase

The app currently uses placeholder authentication. To enable Firebase:

1. See `FIREBASE_SETUP.md` for detailed instructions
2. Run `flutterfire configure`
3. Uncomment Firebase initialization in `main.dart`

The app works perfectly with placeholder data, but Firebase enables cloud sync and real authentication.

## 📚 Documentation

- `MILESTONE_2_COMPLETE.md` - Complete implementation summary
- `FIREBASE_SETUP.md` - Firebase setup guide
- `AUTHENTICATION_TASKS.md` - Authentication implementation guide
- `MILESTONE_2_PLAN.md` - Original implementation plan

---

**Note:** Milestone 2 is complete! Authentication uses a placeholder and can be swapped in when ready.

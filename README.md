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
- ✅ Authentication System (Full Firebase Auth)
- ✅ Database Implementation
- ✅ Full Functionality
- ✅ State Management (Provider)
- ✅ Real-time Data Updates
- ✅ Analytics with Charts
- ✅ Local Notifications
- ✅ Profile Management

## 🛠️ Technology Stack

- **Framework:** Flutter (Dart)
- **Backend:** Firebase
  - Firestore (Database) ✅
  - Authentication (Full Implementation) ✅
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

### For Teammates / New Developers

**📖 See [SETUP_GUIDE.md](SETUP_GUIDE.md) for complete setup instructions!**

Quick summary:
1. Install Flutter SDK (3.9.2+)
2. Clone the repository
3. Run `flutter pub get`
4. **Create `.env` file with Firebase credentials** (see SETUP_GUIDE.md)
5. Run `flutter run`

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- An emulator or physical device for testing
- **Firebase project access** (get credentials from team lead)

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

3. **Create `.env` file** (required for Firebase):
   - Copy the format from `SETUP_GUIDE.md`
   - Get Firebase credentials from your teammate
   - Place `.env` file in project root
   - **Note:** `.env` is in `.gitignore` and won't be in the repo

4. Run the app:
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

## 📚 Documentation

- **[DESIGN_DOCUMENTATION.md](DESIGN_DOCUMENTATION.md)** - Comprehensive design documentation including wireframes, UML diagrams, architecture design, and design reasoning
- **[TEAM_COLLABORATION_LOG.md](TEAM_COLLABORATION_LOG.md)** - Team collaboration activities, shared responsibilities, and teamwork documentation
- **[REFLECTION_AND_LEARNING_SUMMARY.md](REFLECTION_AND_LEARNING_SUMMARY.md)** - Project reflection, learning outcomes, challenges, and lessons learned
- **[AI_USAGE_LOG.md](AI_USAGE_LOG.md)** - Documentation of AI assistance usage during development
- **[SETUP_GUIDE.md](SETUP_GUIDE.md)** - Complete setup instructions for new developers
- **[FIREBASE_SETUP.md](FIREBASE_SETUP.md)** - Firebase configuration and setup guide

## 🚀 Getting Started with Firebase

The app uses full Firebase Authentication and Firestore:

1. See `FIREBASE_SETUP.md` for detailed instructions
2. Ensure `.env` file exists with Firebase API keys (see `SETUP_GUIDE.md`)
3. Firebase is fully configured and working

**Note:** Make sure to create a `.env` file with your Firebase credentials. See `SETUP_GUIDE.md` for the format.

## 📄 License

This project is part of a Flutter & Firebase course assignment.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- Course instructors for project guidance

---

**Note:** Milestone 2 is complete! All features are fully functional including:
- ✅ Full Firebase Authentication (login/signup)
- ✅ Profile management
- ✅ Working notifications
- ✅ All core features (mood tracking, journal, analytics, reminders)
- ✅ Secure API key management

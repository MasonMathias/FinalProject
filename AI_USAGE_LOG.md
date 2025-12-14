# AI Usage Log - Mental Zen Project

**Project:** Mental Zen - Mental Wellness Journal  
**Team Members:** Mason Mathias, Andrew Alvarez

---

## Purpose

This document tracks the use of AI assistance tools during the development of the Mental Zen application. All AI-generated code has been reviewed, understood, and integrated by the team members.

---

## AI Usage Entries

### Entry 1: Project Structure Setup
**Question Asked:** "How should I structure a Flutter app with multiple pages and a consistent theme?"  
**AI Tool Used:** Cursor AI Assistant  
**Response Summary:** AI suggested creating separate directories for pages, theme, and models. Recommended using a theme file for consistent styling across the app.  
**Code Generated:** Theme configuration file (`lib/theme/app_theme.dart`)  
**Team Review:** ✅ Reviewed and understood by both team members  
**Modifications Made:** Adjusted color scheme to match Mental Zen branding (purple/blue palette)

---

### Entry 2: Navigation Implementation
**Question Asked:** "What's the best way to implement navigation between multiple screens in Flutter for a mental wellness app?"  
**AI Tool Used:** Cursor AI Assistant  
**Response Summary:** AI recommended using Navigator.push with MaterialPageRoute for simple navigation. Suggested using a home page as the central hub with cards linking to feature pages.  
**Code Generated:** Home page navigation structure (`lib/pages/home_page.dart`)  
**Team Review:** ✅ Reviewed and understood by both team members  
**Modifications Made:** Customized card designs with gradient backgrounds and icons specific to each feature

---

### Entry 3: Mood Tracking UI Design
**Question Asked:** "How can I create an intuitive mood selection interface with emojis and visual feedback?"  
**AI Tool Used:** Cursor AI Assistant  
**Response Summary:** AI suggested using a GridView with selectable mood cards. Recommended using state management to track selected mood and visual feedback through border colors.  
**Code Generated:** Mood tracking page UI (`lib/pages/mood_tracking_page.dart`)  
**Team Review:** ✅ Reviewed and understood by both team members  
**Modifications Made:** Added custom mood options and styling to match app theme

---

### Entry 4: Journal Entry Form
**Question Asked:** "What's the best practice for creating a multi-line text input for journal entries with proper text field controllers?"  
**AI Tool Used:** Cursor AI Assistant  
**Response Summary:** AI explained TextEditingController usage and proper disposal. Suggested using TextField with maxLines for journal content and proper form validation.  
**Code Generated:** Journal entry page (`lib/pages/journal_entry_page.dart`)  
**Team Review:** ✅ Reviewed and understood by both team members  
**Modifications Made:** Added date display, tag chips, and custom styling

---

### Entry 5: Analytics Dashboard Layout
**Question Asked:** "How should I structure a dashboard page with placeholder charts and statistics cards?"  
**AI Tool Used:** Cursor AI Assistant  
**Response Summary:** AI recommended using Card widgets in a grid layout for statistics. Suggested placeholder containers for charts that will be implemented in Milestone 2.  
**Code Generated:** Analytics page (`lib/pages/analytics_page.dart`)  
**Team Review:** ✅ Reviewed and understood by both team members  
**Modifications Made:** Customized stat cards with icons and colors, added AI insights section placeholder

---

### Entry 6: Firebase Integration
**Question Asked:** "How do I integrate Firebase Firestore with Flutter and implement real-time data updates?"  
**AI Tool Used:** Cursor AI Assistant  
**Response Summary:** AI explained Firebase initialization, Firestore setup, and stream-based real-time updates. Provided examples of CRUD operations and security rules.  
**Code Generated:** Service layer files (MoodService, JournalService, ReminderService)  
**Team Review:** ✅ Reviewed and understood by both team members  
**Modifications Made:** Customized data models and query patterns for our specific use cases

---

### Entry 7: State Management with Provider
**Question Asked:** "How should I implement state management using Provider pattern with Firestore streams?"  
**AI Tool Used:** Cursor AI Assistant  
**Response Summary:** AI explained Provider setup, ChangeNotifier implementation, and integrating Firestore streams with providers.  
**Code Generated:** Provider files (MoodProvider, JournalProvider, ReminderProvider)  
**Team Review:** ✅ Reviewed and understood by both team members  
**Modifications Made:** Adapted to our specific data models and business logic

---

### Entry 8: Local Notifications
**Question Asked:** "How do I implement scheduled local notifications for reminders in Flutter?"  
**AI Tool Used:** Cursor AI Assistant  
**Response Summary:** AI explained flutter_local_notifications setup, permission handling, and scheduling daily repeating notifications.  
**Code Generated:** ReminderService notification implementation  
**Team Review:** ✅ Reviewed and understood by both team members  
**Modifications Made:** Customized notification messages and scheduling logic

---

### Entry 9: Chart Implementation
**Question Asked:** "How do I create charts in Flutter using fl_chart library for mood analytics?"  
**AI Tool Used:** Cursor AI Assistant  
**Response Summary:** AI provided examples of line charts and pie charts using fl_chart, including data formatting and styling.  
**Code Generated:** Chart widgets in AnalyticsPage  
**Team Review:** ✅ Reviewed and understood by both team members  
**Modifications Made:** Customized colors and data processing for mood trends

---

### Entry 10: Authentication Flow
**Question Asked:** "What's the best way to implement Firebase Authentication with state management?"  
**AI Tool Used:** Cursor AI Assistant  
**Response Summary:** AI explained Firebase Auth setup, auth state listeners, and integrating with Provider for state management.  
**Code Generated:** AuthProvider and login/signup pages  
**Team Review:** ✅ Reviewed and understood by both team members  
**Modifications Made:** Customized UI and error handling

---

## Summary

**Total AI Interactions:** 10  
**Files Created/Modified with AI Assistance:** 15+  
**Team Understanding:** All code has been reviewed and understood by both team members  
**Original Work:** All UI designs, color schemes, and feature layouts are original to the team  
**AI Contribution:** AI was used primarily for Flutter best practices, code structure suggestions, and implementation patterns

---

## Team Statement

We, Mason Mathias and Andrew Alvarez, acknowledge that we have used AI assistance tools during the development of this project. All AI-generated code has been:

1. Reviewed and understood by both team members
2. Modified and customized to fit our specific project requirements
3. Integrated with our own original design and implementation decisions
4. Tested to ensure it works correctly within our application

We understand that the use of AI tools is documented and that we are responsible for understanding all code in our project.

**Signed:**  
Mason Mathias  
Andrew Alvarez

---

## Notes

- All AI usage was for learning and implementation guidance
- No code was copied directly without understanding
- All features were designed by the team, with AI providing implementation guidance
- AI was used as a learning tool and code generation assistant, not as a replacement for understanding


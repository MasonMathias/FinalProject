import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:timezone/data/latest_all.dart';
import 'package:timezone/timezone.dart' as tz;
import 'theme/app_theme.dart';
import 'pages/home_page.dart';
import 'pages/auth/login_page.dart';
import 'providers/mood_provider.dart';
import 'providers/journal_provider.dart';
import 'providers/reminder_provider.dart';
import 'providers/auth_provider.dart';
import 'services/reminder_service.dart';

/// Main entry point for Mental Zen app
/// 
/// IMPORTANT: Before running, you need to:
/// 1. Create a Firebase project
/// 2. Run: flutterfire configure
/// 3. This will generate firebase_options.dart
/// 4. Ensure .env file exists with Firebase API keys
/// 
/// Features:
/// - Full Firebase Authentication (login/signup)
/// - Profile management
/// - Mood tracking with Firestore
/// - Journal entries with Firestore
/// - Analytics and insights
/// - Customizable reminders with notifications
/// - Settings and preferences
void main() async {
  // Ensure Flutter bindings are initialized
  // This is required before using Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  // This contains Firebase API keys and other sensitive configuration
  await dotenv.load(fileName: '.env');

  // Initialize timezone database (required for reminder notifications)
  // The data import above automatically loads all timezone data
  // Set the local timezone - required before using tz.local
  // Try to detect and use the device's timezone, fallback to UTC
  try {
    // Get the device's timezone name from DateTime
    final timeZoneName = DateTime.now().timeZoneName;
    // Try common timezone locations based on offset
    final offset = DateTime.now().timeZoneOffset;
    // For simplicity, use UTC and let the device handle conversion
    // The notification system will use the device's local time
    tz.setLocalLocation(tz.UTC);
  } catch (e) {
    // Fallback to UTC if timezone detection fails
    tz.setLocalLocation(tz.UTC);
  }

  // Initialize Firebase
  // Firebase is now configured via flutterfire configure
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize notification service for reminders
  final reminderService = ReminderService();
  await reminderService.initializeNotifications();

  runApp(const MentalZenApp());
}

/// Root widget for the Mental Zen application
/// 
/// This sets up:
/// - Theme (purple/blue zen colors)
/// - State management (Provider)
/// - Navigation
class MentalZenApp extends StatelessWidget {
  const MentalZenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Provider setup - this makes our state available throughout the app
      // Any widget can access these providers using Provider.of<...>(context)
      providers: [
        // Auth provider - manages authentication state
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        // Mood provider - manages mood tracking data
        ChangeNotifierProvider(create: (_) {
          final provider = MoodProvider();
          provider.loadMoodEntries(); // Load data when app starts
          return provider;
        }),
        // Journal provider - manages journal entries
        ChangeNotifierProvider(create: (_) {
          final provider = JournalProvider();
          provider.loadJournalEntries(); // Load data when app starts
          return provider;
        }),
        // Reminder provider - manages reminders
        ChangeNotifierProvider(create: (_) {
          final provider = ReminderProvider();
          provider.initializeNotifications(); // Set up notifications
          provider.loadReminders(); // Load reminders when app starts
          return provider;
        }),
      ],
      child: MaterialApp(
        title: 'Mental Zen',
        // Using our custom theme that gives that calming purple/blue zen vibe
        theme: AppTheme.darkTheme,
        // Check authentication state and show appropriate page
        home: Consumer<AppAuthProvider>(
          builder: (context, authProvider, _) {
            if (authProvider.isAuthenticated) {
              return const HomePage();
            } else {
              return const LoginPage();
            }
          },
        ),
        // Remove the debug banner in the top right corner
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

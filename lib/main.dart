import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'theme/app_theme.dart';
import 'pages/home_page.dart';
import 'providers/mood_provider.dart';
import 'providers/journal_provider.dart';
import 'providers/reminder_provider.dart';
import 'services/reminder_service.dart';

/// Main entry point for Mental Zen app
/// 
/// IMPORTANT: Before running, you need to:
/// 1. Create a Firebase project
/// 2. Run: flutterfire configure
/// 3. This will generate firebase_options.dart
/// 
/// For now, we're using placeholder authentication
/// When real auth is ready, uncomment the Firebase initialization below
void main() async {
  // Ensure Flutter bindings are initialized
  // This is required before using Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  // This contains Firebase API keys and other sensitive configuration
  await dotenv.load(fileName: '.env');

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
        // Home page is our main navigation hub
        home: const HomePage(),
        // Remove the debug banner in the top right corner
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

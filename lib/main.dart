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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  try {
    tz.setLocalLocation(tz.UTC);
  } catch (e) {
    tz.setLocalLocation(tz.UTC);
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final reminderService = ReminderService();
  await reminderService.initializeNotifications();

  runApp(const MentalZenApp());
}

class MentalZenApp extends StatelessWidget {
  const MentalZenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ChangeNotifierProvider(create: (_) {
          final provider = MoodProvider();
          provider.loadMoodEntries();
          return provider;
        }),
        ChangeNotifierProvider(create: (_) {
          final provider = JournalProvider();
          provider.loadJournalEntries();
          return provider;
        }),
        ChangeNotifierProvider(create: (_) {
          final provider = ReminderProvider();
          provider.initializeNotifications();
          provider.loadReminders();
          return provider;
        }),
      ],
      child: MaterialApp(
        title: 'Mental Zen',
        theme: AppTheme.darkTheme,
        home: Consumer<AppAuthProvider>(
          builder: (context, authProvider, _) {
            if (authProvider.isAuthenticated) {
              return const HomePage();
            } else {
              return const LoginPage();
            }
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

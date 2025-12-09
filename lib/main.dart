import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'pages/home_page.dart';

/// Main entry point for Mental Zen app
/// This is where everything starts - think of it as the front door to our app
void main() {
  runApp(const MentalZenApp());
}

/// Root widget for the Mental Zen application
/// This sets up the overall theme and structure of the app
class MentalZenApp extends StatelessWidget {
  const MentalZenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mental Zen',
      // Using our custom theme that gives that calming purple/blue zen vibe
      theme: AppTheme.darkTheme,
      // Home page is our main navigation hub
      home: const HomePage(),
      // Remove the debug banner in the top right corner
      debugShowCheckedModeBanner: false,
    );
  }
}

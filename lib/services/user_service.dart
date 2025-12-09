import 'package:firebase_auth/firebase_auth.dart';

/// User Service
/// This service handles getting the current user ID
/// 
/// IMPORTANT: Currently using a placeholder user ID for development
/// When authentication is implemented, this will use Firebase Auth
/// 
/// To switch to real authentication:
/// 1. Uncomment the Firebase Auth code
/// 2. Comment out or remove the placeholder code
class UserService {
  // Placeholder user ID for development
  // This allows us to build all features without authentication
  static const String _placeholderUserId = 'dev_user_123';

  /// Get the current user ID
  /// 
  /// Currently returns a placeholder ID
  /// When auth is ready, this will return the real Firebase user ID
  static String? getCurrentUserId() {
    // PLACEHOLDER: Return test user ID for now
    // This lets us build and test all features without authentication
    return _placeholderUserId;

    // REAL AUTH CODE (uncomment when authentication is implemented):
    // final user = FirebaseAuth.instance.currentUser;
    // return user?.uid;
  }

  /// Check if user is logged in
  /// 
  /// Currently always returns true (using placeholder)
  /// When auth is ready, this will check Firebase Auth state
  static bool isLoggedIn() {
    // PLACEHOLDER: Always return true for development
    return true;

    // REAL AUTH CODE (uncomment when authentication is implemented):
    // return FirebaseAuth.instance.currentUser != null;
  }

  /// Get current user email (for display purposes)
  /// 
  /// Currently returns a placeholder email
  /// When auth is ready, this will return the real user email
  static String? getCurrentUserEmail() {
    // PLACEHOLDER: Return test email for now
    return 'user@mentalzen.app';

    // REAL AUTH CODE (uncomment when authentication is implemented):
    // return FirebaseAuth.instance.currentUser?.email;
  }
}


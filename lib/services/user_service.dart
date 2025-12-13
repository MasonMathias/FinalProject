import 'package:firebase_auth/firebase_auth.dart';

/// User Service
/// This service handles getting the current user ID
/// Now using real Firebase Authentication
class UserService {
  /// Get the current user ID
  /// Returns the Firebase user ID if logged in, null otherwise
  static String? getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  /// Check if user is logged in
  /// Returns true if a user is currently authenticated
  static bool isLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  /// Get current user email (for display purposes)
  /// Returns the user's email if logged in, null otherwise
  static String? getCurrentUserEmail() {
    return FirebaseAuth.instance.currentUser?.email;
  }

  /// Get current user display name
  /// Returns the user's display name if set, null otherwise
  static String? getCurrentUserDisplayName() {
    return FirebaseAuth.instance.currentUser?.displayName;
  }

  /// Get current user
  /// Returns the current Firebase user object
  static User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }
}


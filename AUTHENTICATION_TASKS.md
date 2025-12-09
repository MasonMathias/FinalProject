# Authentication Implementation Tasks - For Andrew

## Overview
This document outlines the authentication tasks that need to be completed for Milestone 2. These are separate from the core features that Mason will be working on.

---

## 🔐 Authentication Tasks

### 1. Firebase Project Setup (If not done yet)
- [ ] Create Firebase project in [Firebase Console](https://console.firebase.google.com/)
- [ ] Add Flutter app to Firebase project
- [ ] Download `google-services.json` for Android
- [ ] Download `GoogleService-Info.plist` for iOS
- [ ] Place files in correct directories:
  - Android: `android/app/google-services.json`
  - iOS: `ios/Runner/GoogleService-Info.plist`

### 2. Install Firebase Dependencies
Add to `pubspec.yaml`:
```yaml
dependencies:
  firebase_core: ^3.0.0
  firebase_auth: ^5.0.0
```

Then run:
```bash
flutter pub get
```

### 3. Initialize Firebase
**File:** `lib/main.dart`

Add Firebase initialization:
```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Will be generated

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MentalZenApp());
}
```

Generate Firebase options:
```bash
flutterfire configure
```

### 4. Create Authentication Service
**File:** `lib/services/auth_service.dart`

Create a service class to handle all authentication operations:

```dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state stream (for listening to login/logout)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<UserCredential?> signUp(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      // Handle error
      print('Sign up error: $e');
      return null;
    }
  }

  // Sign in with email and password
  Future<UserCredential?> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      // Handle error
      print('Sign in error: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Password reset
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Update user profile
  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    await _auth.currentUser?.updateDisplayName(displayName);
    await _auth.currentUser?.updatePhotoURL(photoURL);
  }
}
```

### 5. Create Login Page
**File:** `lib/pages/login_page.dart`

Create a login page with:
- Email input field
- Password input field
- Login button
- "Forgot password?" link
- Link to sign up page
- Error handling and display

### 6. Create Sign Up Page
**File:** `lib/pages/signup_page.dart`

Create a sign up page with:
- Email input field
- Password input field
- Confirm password field
- Sign up button
- Link to login page
- Password validation
- Error handling

### 7. Create Auth Wrapper
**File:** `lib/pages/auth_wrapper.dart`

This widget checks if user is logged in and shows appropriate page:

```dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'home_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        if (snapshot.hasData) {
          // User is logged in, show home page
          return const HomePage();
        } else {
          // User is not logged in, show login page
          return const LoginPage();
        }
      },
    );
  }
}
```

### 8. Update main.dart
**File:** `lib/main.dart`

Change the home to use AuthWrapper:
```dart
home: const AuthWrapper(),
```

### 9. Connect Settings Page Sign Out
**File:** `lib/pages/settings_page.dart`

Update the sign out button to actually sign out:
```dart
onPressed: () {
  // Call auth service sign out
  // Then navigate to login page
}
```

### 10. Add Loading States
- Show loading indicators during authentication
- Handle authentication errors gracefully
- Display user-friendly error messages

---

## 📋 Testing Checklist

- [ ] User can create new account
- [ ] User can login with existing account
- [ ] User can logout
- [ ] User can reset password
- [ ] App redirects to login if not authenticated
- [ ] App shows home page if authenticated
- [ ] Error messages display correctly
- [ ] Loading states work properly

---

## 🔗 Integration Points

Once authentication is complete, Mason's features will need:
- Current user ID: `FirebaseAuth.instance.currentUser?.uid`
- This will be used in all Firestore operations to associate data with the user

**Example:**
```dart
// In mood_service.dart (Mason's code)
final userId = FirebaseAuth.instance.currentUser?.uid;
if (userId != null) {
  // Save mood entry with userId
}
```

---

## 📚 Resources

- [Firebase Auth Documentation](https://firebase.google.com/docs/auth/flutter/start)
- [FlutterFire Setup](https://firebase.flutter.dev/docs/overview)
- [Firebase Auth Flutter Guide](https://firebase.flutter.dev/docs/auth/overview)

---

## ⚠️ Important Notes

1. **Security:** Never commit Firebase config files with sensitive data to public repos
2. **Error Handling:** Always handle authentication errors gracefully
3. **User Experience:** Show clear error messages (e.g., "Invalid email" vs "User not found")
4. **Testing:** Test on both Android and iOS devices
5. **Password Requirements:** Consider adding password strength requirements

---

## 🎯 Priority Order

1. Firebase setup and initialization
2. Auth service creation
3. Login page
4. Sign up page
5. Auth wrapper
6. Connect to main app
7. Sign out functionality
8. Password reset
9. Error handling and polish

---

**Questions?** Coordinate with Mason to ensure smooth integration between auth and core features!


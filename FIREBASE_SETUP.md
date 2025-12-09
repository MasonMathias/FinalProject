# Firebase Setup Guide

## Overview
This app uses Firebase for data storage. Currently, it's set up with placeholder authentication, but you need to configure Firebase to use the full features.

## Step-by-Step Setup

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Add project" or select an existing project
3. Follow the setup wizard
4. Enable Google Analytics (optional but recommended)

### 2. Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

### 3. Configure Firebase for Your App

From your project root directory, run:

```bash
flutterfire configure
```

This will:
- Detect your Flutter apps (Android, iOS, Web, etc.)
- Let you select which Firebase project to use
- Generate `firebase_options.dart` file
- Add necessary configuration files

### 4. Update main.dart

After running `flutterfire configure`, uncomment the Firebase initialization in `lib/main.dart`:

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

And add the import:

```dart
import 'firebase_options.dart';
```

### 5. Install Dependencies

```bash
flutter pub get
```

### 6. Set Up Firestore Security Rules

In Firebase Console:
1. Go to Firestore Database
2. Click on "Rules" tab
3. Add these rules (for development - adjust for production):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Mood entries - users can only access their own
    match /mood_entries/{entryId} {
      allow read, write: if request.auth != null && 
        request.resource.data.userId == request.auth.uid;
    }
    
    // Journal entries - users can only access their own
    match /journal_entries/{entryId} {
      allow read, write: if request.auth != null && 
        request.resource.data.userId == request.auth.uid;
    }
    
    // Reminders - users can only access their own
    match /reminders/{reminderId} {
      allow read, write: if request.auth != null && 
        request.resource.data.userId == request.auth.uid;
    }
  }
}
```

**Note:** Currently using placeholder authentication, so these rules won't work until real auth is implemented. For now, you can use more permissive rules for testing:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true; // TEMPORARY - for development only
    }
  }
}
```

### 7. Enable Firestore

1. In Firebase Console, go to Firestore Database
2. Click "Create database"
3. Start in "test mode" (or production with proper rules)
4. Choose a location close to your users

### 8. Test the Connection

Run the app:

```bash
flutter run
```

The app should now connect to Firebase and save/load data!

## Current Status

- ✅ **Placeholder Authentication**: App works with test user ID
- ⏳ **Real Authentication**: To be implemented
- ✅ **Firestore Integration**: Ready to use once Firebase is configured
- ✅ **Local Notifications**: Works independently of Firebase

## Troubleshooting

### Error: "DefaultFirebaseOptions not found"
- Run `flutterfire configure` again
- Make sure `firebase_options.dart` exists in `lib/` directory

### Error: "Firebase not initialized"
- Check that you uncommented the Firebase initialization in `main.dart`
- Verify `firebase_options.dart` is imported

### Data not saving
- Check Firestore security rules
- Verify Firebase project is set up correctly
- Check console for error messages

## Next Steps

Once Firebase is configured:
1. The app will work with placeholder user ID
2. When authentication is implemented, replace `UserService.getCurrentUserId()` with real Firebase Auth
3. Update Firestore security rules to use `request.auth.uid`

## Support

If you encounter issues:
1. Check Firebase Console for errors
2. Review Flutter console output
3. Verify all dependencies are installed: `flutter pub get`


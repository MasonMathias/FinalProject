# Setup Guide for Teammates

This guide will help your teammate set up and run the Mental Zen app on their machine.

## Prerequisites

Before you begin, make sure you have the following installed:

1. **Flutter SDK** (version 3.9.2 or higher)
   - Download from: https://flutter.dev/docs/get-started/install
   - Verify installation: `flutter doctor`

2. **Dart SDK** (comes with Flutter)

3. **Android Studio** or **VS Code** with Flutter extensions
   - Android Studio: https://developer.android.com/studio
   - VS Code: Install "Flutter" and "Dart" extensions

4. **Git** (for cloning the repository)
   - Download from: https://git-scm.com/downloads

5. **Android Emulator** or **Physical Device**
   - For Android Studio: Use AVD Manager to create an emulator
   - For physical device: Enable Developer Mode and USB Debugging

## Step-by-Step Setup

### 1. Clone the Repository

```bash
git clone https://github.com/MasonMathias/FinalProject.git
cd FinalProject
```

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

This will install all the required packages listed in `pubspec.yaml`.

### 3. Firebase Setup

The app uses Firebase for authentication and data storage. You have two options:

#### Option A: Use the Existing Firebase Project (Recommended for Team Development)

If you have access to the shared Firebase project:

1. **Get Firebase Configuration from Team Lead**
   - Ask for the `.env` file or Firebase configuration values
   - The `.env` file should contain Firebase API keys

2. **Create `.env` file in the project root**
   - Copy the `.env` file provided by your teammate
   - OR create a new `.env` file with these variables:

```env
# Firebase Web Configuration
FIREBASE_WEB_API_KEY=your_web_api_key_here
FIREBASE_WEB_APP_ID=your_web_app_id_here
FIREBASE_MESSAGING_SENDER_ID=your_messaging_sender_id_here
FIREBASE_PROJECT_ID=your_project_id_here
FIREBASE_AUTH_DOMAIN=your_project_id.firebaseapp.com
FIREBASE_STORAGE_BUCKET=your_project_id.appspot.com
FIREBASE_WEB_MEASUREMENT_ID=your_measurement_id_here

# Firebase Android Configuration
FIREBASE_ANDROID_API_KEY=your_android_api_key_here
FIREBASE_ANDROID_APP_ID=your_android_app_id_here

# Firebase iOS Configuration (if testing on iOS)
FIREBASE_IOS_API_KEY=your_ios_api_key_here
FIREBASE_IOS_APP_ID=your_ios_app_id_here
FIREBASE_IOS_BUNDLE_ID=com.example.finalproject
```

**Important:** The `.env` file is in `.gitignore` and will NOT be committed to Git for security reasons.

#### Option B: Create Your Own Firebase Project

If you need to create your own Firebase project:

1. **Go to Firebase Console**: https://console.firebase.google.com
2. **Create a new project** (or use an existing one)
3. **Add Android app** to your Firebase project:
   - Package name: `com.example.finalproject`
   - Download `google-services.json` and place it in `android/app/`
4. **Add iOS app** (if testing on iOS):
   - Bundle ID: `com.example.finalproject`
   - Download `GoogleService-Info.plist` and place it in `ios/Runner/`
5. **Enable Authentication**:
   - Go to Authentication → Sign-in method
   - Enable Email/Password authentication
6. **Create Firestore Database**:
   - Go to Firestore Database
   - Click "Create database"
   - Start in "test mode" (for development)
   - Choose a location
7. **Set Firestore Security Rules**:
   - Go to Firestore Database → Rules
   - Use these rules (for development):

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

8. **Get Firebase Configuration Values**:
   - Go to Project Settings → General
   - Scroll down to "Your apps"
   - Click on your Android/iOS app
   - Copy the configuration values
   - Create `.env` file with these values (see format above)

### 4. Install FlutterFire CLI (Optional - if creating new Firebase project)

If you're creating your own Firebase project, install FlutterFire CLI:

```bash
dart pub global activate flutterfire_cli
```

Then configure Firebase:

```bash
flutterfire configure
```

This will generate `firebase_options.dart` (already exists in the repo).

### 5. Run the App

1. **Start an emulator** or **connect a physical device**
   - For Android Studio: Tools → Device Manager → Start emulator
   - For VS Code: Use the device selector in the bottom right

2. **Verify device is connected**:
   ```bash
   flutter devices
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

   Or specify a device:
   ```bash
   flutter run -d <device-id>
   ```

## Troubleshooting

### Error: "DefaultFirebaseOptions not found"
- Make sure `firebase_options.dart` exists in `lib/` directory
- If missing, run `flutterfire configure`

### Error: "Environment variables not found"
- Make sure `.env` file exists in the project root
- Check that all required variables are set
- Verify `.env` file is not empty

### Error: "Firebase not initialized"
- Check that `.env` file has correct values
- Verify Firebase project is set up correctly
- Check console for specific error messages

### Error: "Permission denied" for notifications
- On Android: Go to Settings → Apps → Finalproject → Notifications → Enable
- The app will request permission on first use

### Error: "Gradle build failed"
- Run `flutter clean`
- Run `flutter pub get`
- Try `cd android && ./gradlew clean && cd ..`
- Then `flutter run` again

### Data not saving to Firestore
- Check Firestore security rules
- Verify you're logged in (check authentication)
- Check Firebase Console for errors
- Verify `.env` file has correct `FIREBASE_PROJECT_ID`

## Testing the App

Once the app is running:

1. **Sign Up/Login**:
   - Create a new account or login with existing credentials
   - Authentication uses Firebase Auth

2. **Test Features**:
   - **Mood Tracking**: Add a mood entry
   - **Journal**: Create a journal entry
   - **Reminders**: Create a reminder (will request notification permission)
   - **Analytics**: View your mood trends
   - **Settings**: Customize notification preferences

3. **Test Notifications**:
   - Go to Settings → Notification Settings
   - Tap "Send Test Notification"
   - If permission is denied, enable in Android Settings

## Important Notes

- **`.env` file is NOT in Git**: This file contains sensitive API keys and is excluded from version control
- **Firebase Project**: If using a shared project, coordinate with your teammate to avoid conflicts
- **Firestore Rules**: Make sure security rules are set correctly for your use case
- **Android Permissions**: The app requires notification permissions for reminders to work

## Getting Help

If you encounter issues:

1. Check the console output for error messages
2. Review Firebase Console for database/auth errors
3. Verify all prerequisites are installed: `flutter doctor`
4. Check that `.env` file is properly configured
5. Contact your teammate for Firebase project access

## Quick Start Checklist

- [ ] Flutter SDK installed (`flutter doctor` passes)
- [ ] Repository cloned
- [ ] Dependencies installed (`flutter pub get`)
- [ ] `.env` file created with Firebase credentials
- [ ] Emulator/device connected (`flutter devices`)
- [ ] App runs successfully (`flutter run`)
- [ ] Can sign up/login
- [ ] Can create mood entries
- [ ] Can create journal entries
- [ ] Notifications work (if testing reminders)

---

**Need Firebase credentials?** Contact your teammate (Mason Mathias or Andrew Alvarez) to get access to the shared Firebase project or receive the `.env` file.


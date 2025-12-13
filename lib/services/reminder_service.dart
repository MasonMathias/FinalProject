import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/reminder.dart';
import 'user_service.dart';
import 'settings_service.dart';

/// Reminder Service
/// 
/// This service handles reminders - both saving to Firestore
/// and scheduling local notifications on the device
class ReminderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'reminders';

  // Local notifications plugin
  // This handles showing notifications on the device
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  // Settings service to read user preferences
  final SettingsService _settingsService = SettingsService();

  // Whether notifications have been initialized
  bool _initialized = false;

  /// Initialize the notification system
  /// 
  /// This needs to be called once when the app starts
  /// It sets up the notification channels and permissions
  Future<void> initializeNotifications() async {
    if (_initialized) return;

    // Android initialization settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // iOS initialization settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Combined settings
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Initialize the plugin
    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions (especially important for iOS)
    // Note: We don't check the return value here, just initialize
    await _requestPermissions();

    _initialized = true;
  }

  /// Request notification permissions
  /// Returns true if permission is granted, false otherwise
  Future<bool> _requestPermissions() async {
    // Android 13+ requires runtime permission
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidPlugin != null) {
      // Check if permission is already granted
      final alreadyGranted = await androidPlugin.areNotificationsEnabled();
      if (alreadyGranted == true) {
        print('Notification permission already granted');
        // Still create the channel
        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            'wellness_reminders',
            'Wellness Reminders',
            description: 'Reminders for journaling, mood tracking, and wellness activities',
            importance: Importance.high,
          ),
        );
        return true;
      }
      
      // Request permission
      final granted = await androidPlugin.requestNotificationsPermission();
      print('Notification permission granted: $granted');
      
      // Also create the notification channel (required for Android 8.0+)
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          'wellness_reminders',
          'Wellness Reminders',
          description: 'Reminders for journaling, mood tracking, and wellness activities',
          importance: Importance.high,
        ),
      );
      
      return granted ?? false;
    }

    // iOS permissions are requested automatically
    return true;
  }

  /// Handle when user taps a notification
  void _onNotificationTapped(NotificationResponse response) {
    // You can navigate to a specific page here based on the notification
    // For now, we'll just handle it silently
    print('Notification tapped: ${response.payload}');
  }

  /// Save a reminder to Firestore and schedule the notification
  Future<String> saveReminder(Reminder reminder) async {
    try {
      // Save to Firestore first
      final docRef = await _firestore
          .collection(_collectionName)
          .add(reminder.toMap());

      // Create reminder with ID for notification scheduling
      final reminderWithId = reminder.copyWith(id: docRef.id);

      // If reminder is enabled, schedule the notification
      if (reminder.enabled) {
        try {
          // Request permission first (this will show the permission dialog if needed)
          final hasPermission = await _requestPermissions();
          if (!hasPermission) {
            print('ERROR: Notification permission not granted - reminder saved but notification not scheduled');
            print('Please enable notifications in Android Settings → Apps → Finalproject → Notifications');
            // Still return the ID so the reminder is saved
            return docRef.id;
          }
          
          // Schedule the notification
          await _scheduleNotification(reminderWithId);
          print('Notification scheduled successfully for reminder ${docRef.id}');
          
          // Always show a test notification immediately when a reminder is created
          // This helps users verify that notifications are working
          print('Showing immediate test notification for reminder: ${reminder.type}');
          try {
            await _showImmediateTestNotification(reminderWithId);
            print('Test notification shown successfully');
          } catch (e) {
            print('ERROR: Could not show immediate test notification: $e');
            // Check if it's a permission issue
            final permissionCheck = await checkNotificationPermissions();
            if (!permissionCheck) {
              print('ERROR: Notification permission not granted. Please enable notifications in Android Settings.');
            }
          }
        } catch (notificationError) {
          // Log error but don't fail the save operation
          print('Warning: Failed to schedule notification: $notificationError');
          // Still return the ID so the reminder is saved
        }
      }

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to save reminder: $e');
    }
  }

  /// Schedule a daily notification for a reminder
  /// 
  /// This creates a notification that repeats every day at the specified time
  Future<void> _scheduleNotification(Reminder reminder) async {
    if (!_initialized) {
      await initializeNotifications();
    }

    try {
      // Parse the time string (e.g., "09:00") into hours and minutes
      final timeParts = reminder.time.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      // Load user preferences for notifications
      final soundEnabled = await _settingsService.getNotificationSound();
      final vibrationEnabled = await _settingsService.getNotificationVibration();
      final previewEnabled = await _settingsService.getNotificationPreview();

      // Create notification details with user preferences
      final androidDetails = AndroidNotificationDetails(
        'wellness_reminders', // Channel ID
        'Wellness Reminders', // Channel name
        channelDescription: 'Reminders for journaling, mood tracking, and wellness activities',
        importance: Importance.high,
        priority: Priority.high,
        enableVibration: vibrationEnabled,
        playSound: soundEnabled,
        showWhen: true,
        enableLights: true,
        visibility: previewEnabled ? NotificationVisibility.public : NotificationVisibility.private,
      );

      final iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Calculate when to show the notification
      final scheduledTime = _nextInstanceOfTime(hour, minute);
      final now = tz.TZDateTime.now(tz.local);
      
      // Use a unique ID based on reminder ID or generate one
      final notificationId = reminder.id != null 
          ? reminder.id.hashCode.abs() 
          : DateTime.now().millisecondsSinceEpoch % 2147483647;

      // If the scheduled time is within the next 5 minutes, show immediately for testing
      // Otherwise schedule it normally
      final timeUntilNotification = scheduledTime.difference(now);
      
      if (timeUntilNotification.inMinutes <= 5 && timeUntilNotification.inSeconds > 0) {
        // Show immediately for near-future reminders (within 5 minutes)
        print('Reminder is within 5 minutes, showing immediate notification for testing');
        await _notifications.show(
          notificationId,
          reminder.type,
          reminder.message ?? 'Time for your wellness check-in',
          details,
        );
        
        // Also schedule the recurring notification
        await _notifications.zonedSchedule(
          notificationId + 1000000, // Different ID for recurring
          reminder.type,
          reminder.message ?? 'Time for your wellness check-in',
          scheduledTime,
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      } else {
        // Schedule the notification normally
        await _notifications.zonedSchedule(
          notificationId,
          reminder.type,
          reminder.message ?? 'Time for your wellness check-in',
          scheduledTime,
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      }

      print('Notification scheduled for reminder: ${reminder.type} at ${reminder.time} (in ${timeUntilNotification.inMinutes} minutes)');
    } catch (e) {
      print('Error scheduling notification: $e');
      rethrow;
    }
  }

  /// Calculate the next time a notification should fire
  /// 
  /// If it's past the time today, schedule for tomorrow
  /// Otherwise, schedule for today
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If the time has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  /// Get all reminders for the current user
  Stream<List<Reminder>> getReminders() {
    final userId = UserService.getCurrentUserId();
    
    if (userId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection(_collectionName)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      // Sort in memory to avoid needing a composite index
      final reminders = snapshot.docs
          .map((doc) => Reminder.fromMap(doc.id, doc.data()))
          .toList();
      // Sort by time ascending (earliest first)
      reminders.sort((a, b) => a.time.compareTo(b.time));
      return reminders;
    });
  }

  /// Update a reminder
  Future<void> updateReminder(Reminder reminder) async {
    if (reminder.id == null) {
      throw Exception('Cannot update reminder without ID');
    }

    try {
      await _firestore
          .collection(_collectionName)
          .doc(reminder.id)
          .update(reminder.toMap());

      // Reschedule notification if enabled
      if (reminder.enabled) {
        await _cancelNotification(reminder.id!);
        await _scheduleNotification(reminder);
      } else {
        await _cancelNotification(reminder.id!);
      }
    } catch (e) {
      throw Exception('Failed to update reminder: $e');
    }
  }

  /// Delete a reminder
  Future<void> deleteReminder(String reminderId) async {
    try {
      await _firestore.collection(_collectionName).doc(reminderId).delete();
      await _cancelNotification(reminderId);
    } catch (e) {
      throw Exception('Failed to delete reminder: $e');
    }
  }

  /// Cancel a scheduled notification
  Future<void> _cancelNotification(String reminderId) async {
    await _notifications.cancel(reminderId.hashCode);
  }

  /// Check if notification permissions are granted
  Future<bool> checkNotificationPermissions() async {
    if (!_initialized) {
      await initializeNotifications();
    }
    
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidPlugin != null) {
      final enabled = await androidPlugin.areNotificationsEnabled();
      return enabled == true;
    }
    
    return true; // iOS permissions handled automatically
  }

  /// Show an immediate test notification for a reminder
  /// This is used when a reminder is scheduled far in the future
  Future<void> _showImmediateTestNotification(Reminder reminder) async {
    if (!_initialized) {
      await initializeNotifications();
    }

    // Load user preferences for notifications
    final soundEnabled = await _settingsService.getNotificationSound();
    final vibrationEnabled = await _settingsService.getNotificationVibration();
    final previewEnabled = await _settingsService.getNotificationPreview();

    final androidDetails = AndroidNotificationDetails(
      'wellness_reminders',
      'Wellness Reminders',
      channelDescription: 'Reminders for journaling, mood tracking, and wellness activities',
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: vibrationEnabled,
      playSound: soundEnabled,
      showWhen: true,
      enableLights: true,
      channelShowBadge: true,
      visibility: previewEnabled ? NotificationVisibility.public : NotificationVisibility.private,
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: soundEnabled,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Use a unique ID for the test notification
    final testNotificationId = (reminder.id?.hashCode ?? DateTime.now().millisecondsSinceEpoch).abs() + 2000000;

    await _notifications.show(
      testNotificationId,
      'Reminder Created: ${reminder.type}',
      reminder.message ?? 'Your reminder is set for ${reminder.time}. This is a test notification to confirm it\'s working!',
      details,
    );
  }

  /// Show a test notification immediately (for testing)
  /// This helps verify that notifications are working
  /// Returns true if notification was shown, false if permission denied
  Future<bool> showTestNotification() async {
    if (!_initialized) {
      await initializeNotifications();
    }

    // Request permissions again to make sure we have them
    final hasPermission = await _requestPermissions();
    
    if (!hasPermission) {
      print('Notification permission denied - cannot show notification');
      return false;
    }

    // Load user preferences for notifications
    final soundEnabled = await _settingsService.getNotificationSound();
    final vibrationEnabled = await _settingsService.getNotificationVibration();
    final previewEnabled = await _settingsService.getNotificationPreview();

    final androidDetails = AndroidNotificationDetails(
      'wellness_reminders',
      'Wellness Reminders',
      channelDescription: 'Reminders for journaling, mood tracking, and wellness activities',
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: vibrationEnabled,
      playSound: soundEnabled,
      showWhen: true,
      enableLights: true,
      channelShowBadge: true,
      visibility: previewEnabled ? NotificationVisibility.public : NotificationVisibility.private,
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: soundEnabled,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notifications.show(
        999999, // Test notification ID
        'Test Notification',
        'Notifications are working! Your reminders will appear here.',
        details,
      );
      print('Test notification sent successfully');
      return true;
    } catch (e) {
      print('Error showing test notification: $e');
      rethrow;
    }
  }
}


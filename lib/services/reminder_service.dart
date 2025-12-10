import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/reminder.dart';
import 'user_service.dart';

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
    await _requestPermissions();

    _initialized = true;
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    // Android 13+ requires runtime permission
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();

    // iOS permissions are requested automatically
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

      // If reminder is enabled, schedule the notification
      if (reminder.enabled) {
        await _scheduleNotification(reminder.copyWith(id: docRef.id));
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

    // Parse the time string (e.g., "09:00") into hours and minutes
    final timeParts = reminder.time.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    // Create notification details
    final androidDetails = AndroidNotificationDetails(
      'wellness_reminders', // Channel ID
      'Wellness Reminders', // Channel name
      channelDescription: 'Reminders for journaling, mood tracking, and wellness activities',
      importance: Importance.high,
      priority: Priority.high,
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

    // Schedule the notification
    // This uses a time-based trigger that repeats daily
    await _notifications.zonedSchedule(
      reminder.id.hashCode, // Unique ID for this notification
      reminder.type, // Notification title
      reminder.message ?? 'Time for your wellness check-in', // Notification body
      _nextInstanceOfTime(hour, minute), // When to show it
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Repeat daily at this time
    );
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
        .orderBy('time', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Reminder.fromMap(doc.id, doc.data()))
          .toList();
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
}


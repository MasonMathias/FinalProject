import 'package:flutter/foundation.dart';
import '../models/reminder.dart';
import '../services/reminder_service.dart';

/// Reminder Provider
/// 
/// Manages the state of reminders
class ReminderProvider with ChangeNotifier {
  final ReminderService _reminderService = ReminderService();

  List<Reminder> _reminders = [];
  bool _isLoading = false;
  String? _error;

  List<Reminder> get reminders => _reminders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Initialize notifications (call this when app starts)
  Future<void> initializeNotifications() async {
    await _reminderService.initializeNotifications();
  }

  /// Load reminders from the database
  void loadReminders() {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _reminderService.getReminders().listen(
      (reminders) {
        _reminders = reminders;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        _error = error.toString();
        notifyListeners();
      },
    );
  }

  /// Save a new reminder
  Future<bool> saveReminder(Reminder reminder) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _reminderService.saveReminder(reminder);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Update an existing reminder
  Future<bool> updateReminder(Reminder reminder) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _reminderService.updateReminder(reminder);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Delete a reminder
  Future<bool> deleteReminder(String reminderId) async {
    try {
      await _reminderService.deleteReminder(reminderId);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}


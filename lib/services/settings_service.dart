import 'package:shared_preferences/shared_preferences.dart';

/// Settings Service
/// 
/// Handles saving and loading app settings locally
/// Uses SharedPreferences which stores data on the device
class SettingsService {
  // Keys for storing different settings
  static const String _keyNotificationsEnabled = 'notifications_enabled';
  static const String _keyDarkModeEnabled = 'dark_mode_enabled';
  static const String _keyAnalyticsEnabled = 'analytics_enabled';
  static const String _keyLanguage = 'language';
  
  // Notification settings keys
  static const String _keyNotificationSound = 'notification_sound';
  static const String _keyNotificationVibration = 'notification_vibration';
  static const String _keyNotificationPreview = 'notification_preview';
  static const String _keyQuietHoursEnabled = 'quiet_hours_enabled';
  static const String _keyQuietHoursStart = 'quiet_hours_start';
  static const String _keyQuietHoursEnd = 'quiet_hours_end';

  /// Get SharedPreferences instance
  Future<SharedPreferences> get _prefs async {
    return await SharedPreferences.getInstance();
  }

  /// Save whether notifications are enabled
  Future<bool> setNotificationsEnabled(bool enabled) async {
    final prefs = await _prefs;
    return await prefs.setBool(_keyNotificationsEnabled, enabled);
  }

  /// Get whether notifications are enabled (default: true)
  Future<bool> getNotificationsEnabled() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyNotificationsEnabled) ?? true;
  }

  /// Save dark mode preference
  Future<bool> setDarkModeEnabled(bool enabled) async {
    final prefs = await _prefs;
    return await prefs.setBool(_keyDarkModeEnabled, enabled);
  }

  /// Get dark mode preference (default: true)
  Future<bool> getDarkModeEnabled() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyDarkModeEnabled) ?? true;
  }

  /// Save analytics preference
  Future<bool> setAnalyticsEnabled(bool enabled) async {
    final prefs = await _prefs;
    return await prefs.setBool(_keyAnalyticsEnabled, enabled);
  }

  /// Get analytics preference (default: true)
  Future<bool> getAnalyticsEnabled() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyAnalyticsEnabled) ?? true;
  }

  /// Save language preference
  Future<bool> setLanguage(String language) async {
    final prefs = await _prefs;
    return await prefs.setString(_keyLanguage, language);
  }

  /// Get language preference (default: 'English')
  Future<String> getLanguage() async {
    final prefs = await _prefs;
    return prefs.getString(_keyLanguage) ?? 'English';
  }

  /// Notification Sound Settings
  Future<bool> setNotificationSound(bool enabled) async {
    final prefs = await _prefs;
    return await prefs.setBool(_keyNotificationSound, enabled);
  }

  Future<bool> getNotificationSound() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyNotificationSound) ?? true;
  }

  /// Notification Vibration Settings
  Future<bool> setNotificationVibration(bool enabled) async {
    final prefs = await _prefs;
    return await prefs.setBool(_keyNotificationVibration, enabled);
  }

  Future<bool> getNotificationVibration() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyNotificationVibration) ?? true;
  }

  /// Notification Preview Settings
  Future<bool> setNotificationPreview(bool enabled) async {
    final prefs = await _prefs;
    return await prefs.setBool(_keyNotificationPreview, enabled);
  }

  Future<bool> getNotificationPreview() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyNotificationPreview) ?? true;
  }

  /// Quiet Hours Settings
  Future<bool> setQuietHoursEnabled(bool enabled) async {
    final prefs = await _prefs;
    return await prefs.setBool(_keyQuietHoursEnabled, enabled);
  }

  Future<bool> getQuietHoursEnabled() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyQuietHoursEnabled) ?? false;
  }

  Future<bool> setQuietHoursStart(String time) async {
    final prefs = await _prefs;
    return await prefs.setString(_keyQuietHoursStart, time);
  }

  Future<String> getQuietHoursStart() async {
    final prefs = await _prefs;
    return prefs.getString(_keyQuietHoursStart) ?? '22:00';
  }

  Future<bool> setQuietHoursEnd(String time) async {
    final prefs = await _prefs;
    return await prefs.setString(_keyQuietHoursEnd, time);
  }

  Future<String> getQuietHoursEnd() async {
    final prefs = await _prefs;
    return prefs.getString(_keyQuietHoursEnd) ?? '08:00';
  }

  /// Clear all settings (useful for logout)
  Future<bool> clearAllSettings() async {
    final prefs = await _prefs;
    return await prefs.clear();
  }
}


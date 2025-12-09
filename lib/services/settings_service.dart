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

  /// Clear all settings (useful for logout)
  Future<bool> clearAllSettings() async {
    final prefs = await _prefs;
    return await prefs.clear();
  }
}


import 'package:flutter/material.dart';
import '../services/settings_service.dart';
import '../services/reminder_service.dart';

/// Notification Settings Page
/// 
/// Allows users to customize their notification preferences
class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  final SettingsService _settingsService = SettingsService();
  final ReminderService _reminderService = ReminderService();
  
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _previewEnabled = true;
  bool _quietHoursEnabled = false;
  String _quietHoursStart = '22:00';
  String _quietHoursEnd = '08:00';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  /// Load notification settings from storage
  Future<void> _loadSettings() async {
    setState(() {
      _isLoading = true;
    });

    _soundEnabled = await _settingsService.getNotificationSound();
    _vibrationEnabled = await _settingsService.getNotificationVibration();
    _previewEnabled = await _settingsService.getNotificationPreview();
    _quietHoursEnabled = await _settingsService.getQuietHoursEnabled();
    _quietHoursStart = await _settingsService.getQuietHoursStart();
    _quietHoursEnd = await _settingsService.getQuietHoursEnd();

    setState(() {
      _isLoading = false;
    });
  }

  /// Update sound setting
  Future<void> _updateSound(bool value) async {
    setState(() {
      _soundEnabled = value;
    });
    await _settingsService.setNotificationSound(value);
  }

  /// Update vibration setting
  Future<void> _updateVibration(bool value) async {
    setState(() {
      _vibrationEnabled = value;
    });
    await _settingsService.setNotificationVibration(value);
  }

  /// Update preview setting
  Future<void> _updatePreview(bool value) async {
    setState(() {
      _previewEnabled = value;
    });
    await _settingsService.setNotificationPreview(value);
  }

  /// Update quiet hours setting
  Future<void> _updateQuietHours(bool value) async {
    setState(() {
      _quietHoursEnabled = value;
    });
    await _settingsService.setQuietHoursEnabled(value);
  }

  /// Show time picker for quiet hours start
  Future<void> _pickQuietHoursStart() async {
    final timeParts = _quietHoursStart.split(':');
    final initialTime = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (pickedTime != null) {
      final timeString = '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
      setState(() {
        _quietHoursStart = timeString;
      });
      await _settingsService.setQuietHoursStart(timeString);
    }
  }

  /// Show time picker for quiet hours end
  Future<void> _pickQuietHoursEnd() async {
    final timeParts = _quietHoursEnd.split(':');
    final initialTime = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (pickedTime != null) {
      final timeString = '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
      setState(() {
        _quietHoursEnd = timeString;
      });
      await _settingsService.setQuietHoursEnd(timeString);
    }
  }

  /// Send a test notification
  Future<void> _sendTestNotification() async {
    final success = await _reminderService.showTestNotification();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Test notification sent! Check your notification tray.'
                : 'Failed to send notification. Please check notification permissions in Android Settings.',
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Notification Settings')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // General Settings
            const Text(
              'General',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Sound'),
                    subtitle: const Text('Play sound when notification arrives'),
                    value: _soundEnabled,
                    onChanged: _updateSound,
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Vibration'),
                    subtitle: const Text('Vibrate when notification arrives'),
                    value: _vibrationEnabled,
                    onChanged: _updateVibration,
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Show Preview'),
                    subtitle: const Text('Display notification content on lock screen'),
                    value: _previewEnabled,
                    onChanged: _updatePreview,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Quiet Hours
            const Text(
              'Quiet Hours',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Enable Quiet Hours'),
                    subtitle: const Text('Silence notifications during specified hours'),
                    value: _quietHoursEnabled,
                    onChanged: _updateQuietHours,
                  ),
                  if (_quietHoursEnabled) ...[
                    const Divider(height: 1),
                    ListTile(
                      title: const Text('Start Time'),
                      subtitle: Text(_quietHoursStart),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _pickQuietHoursStart,
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: const Text('End Time'),
                      subtitle: Text(_quietHoursEnd),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _pickQuietHoursEnd,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Testing
            const Text(
              'Testing',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.notifications_active),
                title: const Text('Send Test Notification'),
                subtitle: const Text('Verify that notifications are working'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _sendTestNotification,
              ),
            ),

            const SizedBox(height: 24),

            // Help
            Card(
              child: ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Need Help?'),
                subtitle: const Text('If notifications aren\'t working, check Android Settings → Apps → Finalproject → Notifications'),
                isThreeLine: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


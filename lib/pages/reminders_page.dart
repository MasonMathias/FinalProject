import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reminder_provider.dart';
import '../models/reminder.dart';
import '../services/user_service.dart';

/// Reminders Page
/// 
/// This is where users can set customizable wellness reminders
/// This is the signature feature for Mental Zen
/// Now fully functional with Firebase and local notifications!
class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  final TextEditingController _messageController = TextEditingController();
  TimeOfDay? _selectedTime;
  String? _selectedType;
  bool _isSaving = false;

  final List<String> reminderTypes = [
    'Journal Entry',
    'Mood Check-in',
    'Breathing Exercise',
    'Positive Affirmation',
    'Mindfulness Break',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String _formatTimeForStorage(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  IconData _getIconForType(String? type) {
    switch (type) {
      case 'Journal Entry':
        return Icons.book;
      case 'Mood Check-in':
        return Icons.mood;
      case 'Breathing Exercise':
        return Icons.air;
      case 'Positive Affirmation':
        return Icons.favorite;
      case 'Mindfulness Break':
        return Icons.self_improvement;
      default:
        return Icons.notifications;
    }
  }

  Future<void> _saveReminder() async {
    if (_selectedType == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both type and time')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final userId = UserService.getCurrentUserId();
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found')),
      );
      setState(() {
        _isSaving = false;
      });
      return;
    }

    final reminder = Reminder(
      userId: userId,
      type: _selectedType!,
      message: _messageController.text.isEmpty ? null : _messageController.text,
      time: _formatTimeForStorage(_selectedTime!),
      enabled: true,
      createdAt: DateTime.now(),
    );

    final reminderProvider = Provider.of<ReminderProvider>(context, listen: false);
    final success = await reminderProvider.saveReminder(reminder);

    setState(() {
      _isSaving = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reminder added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      // Clear form
      _messageController.clear();
      _selectedType = null;
      _selectedTime = null;
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(reminderProvider.error ?? 'Failed to save reminder'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wellness Reminders'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Customizable Reminders',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Set gentle reminders to support your wellness journey',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 32),

              // Add reminder card
              Card(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.add_circle_outline,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Add New Reminder',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Reminder type selection
                      const Text(
                        'Reminder Type',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedType,
                        decoration: InputDecoration(
                          hintText: 'Select reminder type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.category),
                        ),
                        items: reminderTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value;
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      // Custom message input
                      TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          labelText: 'Custom Message (optional)',
                          hintText: 'Add a personal message...',
                          prefixIcon: const Icon(Icons.message),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Time selection
                      const Text(
                        'Time',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.access_time),
                          title: Text(
                            _selectedTime == null
                                ? 'Select time'
                                : _formatTime(_selectedTime!),
                            style: TextStyle(
                              color: _selectedTime == null
                                  ? Colors.grey[400]
                                  : null,
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (time != null) {
                              setState(() {
                                _selectedTime = time;
                              });
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Add button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSaving || _selectedType == null || _selectedTime == null
                              ? null
                              : _saveReminder,
                          child: _isSaving
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Add Reminder'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Active reminders list
              const Text(
                'Active Reminders',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              Consumer<ReminderProvider>(
                builder: (context, reminderProvider, child) {
                  if (reminderProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (reminderProvider.error != null) {
                    return Card(
                      color: Colors.red.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text('Error: ${reminderProvider.error}'),
                      ),
                    );
                  }

                  final reminders = reminderProvider.reminders;

                  if (reminders.isEmpty) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            Icon(
                              Icons.notifications_off,
                              size: 64,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No reminders set yet',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add your first reminder above',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: reminders.map((reminder) {
                      // Parse time string back to TimeOfDay for display
                      final timeParts = reminder.time.split(':');
                      final displayTime = TimeOfDay(
                        hour: int.parse(timeParts[0]),
                        minute: int.parse(timeParts[1]),
                      );

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary.withOpacity(0.2),
                            child: Icon(
                              _getIconForType(reminder.type),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          title: Text(reminder.type),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (reminder.message != null)
                                Text(reminder.message!),
                              const SizedBox(height: 4),
                              Text(
                                'Daily at ${_formatTime(displayTime)}',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Reminder'),
                                  content: const Text('Are you sure you want to delete this reminder?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true && reminder.id != null) {
                                await reminderProvider.deleteReminder(reminder.id!);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Reminder deleted')),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Info card about smart timing
              Card(
                color: Colors.blue.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.lightbulb_outline, color: Colors.blue),
                          const SizedBox(width: 8),
                          const Text(
                            'Smart Timing',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Reminders will adapt to your patterns and suggest optimal times based on your activity.',
                        style: TextStyle(
                          color: Colors.blue[200],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

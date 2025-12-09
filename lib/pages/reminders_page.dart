import 'package:flutter/material.dart';

/// Reminders Page
/// This is where users can set customizable wellness reminders
/// This is the signature feature for Mental Zen
/// For Milestone 1, we're building the UI - actual notifications come in Milestone 2
class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  // Placeholder data - in Milestone 2, this will come from Firebase/local storage
  final List<Map<String, dynamic>> _reminders = [];

  // Controllers for the add reminder form
  final TextEditingController _titleController = TextEditingController();
  TimeOfDay? _selectedTime;
  String? _selectedType;

  // Reminder types
  final List<String> reminderTypes = [
    'Journal Entry',
    'Mood Check-in',
    'Breathing Exercise',
    'Positive Affirmation',
    'Mindfulness Break',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
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
              // Header
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
                        controller: _titleController,
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
                          onPressed: _selectedType == null || _selectedTime == null
                              ? null
                              : () {
                                  // In Milestone 2, this will save and schedule the reminder
                                  setState(() {
                                    _reminders.add({
                                      'type': _selectedType,
                                      'message': _titleController.text.isEmpty
                                          ? null
                                          : _titleController.text,
                                      'time': _selectedTime,
                                    });
                                    _titleController.clear();
                                    _selectedType = null;
                                    _selectedTime = null;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Reminder added! (UI only - Milestone 1)'),
                                    ),
                                  );
                                },
                          child: const Text('Add Reminder'),
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

              if (_reminders.isEmpty)
                Card(
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
                )
              else
                ..._reminders.asMap().entries.map((entry) {
                  final index = entry.key;
                  final reminder = entry.value;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.primary.withOpacity(0.2),
                        child: Icon(
                          _getIconForType(reminder['type']),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      title: Text(reminder['type']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (reminder['message'] != null)
                            Text(reminder['message']),
                          const SizedBox(height: 4),
                          Text(
                            'Daily at ${_formatTime(reminder['time'])}',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          setState(() {
                            _reminders.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                }),

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
                        'In Milestone 2, reminders will adapt to your patterns and suggest optimal times based on your activity.',
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

  /// Format time nicely
  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  /// Get icon for reminder type
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
}


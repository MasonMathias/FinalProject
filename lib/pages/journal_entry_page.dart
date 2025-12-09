import 'package:flutter/material.dart';

/// Journal Entry Page
/// This is where users can write their thoughts and feelings
/// For Milestone 1, we're just building the UI - saving to Firebase comes in Milestone 2
class JournalEntryPage extends StatefulWidget {
  const JournalEntryPage({super.key});

  @override
  State<JournalEntryPage> createState() => _JournalEntryPageState();
}

class _JournalEntryPageState extends State<JournalEntryPage> {
  // Controllers for text fields - we'll use these in Milestone 2 to save data
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    // Always dispose controllers to prevent memory leaks
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal Entry'),
        actions: [
          // Save button in app bar - common pattern for journal apps
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // In Milestone 2, this will save to Firestore
              if (_titleController.text.isEmpty ||
                  _contentController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill in both title and content'),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Journal entry saved! (UI only - Milestone 1)'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with some inspiration
              const Text(
                'Express Yourself',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your thoughts are safe here',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 32),

              // Title input
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Entry Title',
                  hintText: 'Give this entry a title...',
                  prefixIcon: const Icon(Icons.title),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 24),

              // Date picker (for future use in Milestone 2)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Date'),
                  subtitle: Text(
                    _formatDate(DateTime.now()),
                    style: const TextStyle(fontSize: 16),
                  ),
                  // In Milestone 2, we'll make this interactive
                ),
              ),

              const SizedBox(height: 24),

              // Main journal content area
              const Text(
                'Your Thoughts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _contentController,
                maxLines: 15,
                decoration: InputDecoration(
                  hintText: 'Write whatever comes to mind...\n\nThis is your safe space to express your thoughts, feelings, and experiences.',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),

              const SizedBox(height: 24),

              // Quick tags section (for future use)
              const Text(
                'Tags (optional)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildTagChip('Gratitude', false),
                  _buildTagChip('Reflection', false),
                  _buildTagChip('Goals', false),
                  _buildTagChip('Challenges', false),
                  _buildTagChip('Celebration', false),
                ],
              ),

              const SizedBox(height: 32),

              // Save button at bottom
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_titleController.text.isEmpty ||
                        _contentController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in both title and content'),
                        ),
                      );
                    } else {
                      // In Milestone 2, this will save to Firestore
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Journal entry saved! (UI only - Milestone 1)'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Save Entry',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Info card
              Card(
                color: Colors.blue.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.blue),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'In Milestone 2, entries will be saved securely to Firebase',
                          style: TextStyle(
                            color: Colors.blue[200],
                            fontSize: 14,
                          ),
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

  /// Helper to format date nicely
  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  /// Build tag chips - these will be interactive in Milestone 2
  Widget _buildTagChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        // In Milestone 2, we'll track selected tags
      },
      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
      checkmarkColor: Theme.of(context).colorScheme.primary,
    );
  }
}


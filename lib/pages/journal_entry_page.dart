import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/journal_provider.dart';
import '../models/journal_entry.dart';
import '../services/user_service.dart';
import 'package:intl/intl.dart';

/// Journal Entry Page
/// 
/// This is where users write their thoughts and feelings
/// Now fully functional with Firebase integration!
class JournalEntryPage extends StatefulWidget {
  final JournalEntry? existingEntry; // For editing existing entries

  const JournalEntryPage({super.key, this.existingEntry});

  @override
  State<JournalEntryPage> createState() => _JournalEntryPageState();
}

class _JournalEntryPageState extends State<JournalEntryPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final Set<String> _selectedTags = {};
  bool _isSaving = false;

  // Available tags
  final List<String> _availableTags = [
    'Gratitude',
    'Reflection',
    'Goals',
    'Challenges',
    'Celebration',
  ];

  @override
  void initState() {
    super.initState();
    // If editing an existing entry, load its data
    if (widget.existingEntry != null) {
      _titleController.text = widget.existingEntry!.title;
      _contentController.text = widget.existingEntry!.content;
      _selectedTags.addAll(widget.existingEntry!.tags);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  /// Save the journal entry
  Future<void> _saveEntry() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both title and content')),
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

    // Create journal entry
    final entry = JournalEntry(
      id: widget.existingEntry?.id, // Keep ID if editing
      userId: userId,
      title: _titleController.text,
      content: _contentController.text,
      tags: _selectedTags.toList(),
      timestamp: widget.existingEntry?.timestamp ?? DateTime.now(),
      updatedAt: widget.existingEntry != null ? DateTime.now() : null,
    );

    final journalProvider = Provider.of<JournalProvider>(context, listen: false);
    final success = widget.existingEntry != null
        ? await journalProvider.updateJournalEntry(entry)
        : await journalProvider.saveJournalEntry(entry);

    setState(() {
      _isSaving = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.existingEntry == null
              ? 'Journal entry saved!'
              : 'Journal entry updated!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // Go back to previous page
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(journalProvider.error ?? 'Failed to save entry'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMMM d, y').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingEntry != null 
            ? 'Edit Journal Entry' 
            : 'Journal Entry'),
        actions: [
          IconButton(
            icon: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            onPressed: _isSaving ? null : _saveEntry,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              // Date display
              Card(
                child: ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Date'),
                  subtitle: Text(
                    _formatDate(widget.existingEntry?.timestamp ?? DateTime.now()),
                    style: const TextStyle(fontSize: 16),
                  ),
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

              // Tags section
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
                children: _availableTags.map((tag) {
                  final isSelected = _selectedTags.contains(tag);
                  return FilterChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedTags.add(tag);
                        } else {
                          _selectedTags.remove(tag);
                        }
                      });
                    },
                    selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    checkmarkColor: Theme.of(context).colorScheme.primary,
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),

              // Save button at bottom
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveEntry,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          widget.existingEntry != null
                              ? 'Update Entry'
                              : 'Save Entry',
                          style: const TextStyle(fontSize: 16),
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

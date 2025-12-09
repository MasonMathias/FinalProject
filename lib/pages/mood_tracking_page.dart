import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mood_provider.dart';
import '../models/mood_entry.dart';
import '../services/user_service.dart';

/// Mood Tracking Page
/// 
/// This is where users log their daily moods
/// Now fully functional with Firebase integration!
class MoodTrackingPage extends StatefulWidget {
  const MoodTrackingPage({super.key});

  @override
  State<MoodTrackingPage> createState() => _MoodTrackingPageState();
}

class _MoodTrackingPageState extends State<MoodTrackingPage> {
  // Selected mood value
  String? selectedMood;
  
  // Controller for the note text field
  final TextEditingController _noteController = TextEditingController();
  
  // Whether we're currently saving
  bool _isSaving = false;
  
  // Today's existing mood entry (if user already logged today)
  MoodEntry? _todaysEntry;

  // List of mood options with emojis
  final List<Map<String, dynamic>> moods = [
    {'emoji': '😊', 'label': 'Great', 'value': 'great'},
    {'emoji': '🙂', 'label': 'Good', 'value': 'good'},
    {'emoji': '😐', 'label': 'Okay', 'value': 'okay'},
    {'emoji': '😔', 'label': 'Down', 'value': 'down'},
    {'emoji': '😢', 'label': 'Struggling', 'value': 'struggling'},
  ];

  @override
  void initState() {
    super.initState();
    // Check if user already logged their mood today
    _loadTodaysMood();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  /// Load today's mood entry if it exists
  Future<void> _loadTodaysMood() async {
    final moodProvider = Provider.of<MoodProvider>(context, listen: false);
    final todaysMood = await moodProvider.getTodaysMood();
    
    if (todaysMood != null) {
      setState(() {
        _todaysEntry = todaysMood;
        selectedMood = todaysMood.mood;
        _noteController.text = todaysMood.note ?? '';
      });
    }
  }

  /// Save the mood entry to Firebase
  Future<void> _saveMood() async {
    if (selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a mood')),
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

    // Create mood entry
    final moodEntry = MoodEntry(
      id: _todaysEntry?.id, // If updating existing entry, keep the ID
      userId: userId,
      mood: selectedMood!,
      note: _noteController.text.isEmpty ? null : _noteController.text,
      timestamp: _todaysEntry?.timestamp ?? DateTime.now(), // Use existing timestamp if updating
    );

    final moodProvider = Provider.of<MoodProvider>(context, listen: false);
    final success = await moodProvider.saveMoodEntry(moodEntry);

    setState(() {
      _isSaving = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_todaysEntry == null 
              ? 'Mood logged successfully!' 
              : 'Mood updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Reload today's mood to update the UI
      await _loadTodaysMood();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(moodProvider.error ?? 'Failed to save mood'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Mood Tracking'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              const Text(
                'How are you feeling today?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _todaysEntry != null
                    ? 'Update your mood for today'
                    : 'Take a moment to check in with yourself',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 32),

              // Mood selection grid
              const Text(
                'Select your mood:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.0,
                ),
                itemCount: moods.length,
                itemBuilder: (context, index) {
                  final mood = moods[index];
                  final isSelected = selectedMood == mood['value'];
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedMood = mood['value'];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                            : Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            mood['emoji'],
                            style: const TextStyle(fontSize: 40),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            mood['label'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              // Optional notes section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add a note (optional)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _noteController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'What\'s on your mind?',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveMood,
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
                          _todaysEntry == null 
                              ? 'Save Mood Entry' 
                              : 'Update Mood Entry',
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // Show today's entry info if it exists
              if (_todaysEntry != null)
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
                            'You already logged your mood today. You can update it above.',
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
}

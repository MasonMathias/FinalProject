import 'package:flutter/foundation.dart';
import '../models/mood_entry.dart';
import '../services/mood_service.dart';

/// Mood Provider
/// 
/// This manages the state of mood entries in the app
/// Using Provider pattern for state management
/// 
/// When mood data changes, all widgets listening to this provider
/// will automatically update (that's the magic of Provider!)
class MoodProvider with ChangeNotifier {
  final MoodService _moodService = MoodService();

  // List of all mood entries
  List<MoodEntry> _moodEntries = [];

  // Whether we're currently loading data
  bool _isLoading = false;

  // Any error that occurred
  String? _error;

  // Getters - these allow other parts of the app to read the state
  List<MoodEntry> get moodEntries => _moodEntries;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load mood entries from the database
  /// 
  /// This sets up a stream listener that automatically updates
  /// when new entries are added
  void loadMoodEntries() {
    _isLoading = true;
    _error = null;
    notifyListeners(); // Tell listeners that state changed

    // Listen to the stream from MoodService
    // This will automatically update whenever data changes in Firestore
    _moodService.getMoodEntries().listen(
      (entries) {
        _moodEntries = entries;
        _isLoading = false;
        _error = null;
        notifyListeners(); // Update UI
      },
      onError: (error) {
        _isLoading = false;
        _error = error.toString();
        notifyListeners();
      },
    );
  }

  /// Save a new mood entry
  Future<bool> saveMoodEntry(MoodEntry entry) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _moodService.saveMoodEntry(entry);
      
      // The stream listener will automatically update the list
      // so we don't need to manually add it here
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

  /// Get today's mood entry
  Future<MoodEntry?> getTodaysMood() async {
    try {
      return await _moodService.getTodaysMood();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Delete a mood entry
  Future<bool> deleteMoodEntry(String entryId) async {
    try {
      await _moodService.deleteMoodEntry(entryId);
      // Stream will automatically update
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Clear any error messages
  void clearError() {
    _error = null;
    notifyListeners();
  }
}


import 'package:flutter/foundation.dart';
import '../models/mood_entry.dart';
import '../services/mood_service.dart';

class MoodProvider with ChangeNotifier {
  final MoodService _moodService = MoodService();

  List<MoodEntry> _moodEntries = [];
  bool _isLoading = false;
  String? _error;

  List<MoodEntry> get moodEntries => _moodEntries;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void loadMoodEntries() {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _moodService.getMoodEntries().listen(
      (entries) {
        _moodEntries = entries;
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

  Future<bool> saveMoodEntry(MoodEntry entry) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _moodService.saveMoodEntry(entry);
      
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

  Future<MoodEntry?> getTodaysMood() async {
    try {
      return await _moodService.getTodaysMood();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<bool> deleteMoodEntry(String entryId) async {
    try {
      await _moodService.deleteMoodEntry(entryId);
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


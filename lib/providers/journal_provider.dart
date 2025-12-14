import 'package:flutter/foundation.dart';
import '../models/journal_entry.dart';
import '../services/journal_service.dart';

class JournalProvider with ChangeNotifier {
  final JournalService _journalService = JournalService();

  List<JournalEntry> _journalEntries = [];
  bool _isLoading = false;
  String? _error;

  List<JournalEntry> get journalEntries => _journalEntries;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void loadJournalEntries() {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _journalService.getJournalEntries().listen(
      (entries) {
        _journalEntries = entries;
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

  Future<bool> saveJournalEntry(JournalEntry entry) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _journalService.saveJournalEntry(entry);
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

  Future<bool> updateJournalEntry(JournalEntry entry) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _journalService.updateJournalEntry(entry);
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

  Future<bool> deleteJournalEntry(String entryId) async {
    try {
      await _journalService.deleteJournalEntry(entryId);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<JournalEntry?> getJournalEntry(String entryId) async {
    try {
      return await _journalService.getJournalEntry(entryId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<List<JournalEntry>> searchEntries(String query) async {
    try {
      return await _journalService.searchJournalEntries(query);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}


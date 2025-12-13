import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/journal_entry.dart';
import 'user_service.dart';

/// Journal Service
/// 
/// This service handles all database operations for journal entries
/// Similar to MoodService, but for journal entries instead
class JournalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'journal_entries';

  /// Save a journal entry to the database
  Future<String> saveJournalEntry(JournalEntry entry) async {
    try {
      final docRef = await _firestore
          .collection(_collectionName)
          .add(entry.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to save journal entry: $e');
    }
  }

  /// Get all journal entries for the current user
  /// Returns a stream for real-time updates
  Stream<List<JournalEntry>> getJournalEntries() {
    final userId = UserService.getCurrentUserId();
    
    if (userId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection(_collectionName)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      // Sort in memory to avoid needing a composite index
      final entries = snapshot.docs
          .map((doc) => JournalEntry.fromMap(doc.id, doc.data()))
          .toList();
      // Sort by timestamp descending (newest first)
      entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return entries;
    });
  }

  /// Get journal entries by tag
  /// 
  /// Useful for filtering entries (e.g., show only "gratitude" entries)
  Stream<List<JournalEntry>> getJournalEntriesByTag(String tag) {
    final userId = UserService.getCurrentUserId();
    
    if (userId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection(_collectionName)
        .where('userId', isEqualTo: userId)
        .where('tags', arrayContains: tag)
        .snapshots()
        .map((snapshot) {
      // Sort in memory to avoid needing a composite index
      final entries = snapshot.docs
          .map((doc) => JournalEntry.fromMap(doc.id, doc.data()))
          .toList();
      // Sort by timestamp descending (newest first)
      entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return entries;
    });
  }

  /// Search journal entries by title or content
  /// 
  /// Note: Firestore doesn't have full-text search built-in
  /// This is a simple implementation - for production, you might want
  /// to use a search service like Algolia
  Future<List<JournalEntry>> searchJournalEntries(String query) async {
    final userId = UserService.getCurrentUserId();
    
    if (userId == null || query.isEmpty) {
      return [];
    }

    try {
      // Get all entries and filter in memory
      // This works for small datasets, but for large apps you'd want
      // a proper search solution
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .get();

      final allEntries = snapshot.docs
          .map((doc) => JournalEntry.fromMap(doc.id, doc.data()))
          .toList();

      // Filter entries that match the search query
      final queryLower = query.toLowerCase();
      return allEntries.where((entry) {
        return entry.title.toLowerCase().contains(queryLower) ||
            entry.content.toLowerCase().contains(queryLower);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  /// Get a single journal entry by ID
  Future<JournalEntry?> getJournalEntry(String entryId) async {
    try {
      final doc = await _firestore
          .collection(_collectionName)
          .doc(entryId)
          .get();

      if (!doc.exists) {
        return null;
      }

      return JournalEntry.fromMap(doc.id, doc.data()!);
    } catch (e) {
      return null;
    }
  }

  /// Update an existing journal entry
  Future<void> updateJournalEntry(JournalEntry entry) async {
    if (entry.id == null) {
      throw Exception('Cannot update entry without ID');
    }

    try {
      // Update the entry and set updatedAt timestamp
      final updatedEntry = entry.copyWith(
        updatedAt: DateTime.now(),
      );
      
      await _firestore
          .collection(_collectionName)
          .doc(entry.id)
          .update(updatedEntry.toMap());
    } catch (e) {
      throw Exception('Failed to update journal entry: $e');
    }
  }

  /// Delete a journal entry
  Future<void> deleteJournalEntry(String entryId) async {
    try {
      await _firestore.collection(_collectionName).doc(entryId).delete();
    } catch (e) {
      throw Exception('Failed to delete journal entry: $e');
    }
  }
}


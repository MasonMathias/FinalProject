import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/journal_entry.dart';
import 'user_service.dart';

class JournalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'journal_entries';

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

  Future<List<JournalEntry>> searchJournalEntries(String query) async {
    final userId = UserService.getCurrentUserId();
    
    if (userId == null || query.isEmpty) {
      return [];
    }

    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .get();

      final allEntries = snapshot.docs
          .map((doc) => JournalEntry.fromMap(doc.id, doc.data()))
          .toList();

      final queryLower = query.toLowerCase();
      return allEntries.where((entry) {
        return entry.title.toLowerCase().contains(queryLower) ||
            entry.content.toLowerCase().contains(queryLower);
      }).toList();
    } catch (e) {
      return [];
    }
  }

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

  Future<void> updateJournalEntry(JournalEntry entry) async {
    if (entry.id == null) {
      throw Exception('Cannot update entry without ID');
    }

    try {
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

  Future<void> deleteJournalEntry(String entryId) async {
    try {
      await _firestore.collection(_collectionName).doc(entryId).delete();
    } catch (e) {
      throw Exception('Failed to delete journal entry: $e');
    }
  }
}


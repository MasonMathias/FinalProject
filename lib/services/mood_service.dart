import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/mood_entry.dart';
import 'user_service.dart';

/// Mood Service
/// 
/// This service handles all database operations for mood entries
/// It's like a helper that knows how to save, load, and delete moods
class MoodService {
  // Reference to the Firestore database
  // This is like pointing to a specific folder in the database
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // The collection name in Firestore where we store mood entries
  // Think of it like a table in a database
  static const String _collectionName = 'mood_entries';

  /// Save a mood entry to the database
  /// 
  /// Takes a MoodEntry object and saves it to Firestore
  /// Returns the ID of the saved entry
  Future<String> saveMoodEntry(MoodEntry entry) async {
    try {
      // Add the entry to Firestore
      // Firestore automatically generates an ID for us
      final docRef = await _firestore
          .collection(_collectionName)
          .add(entry.toMap());
      
      // Return the ID so we can use it later if needed
      return docRef.id;
    } catch (e) {
      // If something goes wrong, throw an error
      // The calling code can catch this and show a message to the user
      throw Exception('Failed to save mood entry: $e');
    }
  }

  /// Get all mood entries for the current user
  /// 
  /// Returns a stream, which means it will automatically update
  /// when new entries are added (real-time updates!)
  Stream<List<MoodEntry>> getMoodEntries() {
    final userId = UserService.getCurrentUserId();
    
    if (userId == null) {
      // If no user ID, return empty stream
      return Stream.value([]);
    }

    // Query Firestore for entries belonging to this user
    // Sort in memory to avoid needing a composite index
    return _firestore
        .collection(_collectionName)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      // Convert Firestore documents to MoodEntry objects
      final entries = snapshot.docs
          .map((doc) => MoodEntry.fromMap(doc.id, doc.data()))
          .toList();
      // Sort by timestamp descending (newest first)
      entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return entries;
    });
  }

  /// Get mood entries for a specific date range
  /// 
  /// Useful for analytics - we can get moods from the last week, month, etc.
  Stream<List<MoodEntry>> getMoodEntriesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    final userId = UserService.getCurrentUserId();
    
    if (userId == null) {
      return Stream.value([]);
    }

    // Query with date range - filter by userId first, then filter and sort in memory
    return _firestore
        .collection(_collectionName)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      // Filter by date range and sort in memory to avoid composite index
      final allEntries = snapshot.docs
          .map((doc) => MoodEntry.fromMap(doc.id, doc.data()))
          .toList();
      
      // Filter by date range
      final filteredEntries = allEntries.where((entry) {
        return entry.timestamp.isAfter(startDate.subtract(const Duration(seconds: 1))) &&
               entry.timestamp.isBefore(endDate.add(const Duration(seconds: 1)));
      }).toList();
      
      // Sort by timestamp ascending (oldest first)
      filteredEntries.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return filteredEntries;
    });
  }

  /// Get today's mood entry (if it exists)
  /// 
  /// Useful to check if user already logged their mood today
  Future<MoodEntry?> getTodaysMood() async {
    final userId = UserService.getCurrentUserId();
    
    if (userId == null) {
      return null;
    }

    // Get today's date at midnight (start of day)
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    try {
      // Query for entries today
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .where('timestamp', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
          .where('timestamp', isLessThan: endOfDay.toIso8601String())
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return null; // No entry for today
      }

      // Return the first (and should be only) entry
      return MoodEntry.fromMap(
        snapshot.docs.first.id,
        snapshot.docs.first.data(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Delete a mood entry
  /// 
  /// Takes the entry ID and removes it from the database
  Future<void> deleteMoodEntry(String entryId) async {
    try {
      await _firestore.collection(_collectionName).doc(entryId).delete();
    } catch (e) {
      throw Exception('Failed to delete mood entry: $e');
    }
  }

  /// Update an existing mood entry
  /// 
  /// Useful if user wants to change their mood entry
  Future<void> updateMoodEntry(MoodEntry entry) async {
    if (entry.id == null) {
      throw Exception('Cannot update entry without ID');
    }

    try {
      await _firestore
          .collection(_collectionName)
          .doc(entry.id)
          .update(entry.toMap());
    } catch (e) {
      throw Exception('Failed to update mood entry: $e');
    }
  }
}


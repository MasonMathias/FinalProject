import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/mood_entry.dart';
import 'user_service.dart';

class MoodService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'mood_entries';

  Future<String> saveMoodEntry(MoodEntry entry) async {
    try {
      final docRef = await _firestore
          .collection(_collectionName)
          .add(entry.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to save mood entry: $e');
    }
  }

  Stream<List<MoodEntry>> getMoodEntries() {
    final userId = UserService.getCurrentUserId();
    
    if (userId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection(_collectionName)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final entries = snapshot.docs
          .map((doc) => MoodEntry.fromMap(doc.id, doc.data()))
          .toList();
      entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return entries;
    });
  }

  Stream<List<MoodEntry>> getMoodEntriesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    final userId = UserService.getCurrentUserId();
    
    if (userId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection(_collectionName)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final allEntries = snapshot.docs
          .map((doc) => MoodEntry.fromMap(doc.id, doc.data()))
          .toList();
      
      final filteredEntries = allEntries.where((entry) {
        return entry.timestamp.isAfter(startDate.subtract(const Duration(seconds: 1))) &&
               entry.timestamp.isBefore(endDate.add(const Duration(seconds: 1)));
      }).toList();
      
      filteredEntries.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return filteredEntries;
    });
  }

  Future<MoodEntry?> getTodaysMood() async {
    final userId = UserService.getCurrentUserId();
    
    if (userId == null) {
      return null;
    }

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .where('timestamp', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
          .where('timestamp', isLessThan: endOfDay.toIso8601String())
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      return MoodEntry.fromMap(
        snapshot.docs.first.id,
        snapshot.docs.first.data(),
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteMoodEntry(String entryId) async {
    try {
      await _firestore.collection(_collectionName).doc(entryId).delete();
    } catch (e) {
      throw Exception('Failed to delete mood entry: $e');
    }
  }

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


import '../models/mood_entry.dart';
import '../models/journal_entry.dart';

/// Analytics Service
/// 
/// This service calculates statistics and insights from user data
/// It processes mood entries and journal entries to provide analytics
class AnalyticsService {
  /// Calculate average mood from a list of mood entries
  /// 
  /// Converts mood strings to numbers:
  /// 'great' = 5, 'good' = 4, 'okay' = 3, 'down' = 2, 'struggling' = 1
  double calculateAverageMood(List<MoodEntry> entries) {
    if (entries.isEmpty) return 0.0;

    int total = 0;
    for (var entry in entries) {
      total += _moodToNumber(entry.mood);
    }

    return total / entries.length;
  }

  /// Convert mood string to number for calculations
  int _moodToNumber(String mood) {
    switch (mood.toLowerCase()) {
      case 'great':
        return 5;
      case 'good':
        return 4;
      case 'okay':
        return 3;
      case 'down':
        return 2;
      case 'struggling':
        return 1;
      default:
        return 3; // Default to middle value
    }
  }

  /// Get the most common mood from a list of entries
  String getMostCommonMood(List<MoodEntry> entries) {
    if (entries.isEmpty) return '—';

    // Count occurrences of each mood
    final moodCounts = <String, int>{};
    for (var entry in entries) {
      moodCounts[entry.mood] = (moodCounts[entry.mood] ?? 0) + 1;
    }

    // Find the mood with the highest count
    String mostCommon = 'okay';
    int maxCount = 0;
    moodCounts.forEach((mood, count) {
      if (count > maxCount) {
        maxCount = count;
        mostCommon = mood;
      }
    });

    return mostCommon;
  }

  /// Get mood distribution (how many of each mood)
  /// 
  /// Returns a map with mood as key and count as value
  Map<String, int> getMoodDistribution(List<MoodEntry> entries) {
    final distribution = <String, int>{
      'great': 0,
      'good': 0,
      'okay': 0,
      'down': 0,
      'struggling': 0,
    };

    for (var entry in entries) {
      if (distribution.containsKey(entry.mood)) {
        distribution[entry.mood] = (distribution[entry.mood] ?? 0) + 1;
      }
    }

    return distribution;
  }

  /// Get entries for the last N days
  List<MoodEntry> getEntriesForLastDays(
    List<MoodEntry> allEntries,
    int days,
  ) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    return allEntries.where((entry) {
      return entry.timestamp.isAfter(cutoffDate);
    }).toList();
  }

  /// Get entries for a specific week
  List<MoodEntry> getEntriesForWeek(
    List<MoodEntry> allEntries,
    DateTime weekStart,
  ) {
    final weekEnd = weekStart.add(const Duration(days: 7));
    return allEntries.where((entry) {
      return entry.timestamp.isAfter(weekStart) &&
          entry.timestamp.isBefore(weekEnd);
    }).toList();
  }

  /// Get weekly summary statistics
  Map<String, dynamic> getWeeklySummary(
    List<MoodEntry> moodEntries,
    List<JournalEntry> journalEntries,
  ) {
    final weekStart = DateTime.now().subtract(const Duration(days: 7));
    final weekMoods = getEntriesForLastDays(moodEntries, 7);
    final weekJournals = journalEntries.where((entry) {
      return entry.timestamp.isAfter(weekStart);
    }).toList();

    return {
      'moodCount': weekMoods.length,
      'journalCount': weekJournals.length,
      'averageMood': weekMoods.isEmpty
          ? 0.0
          : calculateAverageMood(weekMoods),
      'mostCommonMood': getMostCommonMood(weekMoods),
    };
  }

  /// Get mood trend data for charts
  /// 
  /// Returns data points for the last N days
  List<Map<String, dynamic>> getMoodTrendData(
    List<MoodEntry> entries,
    int days,
  ) {
    final trendData = <Map<String, dynamic>>[];
    final now = DateTime.now();

    // Create a data point for each day
    for (int i = days - 1; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: i));
      final nextDate = date.add(const Duration(days: 1));

      // Find entries for this day
      final dayEntries = entries.where((entry) {
        return entry.timestamp.isAfter(date) &&
            entry.timestamp.isBefore(nextDate);
      }).toList();

      // Calculate average mood for this day
      final avgMood = dayEntries.isEmpty
          ? 0.0
          : calculateAverageMood(dayEntries);

      trendData.add({
        'date': date,
        'averageMood': avgMood,
        'entryCount': dayEntries.length,
      });
    }

    return trendData;
  }
}


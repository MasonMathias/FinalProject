class MoodEntry {
  final String? id;
  final String userId;
  final String mood;
  final String? note;
  final DateTime timestamp;

  MoodEntry({
    this.id,
    required this.userId,
    required this.mood,
    this.note,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'mood': mood,
      'note': note ?? '',
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory MoodEntry.fromMap(String id, Map<String, dynamic> map) {
    return MoodEntry(
      id: id,
      userId: map['userId'] ?? '',
      mood: map['mood'] ?? '',
      note: map['note']?.toString().isEmpty == true ? null : map['note'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  MoodEntry copyWith({
    String? id,
    String? userId,
    String? mood,
    String? note,
    DateTime? timestamp,
  }) {
    return MoodEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      mood: mood ?? this.mood,
      note: note ?? this.note,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}


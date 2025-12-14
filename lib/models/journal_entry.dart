class JournalEntry {
  final String? id;
  final String userId;
  final String title;
  final String content;
  final List<String> tags;
  final DateTime timestamp;
  final DateTime? updatedAt;

  JournalEntry({
    this.id,
    required this.userId,
    required this.title,
    required this.content,
    this.tags = const [],
    required this.timestamp,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'content': content,
      'tags': tags,
      'timestamp': timestamp.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory JournalEntry.fromMap(String id, Map<String, dynamic> map) {
    return JournalEntry(
      id: id,
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      timestamp: DateTime.parse(map['timestamp']),
      updatedAt: map['updatedAt'] != null 
          ? DateTime.parse(map['updatedAt']) 
          : null,
    );
  }

  JournalEntry copyWith({
    String? id,
    String? userId,
    String? title,
    String? content,
    List<String>? tags,
    DateTime? timestamp,
    DateTime? updatedAt,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      timestamp: timestamp ?? this.timestamp,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}


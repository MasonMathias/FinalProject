class Reminder {
  final String? id;
  final String userId;
  final String type;
  final String? message;
  final String time;
  final bool enabled;
  final DateTime createdAt;

  Reminder({
    this.id,
    required this.userId,
    required this.type,
    this.message,
    required this.time,
    this.enabled = true,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type,
      'message': message ?? '',
      'time': time,
      'enabled': enabled,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Reminder.fromMap(String id, Map<String, dynamic> map) {
    return Reminder(
      id: id,
      userId: map['userId'] ?? '',
      type: map['type'] ?? '',
      message: map['message']?.toString().isEmpty == true 
          ? null 
          : map['message'],
      time: map['time'] ?? '',
      enabled: map['enabled'] ?? true,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Reminder copyWith({
    String? id,
    String? userId,
    String? type,
    String? message,
    String? time,
    bool? enabled,
    DateTime? createdAt,
  }) {
    return Reminder(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      message: message ?? this.message,
      time: time ?? this.time,
      enabled: enabled ?? this.enabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}


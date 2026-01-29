/// Model class for Academic Session
/// 
/// Represents a scheduled class, study group, or meeting with attendance tracking.
/// Used by Schedule Specialist for displaying sessions
/// and Forms Specialist for creating/editing sessions.
class Session {
  final String id;
  final String title;
  final DateTime date;
  final String startTime; 
  final String endTime;   
  final String location;
  final String type; // 'Class', 'Mastery Session', 'Study Group', 'PSL Meeting'
  final bool? isPresent; // null = not recorded, true = present, false = absent

  Session({
    required this.id,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.location = '',
    required this.type,
    this.isPresent,
  });

  /// Convert Session to JSON for storage
  /// Used by Data Specialist when saving to shared_preferences
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'location': location,
      'type': type,
      'isPresent': isPresent,
    };
  }

  /// Create Session from JSON when loading from storage
  /// Used by Data Specialist when reading from shared_preferences
  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] as String,
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      location: json['location'] as String? ?? '',
      type: json['type'] as String,
      isPresent: json['isPresent'] as bool?,
    );
  }

  /// Create a copy of this session with some fields changed
  /// Useful for marking attendance or editing session details
  Session copyWith({
    String? id,
    String? title,
    DateTime? date,
    String? startTime,
    String? endTime,
    String? location,
    String? type,
    bool? isPresent,
  }) {
    return Session(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      type: type ?? this.type,
      isPresent: isPresent ?? this.isPresent,
    );
  }

  /// Check if this session is scheduled for today
  /// Used by Team Lead for Dashboard display
  bool isToday() {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if this session is in the past
  bool isPast() {
    final now = DateTime.now();
    final sessionDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(startTime.split(':')[0]),
      int.parse(startTime.split(':')[1]),
    );
    return sessionDateTime.isBefore(now);
  }

  /// Check if attendance has been recorded
  bool hasAttendanceRecorded() {
    return isPresent != null;
  }
}

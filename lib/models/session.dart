enum SessionType {
  classSession,
  masterySession,
  studyGroup,
  pslMeeting,
}

/// Model for an academic session (class, study group, meeting)
class Session {
  final String id;
  final String title;
  final SessionType sessionType;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String location;
  bool? isPresent;

  Session({
    required this.id,
    required this.title,
    required this.sessionType,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
    this.isPresent,
  });

  /// Used for displaying session type as text
  String get typeLabel {
    switch (sessionType) {
      case SessionType.classSession:
        return 'Class';
      case SessionType.masterySession:
        return 'Mastery Session';
      case SessionType.studyGroup:
        return 'Study Group';
      case SessionType.pslMeeting:
        return 'PSL Meeting';
    }
  }

  /// Copy session with modified fields (important for attendance)
  Session copyWith({
    String? id,
    String? title,
    SessionType? sessionType,
    DateTime? date,
    String? startTime,
    String? endTime,
    String? location,
    bool? isPresent,
  }) {
    return Session(
      id: id ?? this.id,
      title: title ?? this.title,
      sessionType: sessionType ?? this.sessionType,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      isPresent: isPresent ?? this.isPresent,
    );
  }

  /// Check if session is today
  bool isToday() {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Convert to JSON for persistence (optional extra credit)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'sessionType': sessionType.name,
      'date': date.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'location': location,
      'isPresent': isPresent,
    };
  }

  /// Create session from JSON
  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'],
      title: json['title'],
      sessionType: SessionType.values.firstWhere(
        (e) => e.name == json['sessionType'],
      ),
      date: DateTime.parse(json['date']),
      startTime: json['startTime'],
      endTime: json['endTime'],
      location: json['location'] ?? '',
      isPresent: json['isPresent'],
    );
  }
    /// Backwards compatibility for Dashboard
  /// Allows dashboard to use session.type
  String get type => typeLabel;

  /// Used by Dashboard to calculate attendance stats
  bool hasAttendanceRecorded() {
    return isPresent != null;
  }
}
enum SessionType { classSession, masterySession, studyGroup, pslMeeting }

/// Model for an academic session (class, study group, meeting)
class Session {
  final String id;
  final String title;
  final SessionType sessionType;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String location;
  final bool? isPresent;

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

  bool isToday() {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

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

  String get type => typeLabel;

  bool hasAttendanceRecorded() {
    return isPresent != null;
  }
}

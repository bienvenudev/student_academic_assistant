/// Model class for Assignment
/// 
/// Represents a student assignment with title, due date, course, and priority.
/// Used by Lists Specialist for displaying assignments
/// and Forms Specialist for creating/editing assignments.
class Assignment {
  final String id;
  final String title;
  final DateTime dueDate;
  final String course;
  final String priority; // 'High', 'Medium', 'Low', or empty string
  final bool isCompleted;

  Assignment({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.course,
    this.priority = '',
    this.isCompleted = false,
  });

  /// Convert Assignment to JSON for storage
  /// Used by Member 5 (Data Specialist) when saving to shared_preferences
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'dueDate': dueDate.toIso8601String(),
      'course': course,
      'priority': priority,
      'isCompleted': isCompleted,
    };
  }

  /// Create Assignment from JSON when loading from storage
  /// Used by Data Specialist when reading from shared_preferences
  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'] as String,
      title: json['title'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      course: json['course'] as String,
      priority: json['priority'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  /// Create a copy of this assignment with some fields changed
  /// Useful for marking assignments as completed or editing them
  Assignment copyWith({
    String? id,
    String? title,
    DateTime? dueDate,
    String? course,
    String? priority,
    bool? isCompleted,
  }) {
    return Assignment(
      id: id ?? this.id,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      course: course ?? this.course,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  /// Check if assignment is due within the next 7 days
  /// Used by Team Lead for Dashboard display
  bool isDueWithinSevenDays() {
    final now = DateTime.now();
    final difference = dueDate.difference(now).inDays;
    return difference >= 0 && difference <= 7;
  }

  /// Check if assignment is overdue
  bool isOverdue() {
    return DateTime.now().isAfter(dueDate) && !isCompleted;
  }
}

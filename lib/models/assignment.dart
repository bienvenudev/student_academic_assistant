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

  bool isDueWithinSevenDays() {
    final now = DateTime.now();
    final difference = dueDate.difference(now).inDays;
    return difference >= 0 && difference <= 7;
  }

  bool isOverdue() {
    return DateTime.now().isAfter(dueDate) && !isCompleted;
  }
}

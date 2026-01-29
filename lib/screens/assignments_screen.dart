import 'package:flutter/material.dart';
import 'package:student_academic_assistant/utils/constants.dart';

/// Assignments Screen - Member 2 (Lists Specialist) will implement this
///
/// TODO for Member 2:
/// - Display list of all assignments sorted by due date
/// - Show assignment cards with title, course, due date, priority
/// - Add checkbox to mark assignments as completed
/// - Add swipe-to-delete or delete button
/// - Add FloatingActionButton to navigate to Add Assignment form
class AssignmentsScreen extends StatelessWidget {
  const AssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assignments')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment,
              size: 64,
              color: AppColors.primaryPurple.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text('Assignments Screen', style: AppTextStyles.heading2),
            const SizedBox(height: 8),
            Text(
              'Member 2: Implement assignment list here',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}

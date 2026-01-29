import 'package:flutter/material.dart';
import 'package:student_academic_assistant/utils/constants.dart';

/// Schedule Screen - Member 3 (Schedule Specialist) will implement this
///
/// TODO for Member 3:
/// - Display weekly calendar view of sessions
/// - Show session cards with title, time, location, type
/// - Add Present/Absent toggle button for each session
/// - Add FloatingActionButton to navigate to Add Session form
/// - Filter to show today's sessions at the top
class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 64,
              color: AppColors.primaryPurple.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text('Schedule Screen', style: AppTextStyles.heading2),
            const SizedBox(height: 8),
            Text(
              'Member 3: Implement session schedule here',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}

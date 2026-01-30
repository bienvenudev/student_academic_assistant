import 'package:flutter/material.dart';
import 'package:student_academic_assistant/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:student_academic_assistant/utils/session_provider.dart';

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
      body: Consumer<SessionProvider>(
        floatingActionButton: FloatingActionButton(
  backgroundColor: AppColors.primaryPurple,
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddSessionScreen(),
      ),
    );
  },
  child: const Icon(Icons.add),
),

  builder: (context, sessionProvider, _) {
    final sessions = sessionProvider.sessions;

    if (sessions.isEmpty) {
      return Center(
        child: Text(
          'No sessions scheduled yet',
          style: AppTextStyles.caption,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: session.isPresent == null
                ? const Icon(Icons.help_outline)
                : session.isPresent!
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(Icons.cancel, color: Colors.red),
            title: Text(session.title),
            subtitle: Text(
              '${session.startTime} - ${session.endTime}\n${session.location}',
            ),
            isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.green),
                  onPressed: () {
                    sessionProvider.markAttendance(session.id, true);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    sessionProvider.markAttendance(session.id, false);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  },
),


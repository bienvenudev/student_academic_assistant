import 'package:flutter/material.dart';
import 'package:student_academic_assistant/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:student_academic_assistant/utils/session_provider.dart';
import 'package:student_academic_assistant/screens/add_session_screen.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SessionProvider>(context, listen: false).loadSessions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryPurple,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddSessionScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<SessionProvider>(
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
                      ? const Icon(
                          Icons.check_circle,
                          color: AppColors.successGreen,
                        )
                      : const Icon(Icons.cancel, color: AppColors.warningRed),
                  title: Text(session.title),
                  subtitle: Text(
                    '${session.startTime} - ${session.endTime}\n${session.location}',
                  ),
                  isThreeLine: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddSessionScreen(sessionToEdit: session),
                      ),
                    );
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.check,
                          color: AppColors.successGreen,
                        ),
                        tooltip: 'Mark as present',
                        onPressed: () {
                          sessionProvider.markAttendance(session.id, true);
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.warningRed,
                        ),
                        tooltip: 'Mark as absent',
                        onPressed: () {
                          sessionProvider.markAttendance(session.id, false);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: 'Delete session',
                        color: AppColors.warningRed,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Session?'),
                              content: const Text(
                                'Are you sure you want to delete this session?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    sessionProvider.removeSession(session.id);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
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
    );
  }
}

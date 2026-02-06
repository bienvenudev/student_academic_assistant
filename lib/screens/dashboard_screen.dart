import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_academic_assistant/models/assignment.dart';
import 'package:student_academic_assistant/models/session.dart';
import 'package:student_academic_assistant/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:student_academic_assistant/utils/session_provider.dart';

class DashboardScreen extends StatefulWidget {
  final List<Assignment> assignments;
  const DashboardScreen({super.key, required this.assignments});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);
    final assignments = widget.assignments;
    final sessions = sessionProvider.sessions;

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateAndWeekCard(),
            const SizedBox(height: 16),
            _buildAttendanceCard(sessions),
            const SizedBox(height: 16),
            _buildPendingAssignmentsCard(assignments),
            const SizedBox(height: 16),
            _buildTodaysSessionsSection(sessions),
            const SizedBox(height: 16),
            _buildUpcomingAssignmentsSection(assignments),
          ],
        ),
      ),
    );
  }

  Widget _buildDateAndWeekCard() {
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, MMMM d, y').format(now);
    final weekNumber = _calculateAcademicWeek(now);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.calendar_today,
                color: AppColors.primaryPurple,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(formattedDate, style: AppTextStyles.heading3),
                  const SizedBox(height: 4),
                  Text(
                    'Academic Week $weekNumber',
                    style: AppTextStyles.bodyText.copyWith(
                      color: AppColors.primaryPurple,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceCard(List<Session> sessions) {
    final attendancePercentage = _calculateAttendancePercentage(sessions);
    final isLowAttendance = attendancePercentage < 75;

    return Card(
      color: isLowAttendance ? AppColors.warningRed.withOpacity(0.1) : null,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isLowAttendance
                    ? AppColors.warningRed.withOpacity(0.2)
                    : AppColors.successGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isLowAttendance ? Icons.warning : Icons.check_circle,
                color: isLowAttendance
                    ? AppColors.warningRed
                    : AppColors.successGreen,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Overall Attendance', style: AppTextStyles.heading3),
                  const SizedBox(height: 4),
                  Text(
                    '${attendancePercentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isLowAttendance
                          ? AppColors.warningRed
                          : AppColors.successGreen,
                    ),
                  ),
                  if (isLowAttendance)
                    Text(
                      'Warning: Attendance below 75%',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.warningRed,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingAssignmentsCard(List<Assignment> assignments) {
    final pendingCount = assignments.where((a) => !a.isCompleted).length;
    final overdueCount = assignments.where((a) => a.isOverdue()).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatColumn(
              'Pending',
              pendingCount.toString(),
              Icons.assignment,
              AppColors.primaryPurple,
            ),
            Container(width: 1, height: 40, color: Colors.grey[300]),
            _buildStatColumn(
              'Overdue',
              overdueCount.toString(),
              Icons.warning,
              AppColors.aluOrange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }

  Widget _buildTodaysSessionsSection(List<Session> sessions) {
    final todaysSessions = sessions.where((s) => s.isToday()).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Today\'s Sessions', style: AppTextStyles.heading2),
        const SizedBox(height: 12),
        if (todaysSessions.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'No sessions scheduled for today',
                  style: AppTextStyles.caption,
                ),
              ),
            ),
          )
        else
          ...todaysSessions.map((session) => _buildSessionCard(session)),
      ],
    );
  }

  Widget _buildUpcomingAssignmentsSection(List<Assignment> assignments) {
    final upcomingAssignments =
        assignments
            .where((a) => a.isDueWithinSevenDays() && !a.isCompleted)
            .toList()
          ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Upcoming Assignments', style: AppTextStyles.heading2),
        const SizedBox(height: 12),
        if (upcomingAssignments.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'No assignments due within 7 days',
                  style: AppTextStyles.caption,
                ),
              ),
            ),
          )
        else
          ...upcomingAssignments.map(
            (assignment) => _buildAssignmentCard(assignment),
          ),
      ],
    );
  }

  Widget _buildSessionCard(Session session) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.fuchsiaPink.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.school, color: AppColors.fuchsiaPink),
        ),
        title: Text(session.title, style: AppTextStyles.heading3),
        subtitle: Text(
          '${session.startTime} - ${session.endTime}${session.location.isNotEmpty ? ' • ${session.location}' : ''}',
          style: AppTextStyles.caption,
        ),
        trailing: Chip(
          label: Text(session.type, style: const TextStyle(fontSize: 10)),
          backgroundColor: AppColors.midnightBlue.withOpacity(0.1),
        ),
      ),
    );
  }

  Widget _buildAssignmentCard(Assignment assignment) {
    final daysUntilDue = assignment.dueDate.difference(DateTime.now()).inDays;
    final isUrgent = daysUntilDue <= 2;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isUrgent
                ? AppColors.aluOrange.withOpacity(0.1)
                : AppColors.primaryPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.assignment,
            color: isUrgent ? AppColors.aluOrange : AppColors.primaryPurple,
          ),
        ),
        title: Text(assignment.title, style: AppTextStyles.heading3),
        subtitle: Text(
          '${assignment.course} • Due ${DateFormat('MMM d').format(assignment.dueDate)}',
          style: AppTextStyles.caption,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              daysUntilDue == 0
                  ? 'Today'
                  : daysUntilDue == 1
                  ? 'Tomorrow'
                  : '${daysUntilDue}d',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isUrgent ? AppColors.aluOrange : AppColors.midnightBlue,
              ),
            ),
            if (assignment.priority.isNotEmpty)
              Text(assignment.priority, style: const TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }

  /// Calculate academic week number based on term start date
  int _calculateAcademicWeek(DateTime currentDate) {
    final difference = currentDate.difference(termStartDate).inDays;
    return (difference / 7).floor() + 1;
  }

  double _calculateAttendancePercentage(List<Session> sessions) {
    if (sessions.isEmpty) {
      return 100.0; // Default to 100% if no sessions
    }

    // Only count sessions that have attendance recorded
    final recordedSessions = sessions
        .where((s) => s.hasAttendanceRecorded())
        .toList();

    if (recordedSessions.isEmpty) {
      return 100.0; // Default to 100% if no attendance recorded yet
    }

    final presentCount = recordedSessions
        .where((s) => s.isPresent == true)
        .length;
    return (presentCount / recordedSessions.length) * 100;
  }
}

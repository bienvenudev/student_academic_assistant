import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_academic_assistant/models/assignment.dart';
import 'package:student_academic_assistant/utils/constants.dart';
import 'package:student_academic_assistant/services/storage_service.dart';
import 'package:student_academic_assistant/screens/add_assignment_screen.dart';

class AssignmentsScreen extends StatefulWidget {
  final List<Assignment> assignments;
  final VoidCallback? onAssignmentsChanged;

  const AssignmentsScreen({
    super.key,
    required this.assignments,
    this.onAssignmentsChanged,
  });

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  void _sortAssignments() {
    widget.assignments.sort((a, b) {
      if (!a.isCompleted && b.isCompleted) return -1;
      if (a.isCompleted && !b.isCompleted) return 1;
      if (!a.isCompleted && a.isOverdue() && !b.isOverdue()) return -1;
      if (!a.isCompleted && !a.isOverdue() && b.isOverdue()) return 1;
      return a.dueDate.compareTo(b.dueDate);
    });
  }

  Future<void> _navigateToAddAssignment({
    Assignment? assignmentToEdit,
  }) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddAssignmentScreen(assignmentToEdit: assignmentToEdit),
      ),
    );

    if (result != null && result is Assignment) {
      setState(() {
        if (assignmentToEdit != null) {
          final index = widget.assignments.indexWhere(
            (a) => a.id == assignmentToEdit.id,
          );
          if (index != -1) {
            widget.assignments[index] = result;
          }
        } else {
          widget.assignments.add(result);
        }
        _sortAssignments();
      });

      await StorageService().saveAssignments(widget.assignments);
      widget.onAssignmentsChanged?.call();
    }
  }

  void _toggleAssignmentCompletion(String id) async {
    setState(() {
      final index = widget.assignments.indexWhere((a) => a.id == id);
      if (index != -1) {
        widget.assignments[index] = widget.assignments[index].copyWith(
          isCompleted: !widget.assignments[index].isCompleted,
        );
        _sortAssignments();
      }
    });
    await StorageService().saveAssignments(widget.assignments);
    widget.onAssignmentsChanged?.call();
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Assignment?'),
        content: const Text('Are you sure you want to delete this assignment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _deleteAssignment(id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteAssignment(String id) async {
    setState(() {
      widget.assignments.removeWhere((a) => a.id == id);
    });
    await StorageService().saveAssignments(widget.assignments);
    widget.onAssignmentsChanged?.call();
  }

  Color _priorityColor(String priority) {
    switch (priority) {
      case 'High':
        return AppColors.warningRed;
      case 'Medium':
        return AppColors.aluOrange;
      case 'Low':
        return AppColors.successGreen;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assignments')),
      body: widget.assignments.isEmpty
          ? const Center(child: Text('No assignments yet'))
          : ListView.builder(
              itemCount: widget.assignments.length,
              itemBuilder: (context, index) {
                final assignment = widget.assignments[index];
                return ListTile(
                  leading: Checkbox(
                    value: assignment.isCompleted,
                    onChanged: (_) =>
                        _toggleAssignmentCompletion(assignment.id),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          assignment.title,
                          style: TextStyle(
                            color: assignment.isOverdue() &&
                                    !assignment.isCompleted
                                ? AppColors.warningRed
                                : null,
                            decoration: assignment.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _priorityColor(assignment.priority),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          assignment.priority,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    '${assignment.course} • ${DateFormat('MMM d').format(assignment.dueDate)}',
                  ),
                  onTap: () => _navigateToAddAssignment(
                    assignmentToEdit: assignment,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete,
                        color: AppColors.warningRed),
                    onPressed: () => _confirmDelete(assignment.id),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddAssignment(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

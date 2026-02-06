import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_academic_assistant/models/assignment.dart';
import 'package:student_academic_assistant/utils/constants.dart';

class AssignmentsScreen extends StatefulWidget {
  final List<Assignment> assignments;
  final VoidCallback?
  onAssignmentsChanged; // Callback to notify parent of changes

  const AssignmentsScreen({
    super.key,
    required this.assignments,
    this.onAssignmentsChanged,
  });

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  DateTime? _selectedDueDate;
  String _selectedPriority = 'Medium';
  String? _editingAssignmentId;

  @override
  void initState() {
    super.initState();
  }

  void _sortAssignments() {
    widget.assignments.sort((a, b) {
      if (!a.isCompleted && b.isCompleted) return -1;
      if (a.isCompleted && !b.isCompleted) return 1;

      if (!a.isCompleted && a.isOverdue() && !b.isOverdue()) return -1;
      if (!a.isCompleted && !a.isOverdue() && b.isOverdue()) return 1;

      return a.dueDate.compareTo(b.dueDate);
    });
  }

  Future<void> _showAssignmentDialog({Assignment? assignmentToEdit}) async {
    if (assignmentToEdit != null) {
      _editingAssignmentId = assignmentToEdit.id;
      _titleController.text = assignmentToEdit.title;
      _courseController.text = assignmentToEdit.course;
      _selectedDueDate = assignmentToEdit.dueDate;
      _selectedPriority = assignmentToEdit.priority.isNotEmpty
          ? assignmentToEdit.priority
          : 'Medium';
    } else {
      _clearForm();
    }

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: Text(
            assignmentToEdit != null ? 'Edit Assignment' : 'Add New Assignment',
            style: AppTextStyles.heading2,
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Assignment Title*',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _courseController,
                  decoration: const InputDecoration(labelText: 'Course Name*'),
                ),
                const SizedBox(height: 16),
                TextField(
                  readOnly: true,
                  controller: TextEditingController(
                    text: _selectedDueDate == null
                        ? ''
                        : DateFormat('MMM d, yyyy').format(_selectedDueDate!),
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Due Date*',
                    suffixIcon: Icon(Icons.calendar_today),
                    hintText: 'Select Due Date',
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDueDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setStateDialog(() => _selectedDueDate = picked);
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedPriority,
                  items: priorityLevels
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (value) =>
                      setStateDialog(() => _selectedPriority = value!),
                  decoration: const InputDecoration(labelText: 'Priority'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _clearForm();
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _validateAndSaveAssignment,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    _clearForm();
  }

  void _validateAndSaveAssignment() {
    final title = _titleController.text.trim();
    final course = _courseController.text.trim();

    if (title.isEmpty || course.isEmpty || _selectedDueDate == null) {
      _showErrorSnackbar('All required fields must be filled');
      return;
    }

    final assignment = Assignment(
      id:
          _editingAssignmentId ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      course: course,
      dueDate: _selectedDueDate!,
      priority: _selectedPriority,
    );

    setState(() {
      if (_editingAssignmentId != null) {
        final index = widget.assignments.indexWhere(
          (a) => a.id == _editingAssignmentId,
        );
        if (index != -1) widget.assignments[index] = assignment;
      } else {
        widget.assignments.add(assignment);
      }
      _sortAssignments();
    });

    widget.onAssignmentsChanged?.call();
    _clearForm();
    Navigator.pop(context);
  }

  void _toggleAssignmentCompletion(String id) {
    setState(() {
      final index = widget.assignments.indexWhere((a) => a.id == id);
      if (index != -1) {
        widget.assignments[index] = widget.assignments[index].copyWith(
          isCompleted: !widget.assignments[index].isCompleted,
        );
        _sortAssignments();
        widget.onAssignmentsChanged?.call();
      }
    });
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

  void _deleteAssignment(String id) {
    setState(() {
      widget.assignments.removeWhere((a) => a.id == id);
    });
    widget.onAssignmentsChanged?.call();
  }

  void _clearForm() {
    _titleController.clear();
    _courseController.clear();
    _selectedDueDate = null;
    _selectedPriority = 'Medium';
    _editingAssignmentId = null;
  }

  void _showErrorSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.warningRed),
    );
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
                    onChanged: (value) =>
                        _toggleAssignmentCompletion(assignment.id),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          assignment.title,
                          style: TextStyle(
                            color:
                                assignment.isOverdue() &&
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
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _priorityColor(assignment.priority),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          assignment.priority,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    '${assignment.course} • ${DateFormat('MMM d').format(assignment.dueDate)}',
                  ),
                  onTap: () =>
                      _showAssignmentDialog(assignmentToEdit: assignment),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: AppColors.warningRed),
                    onPressed: () => _confirmDelete(assignment.id),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAssignmentDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _courseController.dispose();
    super.dispose();
  }
}

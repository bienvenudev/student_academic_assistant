import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_academic_assistant/models/assignment.dart';
import 'package:student_academic_assistant/utils/constants.dart';

class AssignmentsScreen extends StatefulWidget {
  final List<Assignment> assignments;

  const AssignmentsScreen({
    super.key,
    required this.assignments,
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
    _loadAssignments();
  }

  /// Load assignments (mock for now)
  void _loadAssignments() {
    if (widget.assignments.isNotEmpty) return;

    final mockAssignments = [
      Assignment(
        id: '1',
        title: 'Mathematics Problem Set',
        dueDate: DateTime.now().add(const Duration(days: 3)),
        course: 'Calculus I',
        priority: 'High',
      ),
      Assignment(
        id: '2',
        title: 'Physics Lab Report',
        dueDate: DateTime.now().add(const Duration(days: 5)),
        course: 'Mechanics',
        priority: 'Medium',
      ),
      Assignment(
        id: '3',
        title: 'Literature Essay',
        dueDate: DateTime.now().add(const Duration(days: 7)),
        course: 'English Literature',
        priority: 'Low',
        isCompleted: true,
      ),
      Assignment(
        id: '4',
        title: 'Programming Project',
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
        course: 'Computer Science',
        priority: 'High',
      ),
    ];

    setState(() {
      widget.assignments
        ..clear()
        ..addAll(mockAssignments)
        ..sort(_sortByDueDate);
    });
  }

  int _sortByDueDate(Assignment a, Assignment b) {
    if (a.isOverdue() && !b.isOverdue()) return -1;
    if (!a.isOverdue() && b.isOverdue()) return 1;
    return a.dueDate.compareTo(b.dueDate);
  }

  Future<void> _showAssignmentDialog({Assignment? assignmentToEdit}) async {
    if (assignmentToEdit != null) {
      _editingAssignmentId = assignmentToEdit.id;
      _titleController.text = assignmentToEdit.title;
      _courseController.text = assignmentToEdit.course;
      _selectedDueDate = assignmentToEdit.dueDate;
      _selectedPriority =
          assignmentToEdit.priority.isNotEmpty ? assignmentToEdit.priority : 'Medium';
    } else {
      _clearForm();
    }

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          assignmentToEdit != null ? 'Edit Assignment' : 'Add New Assignment',
          style: AppTextStyles.heading2,
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Assignment Title*'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _courseController,
                decoration: const InputDecoration(labelText: 'Course Name*'),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDueDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() => _selectedDueDate = picked);
                  }
                },
                child: Text(
                  _selectedDueDate == null
                      ? 'Select Due Date*'
                      : DateFormat('MMM d, yyyy').format(_selectedDueDate!),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                items: ['High', 'Medium', 'Low', '']
                    .map((p) => DropdownMenuItem(
                          value: p,
                          child: Text(p.isEmpty ? 'No Priority' : p),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedPriority = value!),
                decoration: const InputDecoration(labelText: 'Priority'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: _validateAndSaveAssignment,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _validateAndSaveAssignment() {
    if (_titleController.text.isEmpty ||
        _courseController.text.isEmpty ||
        _selectedDueDate == null) {
      _showErrorSnackbar('All required fields must be filled');
      return;
    }

    final assignment = Assignment(
      id: _editingAssignmentId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      course: _courseController.text.trim(),
      dueDate: _selectedDueDate!,
      priority: _selectedPriority == 'Medium' ? '' : _selectedPriority,
    );

    setState(() {
      if (_editingAssignmentId != null) {
        final index =
            widget.assignments.indexWhere((a) => a.id == _editingAssignmentId);
        widget.assignments[index] = assignment;
      } else {
        widget.assignments.add(assignment);
      }
      widget.assignments.sort(_sortByDueDate);
    });

    _clearForm();
    Navigator.pop(context);
  }

  void _toggleAssignmentCompletion(String id) {
    setState(() {
      final index = widget.assignments.indexWhere((a) => a.id == id);
      widget.assignments[index] =
          widget.assignments[index].copyWith(isCompleted: !widget.assignments[index].isCompleted);
    });
  }

  void _deleteAssignment(String id) {
    setState(() {
      widget.assignments.removeWhere((a) => a.id == id);
    });
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
                    onChanged: (_) => _toggleAssignmentCompletion(assignment.id),
                  ),
                  title: Text(assignment.title),
                  subtitle: Text(
                    '${assignment.course} • ${DateFormat('MMM d').format(assignment.dueDate)}',
                  ),
                  onTap: () => _showAssignmentDialog(assignmentToEdit: assignment),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteAssignment(assignment.id),
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

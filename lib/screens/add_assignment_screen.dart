import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:student_academic_assistant/models/assignment.dart';
import 'package:student_academic_assistant/utils/constants.dart';

class AddAssignmentScreen extends StatefulWidget {
  final Assignment? assignmentToEdit;

  const AddAssignmentScreen({super.key, this.assignmentToEdit});

  @override
  State<AddAssignmentScreen> createState() => _AddAssignmentScreenState();
}

class _AddAssignmentScreenState extends State<AddAssignmentScreen> {
  final _titleController = TextEditingController();
  final _courseController = TextEditingController();

  DateTime? _selectedDueDate;
  String _selectedPriority = 'Medium';

  @override
  void initState() {
    super.initState();

    if (widget.assignmentToEdit != null) {
      _titleController.text = widget.assignmentToEdit!.title;
      _courseController.text = widget.assignmentToEdit!.course;
      _selectedDueDate = widget.assignmentToEdit!.dueDate;
      _selectedPriority = widget.assignmentToEdit!.priority;
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDueDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.assignmentToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Assignment' : 'Add Assignment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Assignment Title',
              ),
            ),
            TextField(
              controller: _courseController,
              decoration: const InputDecoration(
                labelText: 'Course',
              ),
            ),
            const SizedBox(height: 12),

            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Due Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  _selectedDueDate == null
                      ? 'Select date'
                      : DateFormat('MMM d, yyyy').format(_selectedDueDate!),
                ),
              ),
            ),

            const SizedBox(height: 12),

            DropdownButton<String>(
              value: _selectedPriority,
              items: priorityLevels.map((p) {
                return DropdownMenuItem(
                  value: p,
                  child: Text(p),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedPriority = value!);
              },
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isEmpty ||
                    _courseController.text.isEmpty ||
                    _selectedDueDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all required fields'),
                    ),
                  );
                  return;
                }

                final assignment = Assignment(
                  id: widget.assignmentToEdit?.id ??
                      DateTime.now().millisecondsSinceEpoch.toString(),
                  title: _titleController.text,
                  course: _courseController.text,
                  dueDate: _selectedDueDate!,
                  priority: _selectedPriority,
                  isCompleted:
                      widget.assignmentToEdit?.isCompleted ?? false,
                );

                Navigator.pop(context, assignment);
              },
              child: const Text('Save Assignment'),
            ),
          ],
        ),
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

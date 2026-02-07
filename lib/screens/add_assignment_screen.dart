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
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _courseController;

  DateTime? _selectedDueDate;
  String _selectedPriority = 'Medium';

  @override
  void initState() {
    super.initState();

    _titleController =
        TextEditingController(text: widget.assignmentToEdit?.title ?? '');
    _courseController =
        TextEditingController(text: widget.assignmentToEdit?.course ?? '');

    _selectedDueDate = widget.assignmentToEdit?.dueDate;
    _selectedPriority =
        widget.assignmentToEdit?.priority ?? 'Medium';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() => _selectedDueDate = picked);
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate() || _selectedDueDate == null) {
      return;
    }

    final assignment = Assignment(
      id: widget.assignmentToEdit?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      course: _courseController.text.trim(),
      dueDate: _selectedDueDate!,
      priority: _selectedPriority,
      isCompleted: widget.assignmentToEdit?.isCompleted ?? false,
    );

    Navigator.pop(context, assignment);
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Assignment Title*',
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _courseController,
                decoration: const InputDecoration(
                  labelText: 'Course Name*',
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Due Date*'),
                subtitle: Text(
                  _selectedDueDate == null
                      ? 'Select date'
                      : DateFormat('MMM d, yyyy')
                          .format(_selectedDueDate!),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedPriority,
                items: priorityLevels
                    .map(
                      (p) => DropdownMenuItem(
                        value: p,
                        child: Text(p),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _selectedPriority = v!),
                decoration: const InputDecoration(labelText: 'Priority'),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _save,
                      child: const Text('Save'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

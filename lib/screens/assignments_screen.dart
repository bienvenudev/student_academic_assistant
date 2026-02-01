import 'package:flutter/material.dart';
import '../models/assignment.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  List<Assignment> assignments = [];
  final _formKey = GlobalKey<FormState>();

  // Temporary form values
  String _title = '';
  String _course = '';
  DateTime? _dueDate;
  String _priority = 'Medium';
  int? _editingIndex;

  /// Open form to add/edit assignment
  void _showAssignmentForm({Assignment? assignment, int? index}) {
    if (assignment != null) {
      _title = assignment.title;
      _course = assignment.course;
      _dueDate = assignment.dueDate;
      _priority = assignment.priority.isEmpty ? 'Medium' : assignment.priority;
      _editingIndex = index;
    } else {
      _title = '';
      _course = '';
      _dueDate = null;
      _priority = 'Medium';
      _editingIndex = null;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(assignment != null ? 'Edit Assignment' : 'New Assignment'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: _title,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                  onSaved: (val) => _title = val!,
                ),
                TextFormField(
                  initialValue: _course,
                  decoration: const InputDecoration(labelText: 'Course'),
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                  onSaved: (val) => _course = val!,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      _dueDate == null
                          ? 'No Date Chosen'
                          : 'Due: ${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _dueDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) setState(() => _dueDate = picked);
                      },
                      child: const Text('Pick Date'),
                    ),
                  ],
                ),
                DropdownButtonFormField(
                  value: _priority,
                  items: ['High', 'Medium', 'Low']
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (val) => setState(() => _priority = val!),
                  decoration: const InputDecoration(labelText: 'Priority'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate() && _dueDate != null) {
                _formKey.currentState!.save();
                setState(() {
                  if (_editingIndex != null) {
                    // Edit existing
                    assignments[_editingIndex!] = assignments[_editingIndex!].copyWith(
                      title: _title,
                      course: _course,
                      dueDate: _dueDate,
                      priority: _priority,
                    );
                  } else {
                    // Add new
                    assignments.add(Assignment(
                      title: _title,
                      course: _course,
                      dueDate: _dueDate!,
                      priority: _priority,
                    ));
                  }
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Sort assignments by due date
    assignments.sort((a, b) => a.dueDate.compareTo(b.dueDate));

    return Scaffold(
      appBar: AppBar(title: const Text('Assignments')),
      body: assignments.isEmpty
          ? const Center(child: Text('No assignments yet'))
          : ListView.builder(
              itemCount: assignments.length,
              itemBuilder: (context, index) {
                final assignment = assignments[index];
                Color priorityColor;
                switch (assignment.priority) {
                  case 'High':
                    priorityColor = Colors.red;
                    break;
                  case 'Medium':
                    priorityColor = Colors.orange;
                    break;
                  default:
                    priorityColor = Colors.green;
                }

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    leading: Checkbox(
                      value: assignment.isCompleted,
                      onChanged: (val) => setState(() => assignments[index] =
                          assignment.copyWith(isCompleted: val)),
                    ),
                    title: Text(
                      assignment.title,
                      style: TextStyle(
                        decoration: assignment.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Text(
                      '${assignment.course} • Due: ${assignment.dueDate.day}/${assignment.dueDate.month}/${assignment.dueDate.year}',
                      style: TextStyle(color: priorityColor),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showAssignmentForm(
                              assignment: assignment, index: index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => setState(() => assignments.removeAt(index)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAssignmentForm(),
      ),
    );
  }
}

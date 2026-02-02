import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/assignment.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  List<Assignment> assignments = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  DateTime? _selectedDueDate;
  String _selectedPriority = 'Medium';

  @override
  void initState() {
    super.initState();
    _loadAssignments();
  }

  void _loadAssignments() {
    setState(() {
      assignments = [
        Assignment(
          id: '1',
          title: 'Math Homework',
          dueDate: DateTime.now().add(const Duration(days: 3)),
          course: 'Mathematics',
          priority: 'High',
        ),
        Assignment(
          id: '2',
          title: 'Physics Lab Report',
          dueDate: DateTime.now().add(const Duration(days: 5)),
          course: 'Physics',
          priority: 'Medium',
        ),
      ]..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    });
  }

  Future<void> _addAssignment() async {
    if (_titleController.text.isEmpty || _selectedDueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and due date are required')),
      );
      return;
    }

    final newAssignment = Assignment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      dueDate: _selectedDueDate!,
      course: _courseController.text,
      priority: _selectedPriority,
    );

    setState(() {
      assignments.add(newAssignment);
      assignments.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    });

    // Clear form
    _titleController.clear();
    _courseController.clear();
    _selectedDueDate = null;
    _selectedPriority = 'Medium';

    Navigator.of(context).pop();
  }

  Future<void> _showAddAssignmentDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add New Assignment'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Assignment Title*',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _courseController,
                      decoration: const InputDecoration(
                        labelText: 'Course Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: Text(
                        _selectedDueDate == null
                            ? 'Select Due Date*'
                            : 'Due Date: ${DateFormat('MMM d, yyyy').format(_selectedDueDate!)}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _selectedDueDate = pickedDate;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedPriority,
                      decoration: const InputDecoration(
                        labelText: 'Priority',
                        border: OutlineInputBorder(),
                      ),
                      items: ['High', 'Medium', 'Low']
                          .map((priority) => DropdownMenuItem(
                                value: priority,
                                child: Text(priority),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedPriority = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _addAssignment,
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _toggleAssignmentCompletion(String id) {
    setState(() {
      final index = assignments.indexWhere((a) => a.id == id);
      if (index != -1) {
        assignments[index].isCompleted = !assignments[index].isCompleted;
      }
    });
  }

  void _deleteAssignment(String id) {
    setState(() {
      assignments.removeWhere((a) => a.id == id);
    });
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddAssignmentDialog,
          ),
        ],
      ),
      body: assignments.isEmpty
          ? const Center(
              child: Text('No assignments yet. Add one to get started!'),
            )
          : ListView.builder(
              itemCount: assignments.length,
              itemBuilder: (context, index) {
                final assignment = assignments[index];
                final daysLeft =
                    assignment.dueDate.difference(DateTime.now()).inDays;

                return Dismissible(
                  key: Key(assignment.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => _deleteAssignment(assignment.id),
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value: assignment.isCompleted,
                        onChanged: (_) =>
                            _toggleAssignmentCompletion(assignment.id),
                      ),
                      title: Text(
                        assignment.title,
                        style: TextStyle(
                          decoration: assignment.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(assignment.course),
                          Text(
                            'Due: ${DateFormat('MMM d, yyyy').format(assignment.dueDate)}',
                            style: TextStyle(
                              color: daysLeft <= 2 ? Colors.red : null,
                            ),
                          ),
                        ],
                      ),
                      trailing: Chip(
                        label: Text(
                          assignment.priority,
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: _getPriorityColor(assignment.priority),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAssignmentDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

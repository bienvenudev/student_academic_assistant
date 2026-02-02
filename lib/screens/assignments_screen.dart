import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_academic_assistant/models/assignment.dart';
import 'package:student_academic_assistant/utils/constants.dart';

class AssignmentsScreen extends StatefulWidget {
 final List<Assignment> assignments;
  const AssignmentsScreen({super.key, required this.assignments});
  
  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  widget.assignments;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  DateTime? _selectedDueDate;
  String _selectedPriority = 'Medium'; // Default to match your team's convention
  String? _editingAssignmentId;

  @override
  void initState() {
    super.initState();
    _loadAssignments();
  }

  /// Load assignments from storage
  /// TODO: Integrate with Member 5's Storage Service
  void _loadAssignments() async {
    // For now, load mock data that matches the dashboard
    final mockAssignments = [
      Assignment(
        id: '1',
        title: 'Mathematics Problem Set',
        dueDate: DateTime.now().add(const Duration(days: 3)),
        course: 'Calculus I',
        priority: 'High',
        isCompleted: false,
      ),
      Assignment(
        id: '2',
        title: 'Physics Lab Report',
        dueDate: DateTime.now().add(const Duration(days: 5)),
        course: 'Mechanics',
        priority: 'Medium',
        isCompleted: false,
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
        isCompleted: false,
      ),
    ];

    setState(() {
      assignments = mockAssignments..sort(_sortByDueDate);
    });
  }

  /// Sort assignments by due date (overdue first, then upcoming)
  int _sortByDueDate(Assignment a, Assignment b) {
    // Overdue assignments first
    if (a.isOverdue() && !b.isOverdue()) return -1;
    if (!a.isOverdue() && b.isOverdue()) return 1;
    
    // Then sort by due date
    return a.dueDate.compareTo(b.dueDate);
  }

  /// Show dialog to add/edit assignment
  Future<void> _showAssignmentDialog({Assignment? assignmentToEdit}) async {
    // If editing, populate form with existing data
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
        builder: (context, setState) {
          return AlertDialog(
            title: Text(
              assignmentToEdit != null ? 'Edit Assignment' : 'Add New Assignment',
              style: AppTextStyles.heading2,
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Assignment Title
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Assignment Title*',
                      labelStyle: AppTextStyles.bodyText,
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    style: AppTextStyles.bodyText,
                  ),
                  const SizedBox(height: 16),

                  // Course Name
                  TextField(
                    controller: _courseController,
                    decoration: InputDecoration(
                      labelText: 'Course Name*',
                      labelStyle: AppTextStyles.bodyText,
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    style: AppTextStyles.bodyText,
                  ),
                  const SizedBox(height: 16),

                  // Due Date Picker
                  GestureDetector(
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDueDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor: AppColors.primaryPurple,
                              colorScheme: const ColorScheme.light(
                                primary: AppColors.primaryPurple,
                              ),
                              buttonTheme: const ButtonThemeData(
                                textTheme: ButtonTextTheme.primary,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedDueDate = pickedDate;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedDueDate == null
                                ? 'Select Due Date*'
                                : DateFormat('MMM d, yyyy').format(_selectedDueDate!),
                            style: AppTextStyles.bodyText.copyWith(
                              color: _selectedDueDate == null 
                                  ? Colors.grey.shade500 
                                  : AppColors.midnightBlue,
                            ),
                          ),
                          Icon(
                            Icons.calendar_today,
                            color: AppColors.primaryPurple,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Priority Level
                  DropdownButtonFormField<String>(
                    value: _selectedPriority,
                    decoration: InputDecoration(
                      labelText: 'Priority Level',
                      labelStyle: AppTextStyles.bodyText,
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'High',
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppColors.warningRed,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text('High', style: AppTextStyles.bodyText),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Medium',
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppColors.aluOrange,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text('Medium', style: AppTextStyles.bodyText),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Low',
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppColors.successGreen,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text('Low', style: AppTextStyles.bodyText),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: '',
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text('No Priority', style: AppTextStyles.bodyText),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedPriority = value!;
                      });
                    },
                    style: AppTextStyles.bodyText,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _clearForm();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: AppTextStyles.bodyText.copyWith(
                    color: AppColors.midnightBlue,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _validateAndSaveAssignment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  assignmentToEdit != null ? 'Save Changes' : 'Add Assignment',
                  style: AppTextStyles.bodyText.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Validate form and save assignment
  void _validateAndSaveAssignment() {
    if (_titleController.text.isEmpty) {
      _showErrorSnackbar('Please enter an assignment title');
      return;
    }

    if (_courseController.text.isEmpty) {
      _showErrorSnackbar('Please enter a course name');
      return;
    }

    if (_selectedDueDate == null) {
      _showErrorSnackbar('Please select a due date');
      return;
    }

    final newAssignment = Assignment(
      id: _editingAssignmentId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      dueDate: _selectedDueDate!,
      course: _courseController.text.trim(),
      priority: _selectedPriority == 'Medium' ? '' : _selectedPriority,
      isCompleted: false,
    );

    if (_editingAssignmentId != null) {
      // Update existing assignment
      final index = assignments.indexWhere((a) => a.id == _editingAssignmentId);
      if (index != -1) {
        setState(() {
          assignments[index] = newAssignment;
          assignments.sort(_sortByDueDate);
        });
        _showSuccessSnackbar('Assignment updated successfully');
      }
    } else {
      // Add new assignment
      setState(() {
        assignments.add(newAssignment);
        assignments.sort(_sortByDueDate);
      });
      _showSuccessSnackbar('Assignment added successfully');
    }

    _clearForm();
    Navigator.of(context).pop();
  }

  /// Toggle assignment completion status
  void _toggleAssignmentCompletion(String assignmentId) {
    setState(() {
      final index = assignments.indexWhere((a) => a.id == assignmentId);
      if (index != -1) {
        assignments[index] = assignments[index].copyWith(
          isCompleted: !assignments[index].isCompleted,
        );
      }
    });
  }

  /// Delete assignment with confirmation
  void _deleteAssignment(String assignmentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Assignment', style: AppTextStyles.heading3),
        content: Text(
          'Are you sure you want to delete this assignment?',
          style: AppTextStyles.bodyText,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: AppTextStyles.bodyText),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                assignments.removeWhere((a) => a.id == assignmentId);
              });
              Navigator.of(context).pop();
              _showSuccessSnackbar('Assignment deleted');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warningRed,
            ),
            child: Text('Delete', style: AppTextStyles.bodyText.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// Clear form fields
  void _clearForm() {
    _titleController.clear();
    _courseController.clear();
    _selectedDueDate = null;
    _selectedPriority = 'Medium';
    _editingAssignmentId = null;
  }

  /// Show error snackbar
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.warningRed,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Show success snackbar
  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.successGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Get priority color
  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppColors.warningRed;
      case 'medium':
        return AppColors.aluOrange;
      case 'low':
        return AppColors.successGreen;
      default:
        return Colors.grey.shade400;
    }
  }

  /// Get days until due text
  String _getDaysUntilDueText(DateTime dueDate) {
    final daysUntilDue = dueDate.difference(DateTime.now()).inDays;
    
    if (daysUntilDue < 0) {
      return 'Overdue';
    } else if (daysUntilDue == 0) {
      return 'Today';
    } else if (daysUntilDue == 1) {
      return 'Tomorrow';
    } else {
      return '$daysUntilDue days';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filtering
            },
            tooltip: 'Filter assignments',
          ),
        ],
      ),
      body: assignments.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No assignments yet',
                    style: AppTextStyles.heading3.copyWith(
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add your first assignment',
                    style: AppTextStyles.caption,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: assignments.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final assignment = assignments[index];
                final isOverdue = assignment.isOverdue();
                final daysUntilDueText = _getDaysUntilDueText(assignment.dueDate);

                return Dismissible(
                  key: Key(assignment.id),
                  background: Container(
                    color: AppColors.warningRed,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white, size: 30),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      _deleteAssignment(assignment.id);
                      return false; // We handle deletion in the dialog
                    }
                    return false;
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: Checkbox(
                        value: assignment.isCompleted,
                        onChanged: (_) => _toggleAssignmentCompletion(assignment.id),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        activeColor: AppColors.successGreen,
                      ),
                      title: Text(
                        assignment.title,
                        style: AppTextStyles.heading3.copyWith(
                          decoration: assignment.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: assignment.isCompleted
                              ? Colors.grey.shade500
                              : AppColors.midnightBlue,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            assignment.course,
                            style: AppTextStyles.bodyText.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat('MMM d, yyyy').format(assignment.dueDate),
                                style: AppTextStyles.caption.copyWith(
                                  color: isOverdue && !assignment.isCompleted
                                      ? AppColors.warningRed
                                      : Colors.grey.shade600,
                                  fontWeight: isOverdue && !assignment.isCompleted
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (assignment.priority.isNotEmpty)
                            Chip(
                              label: Text(
                                assignment.priority,
                                style: AppTextStyles.caption.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              backgroundColor: _getPriorityColor(assignment.priority),
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                            ),
                          const SizedBox(height: 4),
                          Text(
                            daysUntilDueText,
                            style: AppTextStyles.caption.copyWith(
                              color: isOverdue && !assignment.isCompleted
                                  ? AppColors.warningRed
                                  : AppColors.midnightBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      onTap: () => _showAssignmentDialog(assignmentToEdit: assignment),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAssignmentDialog(),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_academic_assistant/utils/session_provider.dart';
import 'package:student_academic_assistant/models/session.dart';

class AddSessionScreen extends StatefulWidget {
  final Session? sessionToEdit;

  const AddSessionScreen({super.key, this.sessionToEdit});

  @override
  State<AddSessionScreen> createState() => _AddSessionScreenState();
}

class _AddSessionScreenState extends State<AddSessionScreen> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  SessionType _type = SessionType.classSession;

  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    if (widget.sessionToEdit != null) {
      _titleController.text = widget.sessionToEdit!.title;
      _locationController.text = widget.sessionToEdit!.location;
      _type = widget.sessionToEdit!.sessionType;
      _selectedDate = widget.sessionToEdit!.date;
      final startParts = widget.sessionToEdit!.startTime.split(':');
      final endParts = widget.sessionToEdit!.endTime.split(':');
      _startTime = TimeOfDay(
        hour: int.parse(startParts[0]),
        minute: int.parse(startParts[1]),
      );
      _endTime = TimeOfDay(
        hour: int.parse(endParts[0]),
        minute: int.parse(endParts[1]),
      );
    }
  }

  String _timeToString(TimeOfDay t) {
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? const TimeOfDay(hour: 10, minute: 0),
    );
    if (picked != null) setState(() => _startTime = picked);
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? const TimeOfDay(hour: 12, minute: 0),
    );
    if (picked != null) setState(() => _endTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.sessionToEdit != null ? 'Edit Session' : 'Add Session',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Session Title'),
            ),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Session Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  _selectedDate == null
                      ? 'Select date'
                      : '${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year}',
                ),
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _pickStartTime,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Start Time',
                      ),
                      child: Text(
                        _startTime == null
                            ? 'Select time'
                            : _timeToString(_startTime!),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: _pickEndTime,
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'End Time'),
                      child: Text(
                        _endTime == null
                            ? 'Select time'
                            : _timeToString(_endTime!),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            DropdownButton<SessionType>(
              value: _type,
              items: SessionType.values.map((type) {
                final session = Session(
                  id: '',
                  title: '',
                  sessionType: type,
                  date: DateTime.now(),
                  startTime: '',
                  endTime: '',
                  location: '',
                );
                return DropdownMenuItem(
                  value: type,
                  child: Text(session.typeLabel),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _type = value!;
                });
              },
            ),

            const Spacer(),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a session title.'),
                    ),
                  );
                  return;
                }

                if (_startTime != null && _endTime != null) {
                  final startMinutes =
                      _startTime!.hour * 60 + _startTime!.minute;
                  final endMinutes = _endTime!.hour * 60 + _endTime!.minute;
                  if (endMinutes <= startMinutes) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('End time must be after start time'),
                      ),
                    );
                    return;
                  }
                }

                final startStr = _startTime != null
                    ? _timeToString(_startTime!)
                    : '10:00';
                final endStr = _endTime != null
                    ? _timeToString(_endTime!)
                    : '12:00';

                final sessionProvider = Provider.of<SessionProvider>(
                  context,
                  listen: false,
                );

                if (widget.sessionToEdit != null) {
                  sessionProvider.updateSession(
                    widget.sessionToEdit!.id,
                    Session(
                      id: widget.sessionToEdit!.id,
                      title: _titleController.text,
                      date: _selectedDate ?? widget.sessionToEdit!.date,
                      startTime: startStr,
                      endTime: endStr,
                      location: _locationController.text,
                      sessionType: _type,
                      isPresent: widget.sessionToEdit!.isPresent,
                    ),
                  );
                } else {
                  sessionProvider.addSession(
                    Session(
                      id: DateTime.now().toString(),
                      title: _titleController.text,
                      date: _selectedDate ?? DateTime.now(),
                      startTime: startStr,
                      endTime: endStr,
                      location: _locationController.text,
                      sessionType: _type,
                    ),
                  );
                }

                Navigator.pop(context);
              },
              child: const Text('Save Session'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}

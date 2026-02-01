import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_academic_assistant/utils/session_provider.dart';
import 'package:student_academic_assistant/models/session.dart';
import 'package:student_academic_assistant/utils/constants.dart';

class AddSessionScreen extends StatefulWidget {
  const AddSessionScreen({super.key});

  @override
  State<AddSessionScreen> createState() => _AddSessionScreenState();
}

class _AddSessionScreenState extends State<AddSessionScreen> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  SessionType _type = SessionType.classSession;

  // Time picker state
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  String _timeToString(TimeOfDay t) {
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
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
      appBar: AppBar(title: const Text('Add Session')),
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

            // Start/End time pickers
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _pickStartTime,
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'Start Time'),
                      child: Text(_startTime == null
                          ? 'Select time'
                          : _timeToString(_startTime!)),
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
                          _endTime == null ? 'Select time' : _timeToString(_endTime!)),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            DropdownButton<SessionType>(
              value: _type,
              items: SessionType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.name),
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
                if (_titleController.text.isEmpty) return;

                // Validate times when both are chosen
                if (_startTime != null && _endTime != null) {
                  final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
                  final endMinutes = _endTime!.hour * 60 + _endTime!.minute;
                  if (endMinutes <= startMinutes) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('End time must be after start time')),
                    );
                    return;
                  }
                }

                final startStr = _startTime != null ? _timeToString(_startTime!) : '10:00';
                final endStr = _endTime != null ? _timeToString(_endTime!) : '12:00';

                Provider.of<SessionProvider>(context, listen: false).addSession(
                  Session(
                    id: DateTime.now().toString(),
                    title: _titleController.text,
                    date: DateTime.now(),
                    startTime: startStr,
                    endTime: endStr,
                    location: _locationController.text,
                    sessionType: _type,
                  ),
                );

                Navigator.pop(context);
              },
              child: const Text('Save Session'),
            ),
          ],
        ),
      ),
    );
  }
}

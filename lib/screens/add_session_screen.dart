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

                Provider.of<SessionProvider>(context, listen: false)
                    .addSession(
                  Session(
                    id: DateTime.now().toString(),
                    title: _titleController.text,
                    date: DateTime.now(),
                    startTime: '10:00',
                    endTime: '12:00',
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

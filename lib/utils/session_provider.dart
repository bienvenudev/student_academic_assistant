import 'package:flutter/material.dart';
import '../models/session.dart';

class SessionProvider with ChangeNotifier {
  final List<Session> _sessions = [];

  List<Session> get sessions => _sessions;

  void addSession(Session session) {
    _sessions.add(session);
    notifyListeners();
  }

  void removeSession(String id) {
    _sessions.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  void markAttendance(String id, bool present) {
    final session = _sessions.firstWhere((s) => s.id == id);
    session.isPresent = present;
    notifyListeners();
  }

  double get attendancePercentage {
    final attended = _sessions.where((s) => s.isPresent != null).toList();

    if (attended.isEmpty) return 100;

    final presentCount =
        attended.where((s) => s.isPresent == true).length;

    return (presentCount / attended.length) * 100;
  }
}

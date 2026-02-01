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
    // Returns the percentage of sessions with recorded attendance that
    // are marked as present. If no sessions have attendance recorded yet,
    // return 0 to indicate that attendance has not been tracked (returning
    // 100 in that case would misleadingly imply perfect attendance).
    final attended = _sessions.where((s) => s.isPresent != null).toList();

    if (attended.isEmpty) return 0;

    final presentCount = attended.where((s) => s.isPresent == true).length;

    return (presentCount / attended.length) * 100;
  }
}

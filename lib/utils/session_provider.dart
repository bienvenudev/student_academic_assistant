import 'package:flutter/material.dart';
import '../models/session.dart';
import '../services/storage_service.dart';

class SessionProvider with ChangeNotifier {
  List<Session> _sessions = [];
  bool _isLoaded = false;

  List<Session> get sessions => _sessions;

  Future<void> loadSessions() async {
    if (_isLoaded) return;
    _sessions = await StorageService().loadSessions();
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> addSession(Session session) async {
    _sessions.add(session);
    await StorageService().saveSessions(_sessions);
    notifyListeners();
  }

  Future<void> removeSession(String id) async {
    _sessions.removeWhere((s) => s.id == id);
    await StorageService().saveSessions(_sessions);
    notifyListeners();
  }

  Future<void> updateSession(String id, Session updatedSession) async {
    final index = _sessions.indexWhere((s) => s.id == id);
    if (index != -1) {
      _sessions[index] = updatedSession;
      await StorageService().saveSessions(_sessions);
      notifyListeners();
    }
  }

  Future<void> markAttendance(String id, bool present) async {
    final index = _sessions.indexWhere((s) => s.id == id);
    if (index != -1) {
      _sessions[index] = _sessions[index].copyWith(isPresent: present);
      await StorageService().saveSessions(_sessions);
      notifyListeners();
    }
  }

  double get attendancePercentage {
    final attended = _sessions.where((s) => s.isPresent != null).toList();

    if (attended.isEmpty) return 0;

    final presentCount = attended.where((s) => s.isPresent == true).length;

    return (presentCount / attended.length) * 100;
  }
}

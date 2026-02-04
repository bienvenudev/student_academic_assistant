import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/assignment.dart';
import '../models/session.dart';

class StorageService {
  // Singleton
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late SharedPreferences _prefs;
  bool _initialized = false;

  // Keys
  static const String _kAssignmentsKey = 'assignments';
  static const String _kSessionsKey = 'sessions';

  /// Must be called once before using any load/save methods
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
  }

  void _ensureInit() {
    if (!_initialized) {
      throw StateError(
        'StorageService not initialized. Call await StorageService().init() in main() before runApp().',
      );
    }
  }

  // -------------------------
  // Assignments: Save & Load
  // -------------------------

  Future<void> saveAssignments(List<Assignment> assignments) async {
    _ensureInit();
    final jsonList = assignments.map((a) => a.toJson()).toList();
    await _prefs.setString(_kAssignmentsKey, jsonEncode(jsonList));
  }

  List<Assignment> loadAssignments() {
    _ensureInit();
    final jsonString = _prefs.getString(_kAssignmentsKey);
    if (jsonString == null || jsonString.isEmpty) return [];

    final decoded = jsonDecode(jsonString);
    if (decoded is! List) return [];

    return decoded
        .map((item) => Assignment.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // -------------------------
  // Sessions: Save & Load
  // -------------------------

  Future<void> saveSessions(List<Session> sessions) async {
    _ensureInit();
    final jsonList = sessions.map((s) => s.toJson()).toList();
    await _prefs.setString(_kSessionsKey, jsonEncode(jsonList));
  }

  List<Session> loadSessions() {
    _ensureInit();
    final jsonString = _prefs.getString(_kSessionsKey);
    if (jsonString == null || jsonString.isEmpty) return [];

    final decoded = jsonDecode(jsonString);
    if (decoded is! List) return [];

    return decoded
        .map((item) => Session.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // -------------------------
  // CRUD helpers (optional but useful)
  // These update lists + persist.
  // -------------------------

  // ASSIGNMENTS CRUD
  Future<List<Assignment>> addAssignment(
    List<Assignment> current,
    Assignment newAssignment,
  ) async {
    final updated = [...current, newAssignment];
    await saveAssignments(updated);
    return updated;
  }

  Future<List<Assignment>> updateAssignment(
    List<Assignment> current,
    bool Function(Assignment a) match,
    Assignment Function(Assignment old) update,
  ) async {
    final updatedList = current.map((a) => match(a) ? update(a) : a).toList();
    await saveAssignments(updatedList);
    return updatedList;
  }

  Future<List<Assignment>> deleteAssignment(
    List<Assignment> current,
    bool Function(Assignment a) match,
  ) async {
    final updated = current.where((a) => !match(a)).toList();
    await saveAssignments(updated);
    return updated;
  }

  // SESSIONS CRUD
  Future<List<Session>> addSession(
    List<Session> current,
    Session newSession,
  ) async {
    final updated = [...current, newSession];
    await saveSessions(updated);
    return updated;
  }

  Future<List<Session>> updateSession(
    List<Session> current,
    bool Function(Session s) match,
    Session Function(Session old) update,
  ) async {
    final updatedList = current.map((s) => match(s) ? update(s) : s).toList();
    await saveSessions(updatedList);
    return updatedList;
  }

  Future<List<Session>> deleteSession(
    List<Session> current,
    bool Function(Session s) match,
  ) async {
    final updated = current.where((s) => !match(s)).toList();
    await saveSessions(updated);
    return updated;
  }

  // -------------------------
  // Utilities (optional)
  // -------------------------

  Future<void> clearAll() async {
    _ensureInit();
    await _prefs.remove(_kAssignmentsKey);
    await _prefs.remove(_kSessionsKey);
  }
}

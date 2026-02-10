# ALU Student Academic Assistant

A Flutter mobile application designed to help African Leadership University students manage their academic responsibilities efficiently.

**Demo Video:** https://youtu.be/NnDE_Hq2N2I  
**GitHub Repository:** https://github.com/bienvenudev/student_academic_assistant  
**Contribution Tracker Link:** https://docs.google.com/spreadsheets/d/1T5x2_VeGJgzMHKJ5Kfq-1x758chus25AbTR5PAcWP_A/edit?gid=0#gid=0    
**Team Contributions:** https://github.com/bienvenudev/student_academic_assistant/graphs/contributors

---

## Features

### Core Functionality
- **Dashboard Overview**
  - Current date and academic week calculation
  - Real-time attendance percentage with <75% warning
  - Pending and overdue assignment counters
  - Today's sessions and upcoming assignments (7-day window)

- **Assignment Management**
  - Full CRUD operations (Create, Read, Update, Delete)
  - Priority levels (High, Medium, Low) with color coding
  - Due date tracking with overdue indicators
  - Completion status with visual feedback
  - Smart sorting (incomplete → overdue → by date)

- **Schedule & Attendance**
  - Session management with date, time, location, and type
  - Session types: Class, Mastery Session, Study Group, PSL Meeting
  - Quick attendance marking (Present/Absent)
  - Real-time attendance percentage calculation
  - Color-coded status indicators

- **Data Persistence**  BONUS
  - All data persists across app restarts
  - Local storage using SharedPreferences
  - Automatic save on all operations

---

## Architecture

### Project Structure
```
lib/
├── models/          # Data structures
│   ├── assignment.dart
│   └── session.dart
├── screens/         # UI screens
│   ├── dashboard_screen.dart
│   ├── assignments_screen.dart
│   ├── add_assignment_screen.dart
│   ├── schedule_screen.dart
│   └── add_session_screen.dart
├── services/        # Business logic
│   └── storage_service.dart
├── utils/           # Shared resources
│   ├── constants.dart
│   └── session_provider.dart
└── main.dart        # App entry point
```

### Design Patterns
- **Singleton Pattern**: StorageService ensures single instance for data management
- **Provider Pattern**: SessionProvider for reactive state management
- **Immutability**: All models use `copyWith` for state changes
- **Separation of Concerns**: Clear folder structure separating data, UI, and logic

### State Management
- **Provider**: Used for session data with ChangeNotifier
- **Callback Pattern**: Used for assignment data updates
- **IndexedStack**: Preserves screen state during tab navigation

---

## Design System

### Color Scheme (ALU Official Branding)
- **Primary Navy**: `#0B1B3E`
- **Navy Dark**: `#07152F`
- **Accent Yellow**: `#F2C94C`
- **Warning Red**: `#EB5757`
- **Success Green**: `#4CAF50`

### UI Components
- Material Design components
- Consistent card elevation and border radius
- Custom text styles for hierarchy
- Responsive layouts with proper spacing

---

## Setup Instructions

### Prerequisites
- Flutter SDK 3.10.4 or higher
- Dart 3.0.0 or higher
- Android Studio / VS Code
- Device/Emulator running Android 5.0+ or iOS 12.0+

### Installation
```bash
# Clone repository
git clone https://github.com/benitha200/student_academic_assistant.git
cd student_academic_assistant

# Install dependencies
flutter pub get

# Run app
flutter run
```

### Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2
  shared_preferences: ^2.2.2
  intl: ^0.19.0
```

---

## Team Contributions

### Team Members
1. **Bienvenu Cyuzuzo** - Navigation architecture, Dashboard implementation, Main app structure
2. **Celine Shoga** - Assignments feature (list view, CRUD operations)
3. **Victor Akin Oladiran** - Schedule & attendance tracking, Session management
4. **Dushimimana Christopher** - Form refactoring (AddAssignmentScreen), Code organization
5. **Evander Manna** - Data persistence layer, StorageService, SessionProvider integration

*Detailed contribution history available at: https://github.com/bienvenudev/student_academic_assistant/graphs/contributors*

---

## Key Implementation Details

### Academic Week Calculation
Calculates current week number from term start date (January 5, 2026):
```dart
int _calculateAcademicWeek(DateTime currentDate) {
  final difference = currentDate.difference(termStartDate).inDays;
  return (difference / 7).floor() + 1;
}
```

### Attendance Warning Logic
Returns 100% when no sessions exist to avoid misleading warnings for new users:
```dart
double _calculateAttendancePercentage(List<Session> sessions) {
  if (sessions.isEmpty) {
    return 100.0; // Starting at 100% avoids confusing warnings
  }
  
  final recordedSessions = sessions
      .where((s) => s.hasAttendanceRecorded())
      .toList();
  
  if (recordedSessions.isEmpty) {
    return 100.0; // Don't penalize for unrecorded attendance
  }
  
  final presentCount = recordedSessions
      .where((s) => s.isPresent == true)
      .length;
  return (presentCount / recordedSessions.length) * 100;
}
```

### Data Serialization
All models include `toJson()` and `fromJson()` for persistence with safe error handling:
```dart
List<Assignment> loadAssignments() {
  _ensureInit();
  final jsonString = _prefs.getString(_kAssignmentsKey);
  if (jsonString == null || jsonString.isEmpty) return [];

  try {
    final decoded = jsonDecode(jsonString);
    if (decoded is! List) return [];

    return decoded
        .where((item) => item is Map<String, dynamic>)
        .map<Assignment?>((item) {
          try {
            return Assignment.fromJson(item as Map<String, dynamic>);
          } catch (e) {
            return null; // Skip corrupted data
          }
        })
        .whereType<Assignment>()
        .toList();
  } catch (e) {
    return [];
  }
}
```

---

## Testing

Manual testing performed on:
- ✅ Android emulator (API 33)
- ✅ Web browser (Chrome)
- ✅ Data persistence across restarts
- ✅ All CRUD operations
- ✅ Navigation and state preservation
- ✅ Edge cases (empty states, overdue dates, etc.)

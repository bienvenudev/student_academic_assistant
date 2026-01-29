# Student Academic Assistant - Development Guide

## Project Overview
Mobile app for ALU students to manage assignments, track schedules, and monitor attendance.

## Getting Started

### Setup Instructions
1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd student_academic_assistant
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Create your feature branch**
   ```bash
   git checkout -b feat/<your-branch>
   ```
   Example: `git checkout -b feat/assignments-list`

4. **Run the app**
   ```bash
   flutter run -d chrome
   ```

## Project Structure

```
lib/
├── models/           # Data models (Assignment, Session)
├── screens/          # UI screens for each tab
├── services/         # Data storage and business logic
├── widgets/          # Reusable custom widgets
├── utils/            # Constants, helpers, utilities
└── main.dart         # App entry point & navigation
```

## Team Member Responsibilities

### Member 1: Team Lead (Navigation & Dashboard) ✅ DONE
**Files owned:**
- `lib/main.dart` - Navigation shell
- `lib/screens/dashboard_screen.dart` - Home dashboard
- `lib/utils/constants.dart` - Colors and constants

**Status:** Complete and committed to main branch.

---

### Member 2: Lists Specialist (Assignments Feature)
**Files to create/modify:**
- `lib/screens/assignments_screen.dart` - Replace placeholder with real implementation
- `lib/screens/add_assignment_screen.dart` - Form for adding/editing assignments
- `lib/widgets/assignment_tile.dart` - Custom widget for assignment cards

**Your Tasks:**
1. **Display assignments list:**
   - Use `ListView.builder` to show all assignments
   - Sort by due date (earliest first)
   - Show: title, course, due date, priority badge

2. **Implement interactions:**
   - Checkbox to mark assignment as completed
   - Swipe-to-delete or delete icon button
   - Tap to navigate to edit screen

3. **Add FloatingActionButton:**
   - Button with `+` icon
   - Navigates to Add Assignment screen (Member 4 will create this, coordinate with them)

**Key Code Pattern:**
```dart
import 'package:student_academic_assistant/models/assignment.dart';

class AssignmentsScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    // Get assignments list from storage (Member 5 will provide this)
    final assignments = []; // TODO: Get from storage service
    
    return Scaffold(
      appBar: AppBar(title: Text('Assignments')),
      body: ListView.builder(
        itemCount: assignments.length,
        itemBuilder: (context, index) {
          return AssignmentTile(assignment: assignments[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add assignment screen
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
```

**Color Usage:**
- Use `AppColors.primaryPurple` for assignment icons
- Use `AppColors.aluOrange` for overdue assignments
- Use `AppColors.successGreen` for completed assignments

---

### Member 3: Schedule Specialist (Calendar & Attendance Feature)
**Files to create/modify:**
- `lib/screens/schedule_screen.dart` - Replace placeholder with real implementation
- `lib/screens/add_session_screen.dart` - Form for adding/editing sessions
- `lib/widgets/session_tile.dart` - Custom widget for session cards

**Your Tasks:**
1. **Display weekly schedule:**
   - Show sessions grouped by day or in a list
   - Display: title, time range, location, session type
   - Filter to show today's sessions at the top

2. **Implement attendance toggle:**
   - Add Present/Absent button for each session
   - Use a `Switch` or `ToggleButtons` widget
   - Update `Session.isPresent` field when toggled

3. **Add FloatingActionButton:**
   - Button with `+` icon
   - Navigates to Add Session screen (Member 4 will create this)

**Key Code Pattern:**
```dart
import 'package:student_academic_assistant/models/session.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    // Get sessions from storage
    final sessions = []; // TODO: Get from storage service
    
    return Scaffold(
      appBar: AppBar(title: Text('Schedule')),
      body: ListView.builder(
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          return SessionTile(
            session: sessions[index],
            onAttendanceToggle: (bool isPresent) {
              // Update attendance (coordinate with Member 5)
            },
          );
        },
      ),
    );
  }
}
```

**Color Usage:**
- Use `AppColors.fuchsiaPink` for session icons
- Use `AppColors.midnightBlue` for session type chips
- Use `AppColors.successGreen` for Present status
- Use `AppColors.aluRed` for Absent status

**Helper Methods Available:**
- `session.isToday()` - Check if session is today
- `session.isPast()` - Check if session already happened
- `session.hasAttendanceRecorded()` - Check if attendance is recorded

---

### Member 4: Forms Specialist (Input Handling)
**Files to create:**
- `lib/screens/add_assignment_screen.dart` - Form for creating assignments
- `lib/screens/edit_assignment_screen.dart` - Form for editing assignments
- `lib/screens/add_session_screen.dart` - Form for creating sessions
- `lib/screens/edit_session_screen.dart` - Form for editing sessions

**Your Tasks:**
1. **Create Assignment Form:**
   - Text field for title (required)
   - Date picker for due date (required)
   - Text field for course name (required)
   - Dropdown for priority: High, Medium, Low (optional)
   - Save and Cancel buttons

2. **Create Session Form:**
   - Text field for title (required)
   - Date picker for date (required)
   - Time picker for start time (required)
   - Time picker for end time (required)
   - Text field for location (optional)
   - Dropdown for session type: Class, Mastery Session, Study Group, PSL Meeting (required)

3. **Implement validation:**
   - Prevent empty required fields
   - Ensure end time is after start time
   - Show error messages for invalid input

**Key Code Pattern:**
```dart
class AddAssignmentScreen extends StatefulWidget {
  @override
  _AddAssignmentScreenState createState() => _AddAssignmentScreenState();
}

class _AddAssignmentScreenState extends State<AddAssignmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _courseController = TextEditingController();
  DateTime? _selectedDate;
  String _priority = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Assignment')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title *'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            // More fields...
            ElevatedButton(
              onPressed: _saveAssignment,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveAssignment() {
    if (_formKey.currentState!.validate()) {
      final newAssignment = Assignment(
        id: DateTime.now().toString(),
        title: _titleController.text,
        dueDate: _selectedDate!,
        course: _courseController.text,
        priority: _priority,
      );
      // Save to storage (Member 5 will provide method)
      Navigator.pop(context);
    }
  }
}
```

**Constants Available:**
- `sessionTypes` list - for dropdown options
- `priorityLevels` list - for dropdown options

**Pickers:**
```dart
// Date Picker
final date = await showDatePicker(
  context: context,
  initialDate: DateTime.now(),
  firstDate: DateTime.now(),
  lastDate: DateTime.now().add(Duration(days: 365)),
);

// Time Picker
final time = await showTimePicker(
  context: context,
  initialTime: TimeOfDay.now(),
);
```

---

### Member 5: Data & Models Specialist (Storage & State)
**Files to create:**
- `lib/services/storage_service.dart` - Data persistence using shared_preferences

**Your Tasks:**
1. **Implement Storage Service:**
   - Save assignments list to `shared_preferences`
   - Save sessions list to `shared_preferences`
   - Load data when app starts
   - Provide methods for CRUD operations

2. **Create singleton service class:**
   ```dart
   class StorageService {
     static final StorageService _instance = StorageService._internal();
     factory StorageService() => _instance;
     StorageService._internal();

     late SharedPreferences _prefs;

     Future<void> init() async {
       _prefs = await SharedPreferences.getInstance();
     }

     // Assignments
     Future<void> saveAssignments(List<Assignment> assignments) async {
       final jsonList = assignments.map((a) => a.toJson()).toList();
       await _prefs.setString('assignments', jsonEncode(jsonList));
     }

     List<Assignment> loadAssignments() {
       final jsonString = _prefs.getString('assignments');
       if (jsonString == null) return [];
       final jsonList = jsonDecode(jsonString) as List;
       return jsonList.map((json) => Assignment.fromJson(json)).toList();
     }

     // Similar methods for Sessions
   }
   ```

3. **Initialize in main.dart:**
   - Coordinate with Team Lead to add initialization code in `main()` function
   - Load data before app starts

**Data Models Available:**
- `Assignment` class in `lib/models/assignment.dart`
  - Has `toJson()` and `fromJson()` methods
- `Session` class in `lib/models/session.dart`
  - Has `toJson()` and `fromJson()` methods

**Package to use:**
- `shared_preferences: ^2.2.2` (already added to pubspec.yaml)

---

## Coding Standards

### 1. Colors
**ALWAYS use constants from `AppColors` - never hardcode colors:**
```dart
// ✅ CORRECT
Container(color: AppColors.primaryPurple)

// ❌ WRONG
Container(color: Color(0xFF841E6A))
```

**Available Colors:**
- `AppColors.primaryPurple` - #841E6A (main brand color)
- `AppColors.midnightBlue` - #002E6C (dark blue)
- `AppColors.fuchsiaPink` - #C751C0 (accent pink)
- `AppColors.aluOrange` - #D66415 (warnings, due dates)
- `AppColors.aluRed` - #D00D2D (official ALU red, alerts)
- `AppColors.backgroundLight` - #F4F6F8 (light grey background)
- `AppColors.successGreen` - #4CAF50 (success states)
- `AppColors.warningRed` - #E53935 (error states)

### 2. Text Styles
Use predefined text styles from `AppTextStyles`:
- `AppTextStyles.heading1` - Large headings
- `AppTextStyles.heading2` - Medium headings
- `AppTextStyles.heading3` - Small headings
- `AppTextStyles.bodyText` - Regular text
- `AppTextStyles.caption` - Small text

### 3. File Naming
- Use snake_case: `add_assignment_screen.dart`
- Be descriptive: `assignment_tile.dart` not `tile.dart`

### 4. Widget Naming
- Use PascalCase: `AssignmentTile`, `DashboardScreen`
- End with widget type: `Screen`, `Tile`, `Card`, `Button`

### 5. Comments
- Add comments for complex logic
- Explain WHY not WHAT
- Document public methods

### 6. Code Organization
- Keep widgets under 300 lines - extract smaller widgets
- One widget per file (except very small private widgets)
- Group related methods together

## Git Workflow

### Making Changes
1. **Always work on your feature branch:**
   ```bash
   git checkout feat/<your-branch>
   ```

2. **Commit frequently with clear messages:**
   ```bash
   git add .
   git commit -m "feat: implement assignment list view"
   ```

3. **Pull latest changes before pushing:**
   ```bash
   git checkout main
   git pull
   git checkout feat/<your-branch>
   git merge main
   ```

4. **Push your branch:**
   ```bash
   git push origin feat/<your-branch>
   ```

### Commit Message Format
- `feat: add assignment list screen`
- `fix: resolve date picker crash`
- `style: apply ALU colors to dashboard`
- `docs: update README with setup instructions`

## Testing Your Code

### Before Committing
1. **Run the app** - Make sure it compiles
   ```bash
   flutter run -d linux
   ```

2. **Check for errors** - No red underlines in VS Code

3. **Test functionality** - Click buttons, fill forms, etc.

4. **Test on multiple screen sizes** - Resize the window

### Device Testing
- Run on Linux: `flutter run -d linux`
- Run on Chrome: `flutter run -d chrome`
- Run on Android emulator: `flutter run -d emulator-5554`

## Common Issues & Solutions

### Issue: Import errors
**Solution:** Make sure you're using the correct import path:
```dart
import 'package:student_academic_assistant/models/assignment.dart';
// NOT: import 'models/assignment.dart';
```

### Issue: Colors not working
**Solution:** Import constants file:
```dart
import 'package:student_academic_assistant/utils/constants.dart';
```

### Issue: Can't access data from other members
**Solution:** Coordinate with Member 5 (Data Specialist) to:
1. Define the interface/methods you need
2. Use placeholder data until their storage service is ready
3. Test with mock data first

### Issue: Merge conflicts
**Solution:**
1. Pull latest main branch
2. Merge main into your branch
3. Resolve conflicts in VS Code
4. Test that app still runs
5. Commit and push

## Communication

### Before Starting
- Read this guide completely
- Check what files you need to create
- Ask questions in the group chat if unclear

### While Working
- Commit at least daily so team can see progress
- Share screenshots in group chat
- Coordinate with members whose work depends on yours:
  - Member 2 & 4: Assignment form navigation
  - Member 3 & 4: Session form navigation
  - Everyone & Member 5: Data storage methods

### Before Demo
- Test the complete flow of your feature
- Prepare to explain your code line-by-line
- Understand every import and method you used

## Resources

### Flutter Documentation
- [Flutter Widget Catalog](https://docs.flutter.dev/ui/widgets)
- [Material Design Components](https://docs.flutter.dev/ui/widgets/material)
- [Form Validation](https://docs.flutter.dev/cookbook/forms/validation)

### Helpful Widgets
- `ListView.builder` - For scrollable lists
- `Card` - For content containers
- `ListTile` - For list items
- `Form` & `TextFormField` - For input forms
- `showDatePicker` - Date selection
- `showTimePicker` - Time selection

## Academic Week Calculation

The app calculates academic weeks based on `termStartDate` in `constants.dart`.

**Current setting:** 4 weeks ago (allows adding past sessions/assignments)

With this:
- We can record attendance for past weeks
- We can add assignments from the beginning of term
- Dashboard shows "Academic Week X" (current week)

## Questions?

If stuck, ask in group chat with:
1. What you're trying to do
2. What error/issue you're seeing
3. What you've already tried

Good luck!

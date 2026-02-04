import 'package:flutter/material.dart';
import 'package:student_academic_assistant/screens/dashboard_screen.dart';
import 'package:student_academic_assistant/screens/assignments_screen.dart';
import 'package:student_academic_assistant/models/assignment.dart';
import 'package:student_academic_assistant/utils/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALU Academic Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryPurple,
        scaffoldBackgroundColor: AppColors.backgroundLight,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryPurple,
          foregroundColor: AppColors.textLight,
          elevation: 0,
          centerTitle: true,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.primaryPurple,
          secondary: AppColors.fuchsiaPink,
          error: AppColors.aluOrange,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.midnightBlue,
          selectedItemColor: AppColors.fuchsiaPink,
          unselectedItemColor: Colors.white70,
          type: BottomNavigationBarType.fixed,
        ),
        cardTheme: const CardTheme(
          color: AppColors.cardWhite,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.fuchsiaPink,
          foregroundColor: AppColors.textLight,
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final List<Assignment> assignments = [];

  // Callback to rebuild the dashboard when assignments change
  void _refreshDashboard() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Build screens here to pass the updated callback every time
    final List<Widget> screens = [
      DashboardScreen(assignments: assignments),
      AssignmentsScreen(
        assignments: assignments,
        onAssignmentsChanged: _refreshDashboard,
      ),
      const PlaceholderScreen(title: 'Schedule'),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Assignments'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Schedule'),
        ],
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 64, color: AppColors.primaryPurple.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text('$title Screen', style: AppTextStyles.heading2),
            const SizedBox(height: 8),
            Text('This screen will be implemented later', style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}

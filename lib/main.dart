import 'package:flutter/material.dart';
import 'package:student_academic_assistant/screens/dashboard_screen.dart';
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
          error: AppColors.aluOrange, // For warnings (attendance < 75%)
        ),

        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.midnightBlue,
          selectedItemColor: AppColors.fuchsiaPink,
          unselectedItemColor: Colors.white70,
          type: BottomNavigationBarType.fixed,
        ),

        cardTheme: const CardThemeData(
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

/// Main navigation screen with BottomNavigationBar
/// Controls switching between Dashboard, Assignments, and Schedule tabs
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // Screens for each tab
  // TODO: Replace placeholder screens when teammates implement them
  final List<Widget> _screens = [
    const DashboardScreen(),
    const PlaceholderScreen(title: 'Assignments'),
    const PlaceholderScreen(title: 'Schedule'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Assignments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Schedule',
          ),
        ],
      ),
    );
  }
}

/// Temporary placeholder screen for tabs not yet implemented by teammates
/// This will be replaced with AssignmentsScreen
/// This will be replaced with ScheduleScreen
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
            Icon(
              Icons.construction,
              size: 64,
              color: AppColors.primaryPurple.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text('$title Screen', style: AppTextStyles.heading2),
            const SizedBox(height: 8),
            Text(
              'This screen will be implemented later',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// ALU Official Brand Colors

class AppColors {
  // colors
  static const Color navy = Color(0xFF0B1B3E);
  static const Color navyDark = Color(0xFF07152F);
  static const Color yellow = Color(0xFFF2C94C);
  static const Color red = Color(0xFFEB5757);
  static const Color white = Colors.white;
  static const Color mutedWhite = Color(0xFFD8DCE6);
  static const Color black = Colors.black;

  // Aliases
  static const Color primaryNavy = navy;
  static const Color accentYellow = yellow;
  static const Color warningRed = red;
  static const Color statusGreen = Color(0xFF4CAF50);
  static const Color statusYellow = yellow;
  static const Color statusRed = red;
  static const Color cardBackground = white;
  static const Color scaffoldBackground = navy;
}

/// App-wide text styles
class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.navy,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.navy,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.navy,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 14,
    color: AppColors.black,
  );

  static const TextStyle caption = TextStyle(fontSize: 12, color: Colors.grey);
}

/// Session type options for dropdown
const List<String> sessionTypes = [
  'Class',
  'Mastery Session',
  'Study Group',
  'PSL Meeting',
];

/// Priority level options for dropdown
const List<String> priorityLevels = ['High', 'Medium', 'Low'];

/// Academic week calculation
final DateTime termStartDate = DateTime(2026, 1, 5);

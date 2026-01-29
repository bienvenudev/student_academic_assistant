import 'package:flutter/material.dart';

/// ALU Official Brand Colors
class AppColors {
  // Primary Brand Colors
  static const Color primaryPurple = Color(0xFF841E6A);
  static const Color midnightBlue = Color(0xFF002E6C);

  // Secondary/Accent Colors
  static const Color fuchsiaPink = Color(0xFFC751C0);
  static const Color aluOrange = Color(0xFFD66415);

  // Neutral Colors for UI
  static const Color backgroundLight = Color(
    0xFFF4F6F8,
  ); // Light grey for dashboard background
  static const Color textDark = Color(0xFF1D1D1D);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color cardWhite = Color(0xFFFFFFFF);

  // Status Colors
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningRed = Color(0xFFE53935);
}

/// App-wide text styles
class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.midnightBlue,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.midnightBlue,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.midnightBlue,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 14,
    color: AppColors.textDark,
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

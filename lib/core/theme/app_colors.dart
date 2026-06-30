import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // =========================
  // Brand Colors
  // =========================

  static const Color primary = Color(0xFF5B2BE0);
  static const Color primaryDark = Color(0xFF34126D);
  static const Color accent = Color(0xFFF8A928);

  // =========================
  // Status Colors
  // =========================

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFE74C3C);
  static const Color info = Color(0xFF3B82F6);

  // =========================
  // Background
  // =========================

  static const Color background = Color(0xFFF8F9FC);
  static const Color scaffold = Color(0xFFF8F9FC);
  static const Color surface = Colors.white;

  // =========================
  // Text
  // =========================

  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textWhite = Colors.white;

  // =========================
  // Border
  // =========================

  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF1F5F9);

  // =========================
  // Queue Status
  // =========================

  static const Color open = Color(0xFF22C55E);
  static const Color breakTime = Color(0xFFF59E0B);
  static const Color closed = Color(0xFFEF4444);

  // =========================
  // Card
  // =========================

  static const Color card = Colors.white;

  // =========================
  // Gradient
  // =========================

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF5B2BE0), Color(0xFF7C4DFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFF8A928), Color(0xFFFFC857)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

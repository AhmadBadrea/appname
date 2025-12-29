// lib/core/theme/app_colors.dart

import 'package:flutter/material.dart';

/// يحتوي على كتالوج الألوان الكامل للتطبيق، مقسمًا حسب الوضع.
class AppColors {
  // يمنع إنشاء كائن من هذا الكلاس.
  AppColors._();

  // ---------------------------------------------------------------------------
  // الألوان المشتركة (Shared Colors)
  // ---------------------------------------------------------------------------
  
  /// اللون الأساسي للعلامة التجارية، يستخدم في كلا الوضعين.
  static const primary = Color(0xFF4E6EF2);
  
  /// اللون الأبيض النقي.
  static const white = Colors.white;

  // ---------------------------------------------------------------------------
  // ألوان الوضع النهاري (Light Mode)
  // ---------------------------------------------------------------------------
  static const light = _LightColors();

  // ---------------------------------------------------------------------------
  // ألوان الوضع الليلي (Dark Mode)
  // ---------------------------------------------------------------------------
  static const dark = _DarkColors();
}


/// فئة خاصة تحتوي على تعريفات ألوان الوضع النهاري.
class _LightColors {
  const _LightColors();

  /// لون الخلفية الرئيسي في الوضع النهاري.
  Color get background => const Color(0xFFF3F3F3);

  /// لون الأسطح (الكروت، الأشرطة) في الوضع النهاري.
  Color get surface => AppColors.white;

  /// لون النص الأساسي الداكن.
  Color get text => const Color(0xFF1F2937);
  
  /// لون النص الفرعي أو الرمادي.
  Color get textSecondary => const Color(0xFF6B7280);
}


/// فئة خاصة تحتوي على تعريفات ألوان الوضع الليلي.
class _DarkColors {
  const _DarkColors();

  /// لون الخلفية الرئيسي في الوضع الليلي (أسود غير كامل).
  Color get background => const Color(0xFF121212);

  /// لون الأسطح (الكروت، الأشرطة) في الوضع الليلي.
  Color get surface => const Color(0xFF1E1E1E);

  /// لون النص الأساسي الفاتح.
  Color get text => AppColors.white;
  
  /// لون النص الفرعي أو الرمادي الفاتح.
  Color get textSecondary => Colors.white60;
}

// lib/providers/theme_provider.dart

import 'package:flutter/material.dart';

/// مدير حالة مسؤول عن تتبع وتغيير ثيم التطبيق (نهاري/ليلي).
class ThemeProvider with ChangeNotifier {
  
  /// متغير الحالة الخاص الذي يحتفظ بالوضع الحالي للثيم.
  /// يتم تهيئته بقيمة `ThemeMode.light` لضمان أن التطبيق يبدأ دائمًا بالوضع النهاري.
  ThemeMode _themeMode = ThemeMode.light;

  /// `getter` عام يوفر وصولاً آمنًا (للقراءة فقط) للحالة الحالية للثيم.
  /// `MaterialApp` سيستخدم هذا الـ `getter` لتحديد أي ثيم يجب عرضه.
  ThemeMode get themeMode => _themeMode;

  /// `getter` مساعد لمعرفة ما إذا كان الوضع الحالي هو النهاري.
  /// `RoleToggle` في `ProfilePage` سيستخدم هذا لتحديد حالته.
  bool get isLightMode => _themeMode == ThemeMode.light;

  /// الدالة العامة التي تقوم بتغيير حالة الثيم.
  /// يتم استدعاؤها من `ProfilePage` عند الضغط على مفتاح التبديل.
  void toggleTheme(bool isLight) {
    // تحديث قيمة الحالة بناءً على القيمة الجديدة من مفتاح التبديل.
    _themeMode = isLight ? ThemeMode.light : ThemeMode.dark;

    // أهم خطوة: إعلام كل "المستمعين" (وهم `Consumer` في main.dart)
    // بحدوث تغيير، مما يؤدي إلى إعادة بناء الواجهة بالثيم الجديد.
    notifyListeners();
  }
}

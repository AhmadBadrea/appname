// lib/shared_widgets/primary_button.dart

import 'package:flutter/material.dart';

/// زر الإجراء الأساسي في التطبيق.
/// يرث كل تصميمه تلقائيًا من `elevatedButtonTheme` في `AppTheme`.
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // --- تم حذف SizedBox و ElevatedButton.styleFrom بالكامل ---
    
    // ElevatedButton الآن سيبحث تلقائيًا عن `elevatedButtonTheme`
    // في الثيم ويطبق كل الأنماط (الحجم، اللون، الشكل، الخط).
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

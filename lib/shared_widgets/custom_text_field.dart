// lib/shared_widgets/custom_text_field.dart

import 'package:flutter/material.dart';

/// مكون مشترك لحقل إدخال النص.
/// يرث كل تصميمه تلقائيًا من `inputDecorationTheme` في `AppTheme`.
class CustomTextField extends StatelessWidget {
  // --- المعلمات الأساسية ---
  final String hint;
  final IconData icon;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  
  // --- معلمات اختيارية لحالات الاستخدام المتقدمة ---
  final bool readOnly;
  final VoidCallback? onTap;
  final bool obscureText; // لدعم حقل كلمة المرور
  final Widget? suffixIcon; // لدعم أيقونة إظهار/إخفاء

  const CustomTextField({
    super.key,
    required this.hint,
    required this.icon,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.onTap,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    // --- 1. تم حذف `final theme = Theme.of(context)` ---
    // لم نعد بحاجة إليه لأن `TextField` سيستخدم الثيم تلقائيًا.

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      obscureText: obscureText,

      // --- 2. هذا هو التعديل الجوهري ---
      // أصبح الديكور بسيطًا جدًا.
      // كل الألوان، الحواف، وأنماط الخط سيتم جلبها من `inputDecorationTheme`.
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
      ),
    );
  }
}

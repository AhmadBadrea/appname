// lib/shared_widgets/password_field.dart

import 'package:appname/shared_widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

/// مكون متخصص لكلمة المرور.
/// يرث كل تصميمه من `CustomTextField`، ويدير فقط حالة إظهار/إخفاء النص.
class PasswordField extends StatefulWidget {
  final String hint;
  final TextEditingController? controller;

  const PasswordField({super.key, required this.hint, this.controller});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  /// 1. متغير الحالة المحلي لإدارة رؤية النص.
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    // --- 2. هذا هو التعديل الجوهري ---
    // نحن الآن نستخدم `CustomTextField` بدلاً من `TextField`.
    return CustomTextField(
      controller: widget.controller,
      hint: widget.hint,
      icon: Icons.lock_outline,

      // 3. تمرير الخصائص الإضافية إلى `CustomTextField`.
      obscureText: _obscureText,
      suffixIcon: IconButton(
        // الأيقونة تتغير بناءً على حالة `_obscureText`.
        icon: Icon(
          _obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
        ),
        onPressed: () {
          // تحديث الحالة لإعادة بناء الواجهة بالأيقونة والنص الصحيحين.
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
    );
  }
}

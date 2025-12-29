// lib/shared_widgets/role_toggle.dart

import 'package:flutter/material.dart';

/// ويدجت عام للتبديل بين خيارين، مصمم ليعتمد بالكامل على الثيم المركزي.
class RoleToggle extends StatelessWidget {
  /// النص الذي يظهر للخيار الأول (عندما تكون القيمة `true`).
  final String optionOneText;

  /// النص الذي يظهر للخيار الثاني (عندما تكون القيمة `false`).
  final String optionTwoText;

  /// القيمة الحالية للمفتاح. `true` يمثل الخيار الأول.
  final bool value;

  /// دالة يتم استدعاؤها عند تغيير القيمة.
  final ValueChanged<bool> onChanged;

  const RoleToggle({
    super.key,
    required this.optionOneText,
    required this.optionTwoText,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(4), // إضافة padding داخلي
      decoration: BoxDecoration(
        // استخدام لون أفتح قليلاً من dividerColor
        color: theme.dividerColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12), // حواف أكثر دائرية
      ),
      child: Row(
        children: [
          _buildItem(context, optionOneText, true),
          _buildItem(context, optionTwoText, false),
        ],
      ),
    );
  }

  /// دالة مساعدة خاصة لبناء كل عنصر تبديل.
  Widget _buildItem(BuildContext context, String text, bool itemValue) {
    final theme = Theme.of(context);
    final bool isActive = value == itemValue;

    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(itemValue),
        // استخدام `AnimatedContainer` لإضافة حركة انتقال سلسة.
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? theme.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelLarge?.copyWith(
              fontSize: 14, // حجم خط أنسب
              color: isActive
                  ? theme
                        .colorScheme
                        .onPrimary // لون النص فوق اللون الأساسي
                  : theme.textTheme.bodyMedium?.color, // لون النص العادي
            ),
          ),
        ),
      ),
    );
  }
}

// lib/shared_widgets/image_picker_box.dart

import 'dart:io';
import 'package:flutter/material.dart';

/// ويدجت مشترك لعرض مربع اختيار صورة.
/// يعرض إما أيقونة ونصًا، أو الصورة المختارة.
/// تم تحديثه ليعتمد بالكامل على الثيم المركزي.
class ImagePickerBox extends StatelessWidget {
  final String title;
  final IconData icon;
  final File? image;
  final VoidCallback onTap;

  const ImagePickerBox({
    super.key,
    required this.title,
    required this.icon,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 1. جلب الثيم لسهولة الوصول
    final theme = Theme.of(context);

    // 2. استخدام `Expanded` يضمن أن المكون سيأخذ المساحة المتاحة في `Row`
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 120,
          // --- 3. استخدام الألوان من الثيم ---
          decoration: BoxDecoration(
            // لون السطح (أبيض في النهاري، رمادي داكن في الليلي)
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            // لون الإطار هو لون الفواصل في الثيم
            border: Border.all(color: theme.dividerColor),
          ),
          // `ClipRRect` يضمن أن الصورة تأخذ نفس الحواف الدائرية للحاوية
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: image == null
                // --- الحالة الفارغة ---
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 32, color: theme.primaryColor),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        // --- 4. استخدام أنماط الخطوط من الثيم ---
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                // --- حالة وجود صورة ---
                : Image.file(
                    image!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }
}

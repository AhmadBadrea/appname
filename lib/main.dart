// lib/main.dart

import 'package:appname/core/routing/app_router.dart';
import 'package:appname/core/theme/app_theme.dart';
import 'package:appname/providers/auth_provider.dart'; // <-- 1. استيراد AuthProvider
import 'package:appname/providers/theme_provider.dart'; // <-- 2. استيراد ThemeProvider
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <-- 3. استيراد Provider

void main() {
  // يمكن إضافة أي إعدادات أولية للتطبيق هنا قبل تشغيله
  runApp(const MyApp());
}

/// الويدجت الجذر للتطبيق.
/// مسؤول عن توفير كل الخدمات المركزية (Providers) وبناء MaterialApp.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // --- 4. استخدام MultiProvider لتوفير كل خدمات إدارة الحالة ---
    return MultiProvider(

      providers: [
        // توفير خدمة إدارة حالة المصادقة
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // توفير خدمة إدارة حالة الثيم
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],







      // --- 5. استخدام Consumer لجعل MaterialApp يستجيب لتغييرات الثيم ---
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Real Estate App',

            // --- 6. ربط الثيمات والوضع بالـ Provider ---
            theme: AppTheme.lightTheme, // الثيم النهاري دائمًا هنا
            darkTheme: AppTheme.darkTheme, // الثيم الليلي دائمًا هنا
            themeMode: themeProvider
                .themeMode, // الـ Provider هو من يقرر أيهما يتم عرضه
            // استخدام التوجيه المركزي
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: AppRouter.onboarding,
          );
        },
      ),
    );
  }
}

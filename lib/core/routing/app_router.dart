// lib/core/routing/app_router.dart

import 'package:appname/data/models/apartment_model.dart';
import 'package:appname/data/models/chat_model.dart';
import 'package:appname/features/apartment/apartment_detail_page.dart';
import 'package:appname/features/auth/sign_in_page.dart';
import 'package:appname/features/auth/sign_up_page.dart';
import 'package:appname/features/chat/screens/chat_detail_screen.dart';
import 'package:appname/features/chat/screens/chats_screen.dart';
import 'package:appname/features/home/home_page.dart';
import 'package:appname/features/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';

/// مدير التوجيه المركزي للتطبيق (Single Source of Truth for Navigation).
class AppRouter {
  // private constructor لمنع إنشاء كائنات من هذا الكلاس.
  AppRouter._();

  // --- تعريف ثابت وواضح لكل المسارات ---
  static const String onboarding = '/';
  static const String signIn = '/signIn';
  static const String signUp = '/signUp';
  static const String home = '/home';
  static const String chats = '/chats';
  static const String chatDetail = '/chatDetail';
  static const String apartmentDetail = '/apartmentDetail';

  /// الدالة الأساسية التي تبني المسارات بناءً على الإعدادات.
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case signIn:
        return MaterialPageRoute(builder: (_) => const SignInPage());
      case signUp:
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case chats:
        return MaterialPageRoute(builder: (_) => const ChatsScreen());

      case chatDetail:
        // استخدام متغير محلي يجعل الكود أنظف.
        final arguments = settings.arguments;
        if (arguments is Chat) {
          return MaterialPageRoute(
            builder: (_) => ChatDetailScreen(chat: arguments),
          );
        }
        // --- تحسين رسالة الخطأ ---
        return _errorRoute(
          'Invalid arguments for chatDetail route. Expected Chat, got ${arguments.runtimeType}',
        );

      case apartmentDetail:
        final arguments = settings.arguments;
        if (arguments is Apartment) {
          return MaterialPageRoute(
            builder: (_) => ApartmentDetailPage(apartment: arguments),
          );
        }
        // --- تحسين رسالة الخطأ ---
        return _errorRoute(
          'Invalid arguments for apartmentDetail route. Expected Apartment, got ${arguments.runtimeType}',
        );

      default:
        return _errorRoute('No route defined for ${settings.name}');
    }
  }

  /// دالة مساعدة خاصة لبناء شاشة الخطأ.
  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              message,
              style: const TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

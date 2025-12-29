// lib/features/auth/sign_in_page.dart

import 'package:appname/core/routing/app_router.dart';
import 'package:appname/shared_widgets/custom_text_field.dart';
import 'package:appname/shared_widgets/password_field.dart';
import 'package:appname/shared_widgets/primary_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// شاشة تسجيل الدخول.
/// تم تحديثها لتعتمد بالكامل على الثيم المركزي.
class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. جلب الثيم مرة واحدة لسهولة الوصول
    final theme = Theme.of(context);

    return Scaffold(
      // --- تم حذف `backgroundColor` من هنا ---
      // `Scaffold` الآن سيأخذ لونه تلقائيًا من الثيم (نهاري أو ليلي)

      body: SafeArea( // استخدام SafeArea لتجنب تداخل الواجهة مع شريط الحالة
        child: SingleChildScrollView( // استخدام SingleChildScrollView لتجنب overflow عند ظهور الكيبورد
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            // استخدام SizedBox مع ارتفاع الشاشة لضمان التوسيط العمودي الصحيح
            height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 2. استخدام الألوان والأنماط من الثيم
                Icon(Icons.home_work_outlined, size: 80, color: theme.primaryColor),
                const SizedBox(height: 12),
                Text(
                  'Welcome Back!',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 30),
                const CustomTextField(
                  hint: 'Phone Number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                const PasswordField(hint: 'Password'),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () { /* TODO: Implement forget password */ },
                    child: Text('Forget Password?', style: TextStyle(color: theme.primaryColor)),
                  ),
                ),
                const SizedBox(height: 10),
                PrimaryButton(
                  text: 'Sign in',
                  onPressed: () => Navigator.pushReplacementNamed(context, AppRouter.home),
                ),
                const SizedBox(height: 24),
                
                // 3. استخدام RichText مع أنماط من الثيم
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: theme.textTheme.bodyMedium,
                    children: [
                      const TextSpan(text: "Don't have an account? "),
                      TextSpan(
                        text: 'Sign up',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.pushNamed(context, AppRouter.signUp),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

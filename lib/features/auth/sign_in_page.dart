// lib/features/auth/sign_in_page.dart

import 'package:appname/core/routing/app_router.dart';
import 'package:appname/core/theme/app_colors.dart';
import 'package:appname/shared_widgets/custom_text_field.dart';
import 'package:appname/shared_widgets/password_field.dart';
import 'package:appname/shared_widgets/primary_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor:
          AppColors.background, // يمكنك إبقاؤه أو حذفه ليعتمد على الثيم
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home_outlined, size: 80, color: AppColors.primary),
            const SizedBox(height: 12),
            const Text(
              'Welcome Back!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            const CustomTextField(
              hint: 'Phone Number',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            const PasswordField(hint: 'Password'),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text('Forget Password?'),
              ),
            ),
            PrimaryButton(
              text: 'Sign in',
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, AppRouter.home),
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                style: theme.textTheme.bodyMedium,
                children: [
                  const TextSpan(text: "Don't have an account? "),
                  TextSpan(
                    text: 'Sign up',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () =>
                          Navigator.pushNamed(context, AppRouter.signUp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

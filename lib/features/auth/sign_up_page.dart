import 'dart:io';
import 'package:appname/core/theme/app_colors.dart';
import 'package:appname/features/home/home_page.dart';
import 'package:appname/features/auth/sign_in_page.dart';
import 'package:appname/shared_widgets/custom_text_field.dart';
import 'package:appname/shared_widgets/password_field.dart';
import 'package:appname/shared_widgets/primary_button.dart';
import 'package:appname/shared_widgets/role_toggle.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isTenant = true;

  File? personalImage;
  File? idImage;

  final ImagePicker _picker = ImagePicker();

  // ✅ Controller لتاريخ الميلاد
  final TextEditingController _dobController = TextEditingController();

  Future<void> _pickPersonalImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        personalImage = File(picked.path);
      });
    }
  }

  Future<void> _pickIdImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        idImage = File(picked.path);
      });
    }
  }

  // ✅ Date Picker
  Future<void> _pickDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textDark,
            ), dialogTheme: DialogThemeData(backgroundColor: AppColors.background),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Icon(Icons.home_outlined, size: 80),
            const SizedBox(height: 10),
            const Text(
              'Welcome To AppName',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            RoleToggle(
              isTenant: isTenant,
              onChanged: (value) {
                setState(() => isTenant = value);
              },
            ),

            const SizedBox(height: 20),

            const CustomTextField(hint: 'First Name', icon: Icons.person),
            const SizedBox(height: 12),
            const CustomTextField(
              hint: 'Last Name',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 12),
            const CustomTextField(
              hint: 'Phone Number',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),

            // ✅ Date Of Birth (مع DatePicker)
            CustomTextField(
              hint: 'Date Of Birth',
              icon: Icons.calendar_today,
              controller: _dobController,
              readOnly: true,
              onTap: () => _pickDateOfBirth(context),
            ),
            const SizedBox(height: 12),
            const PasswordField(hint: 'Password'),
            const SizedBox(height: 12),
            const PasswordField(hint: 'Confirm Password'),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _ImageBox(
                    title: 'Personal Photo',
                    icon: Icons.person_outline,
                    image: personalImage,
                    onTap: _pickPersonalImage,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ImageBox(
                    title: 'ID Photo',
                    icon: Icons.badge_outlined,
                    image: idImage,
                    onTap: _pickIdImage,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            PrimaryButton(
              text: 'Sign up',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                );
              },
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignInPage()),
                    );
                  },
                  child: const Text(
                    'Sign In',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            const Text(
              'Terms of service & Privacy Policy',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageBox extends StatelessWidget {
  final String title;
  final IconData icon;
  final File? image;
  final VoidCallback onTap;

  const _ImageBox({
    required this.title,
    required this.icon,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: image == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 32, color: AppColors.primary),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  image!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}

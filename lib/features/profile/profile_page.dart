// // lib/features/profile/profile_page.dart

// import 'package:appname/core/routing/app_router.dart';
// import 'package:appname/providers/auth_provider.dart';
// import 'package:appname/providers/theme_provider.dart';
// import 'package:appname/shared_widgets/role_toggle.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// /// شاشة عرض الملف الشخصي للمستخدم.
// /// تتفاعل مع `AuthProvider` لعرض بيانات المستخدم وتسجيل الخروج،
// /// وتتفاعل مع `ThemeProvider` لتغيير وضع التطبيق.
// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     // 1. استهلاك Providers:
//     // `listen: true` (الافتراضي) يجعل الواجهة تعيد بناء نفسها عند أي تغيير.
//     final authProvider = Provider.of<AuthProvider>(context);
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final user = authProvider.user;

//     // 2. التحقق من وجود مستخدم:
//     // إذا لم يكن هناك مستخدم، نعرض واجهة بديلة.
//     if (user == null) {
//       return Scaffold(
//         appBar: AppBar(title: const Text('حسابي')),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text('يرجى تسجيل الدخول لعرض ملفك الشخصي.'),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size(150, 48),
//                 ),
//                 onPressed: () => Navigator.pushNamedAndRemoveUntil(
//                   context,
//                   AppRouter.signIn,
//                   (route) => false,
//                 ),
//                 child: const Text('تسجيل الدخول'),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     // 3. بناء الواجهة الرئيسية في حال وجود مستخدم.
//     return Scaffold(
//       appBar: AppBar(title: const Text('حسابي'), centerTitle: true),
//       body: ListView(
//         padding: const EdgeInsets.all(20.0),
//         children: [
//           // قسم معلومات المستخدم
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 40,
//                 backgroundImage: user.profileImageFile != null
//                     ? FileImage(user.profileImageFile!) as ImageProvider
//                     : (user.profileImageUrl != null
//                           ? NetworkImage(user.profileImageUrl!)
//                           : null),
//                 child:
//                     (user.profileImageFile == null &&
//                         user.profileImageUrl == null)
//                     ? const Icon(Icons.person, size: 40)
//                     : null,
//               ),
//               const SizedBox(width: 16),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     user.fullName,
//                     style: theme.textTheme.titleLarge?.copyWith(fontSize: 20),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     user.phone,
//                     style: theme.textTheme.bodyMedium?.copyWith(
//                       color: theme.textTheme.bodySmall?.color,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const Divider(height: 50, thickness: 0.8),

//           // قسم خيارات القائمة
//           _buildProfileOption(
//             context: context,
//             icon: Icons.brightness_6_outlined,
//             title: 'الوضع',
//             trailing: SizedBox(
//               width: 150,
//               child: RoleToggle(
//                 optionOneText: 'نهاري',
//                 optionTwoText: 'ليلي',
//                 value: themeProvider.isLightMode,
//                 onChanged: (isLight) {
//                   themeProvider.toggleTheme(isLight);
//                 },
//               ),
//             ),
//           ),
//           _buildProfileOption(
//             context: context,
//             icon: Icons.edit_outlined,
//             title: 'تعديل الملف الشخصي',
//             onTap: () {},
//           ),
//           _buildProfileOption(
//             context: context,
//             icon: Icons.settings_outlined,
//             title: 'الإعدادات',
//             onTap: () {},
//           ),
//           _buildProfileOption(
//             context: context,
//             icon: Icons.help_outline,
//             title: 'المساعدة',
//             onTap: () {},
//           ),
//           const Divider(height: 40),

//           // خيار تسجيل الخروج
//           _buildProfileOption(
//             context: context,
//             icon: Icons.logout,
//             title: 'تسجيل الخروج',
//             onTap: () {
//               // استدعاء دالة تسجيل الخروج من الـ Provider
//               authProvider.logout();
//               // الانتقال إلى شاشة تسجيل الدخول مع إزالة كل الشاشات السابقة
//               Navigator.pushNamedAndRemoveUntil(
//                 context,
//                 AppRouter.signIn,
//                 (route) => false,
//               );
//             },
//             isLogout: true,
//           ),
//         ],
//       ),
//     );
//   }

//   /// دالة مساعدة لبناء كل خيار في القائمة.
//   Widget _buildProfileOption({
//     required BuildContext context,
//     required IconData icon,
//     required String title,
//     VoidCallback? onTap,
//     Widget? trailing,
//     bool isLogout = false,
//   }) {
//     final theme = Theme.of(context);
//     final Color color = isLogout
//         ? theme.colorScheme.error
//         : theme.textTheme.bodyLarge!.color!;

//     return ListTile(
//       leading: Icon(icon, color: color),
//       title: Text(
//         title,
//         style: theme.textTheme.titleMedium?.copyWith(
//           color: color,
//           fontWeight: isLogout ? FontWeight.bold : FontWeight.w500,
//         ),
//       ),
//       trailing:
//           trailing ??
//           (isLogout ? null : const Icon(Icons.arrow_forward_ios, size: 16)),
//       onTap: onTap,
//       contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
//     );
//   }
// }

// lib/features/profile/profile_page.dart

import 'package:appname/data/models/user_model.dart'; // <-- 1. استيراد UserModel
import 'package:appname/providers/theme_provider.dart';
import 'package:appname/shared_widgets/role_toggle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// تم حذف `import 'package:appname/providers/auth_provider.dart';`
// تم حذف `import 'package:appname/core/routing/app_router.dart';`

/// شاشة عرض الملف الشخصي للمستخدم (نسخة تجريبية).
/// تعرض بيانات مستخدم وهمي ثابتة، ولكنها تتفاعل مع ThemeProvider.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 2. استهلاك ThemeProvider فقط
    final themeProvider = Provider.of<ThemeProvider>(context);

    // --- 3. هذا هو التعديل الجوهري ---
    // إنشاء مستخدم وهمي مباشرة بدلاً من طلبه من AuthProvider
    final user = UserModel.dummy();

    return Scaffold(
      appBar: AppBar(title: const Text('حسابي (تجريبي)'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          // قسم معلومات المستخدم (يستخدم الآن `user` الوهمي)
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: user.profileImageUrl != null
                    ? NetworkImage(user.profileImageUrl!)
                    : null,
                child: user.profileImageUrl == null
                    ? const Icon(Icons.person, size: 40)
                    : null,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName,
                    style: theme.textTheme.titleLarge?.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.phone,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 50, thickness: 0.8),

          // قسم خيارات القائمة
          // مفتاح تبديل الوضع لا يزال يعمل بشكل كامل
          _buildProfileOption(
            context: context,
            icon: Icons.brightness_6_outlined,
            title: 'الوضع',
            trailing: SizedBox(
              width: 150,
              child: RoleToggle(
                optionOneText: 'نهاري',
                optionTwoText: 'ليلي',
                value: themeProvider.isLightMode,
                onChanged: (isLight) {
                  themeProvider.toggleTheme(isLight);
                },
              ),
            ),
          ),

          _buildProfileOption(
            context: context,
            icon: Icons.edit_outlined,
            title: 'تعديل الملف الشخصي',
            onTap: () {},
          ),
          _buildProfileOption(
            context: context,
            icon: Icons.settings_outlined,
            title: 'الإعدادات',
            onTap: () {},
          ),
          _buildProfileOption(
            context: context,
            icon: Icons.brightness_6_outlined,
            title: 'اللغة',
            trailing: SizedBox(
              width: 150,
              child: RoleToggle(
                optionOneText: 'عربي',
                optionTwoText: 'انكليزي',
                value: themeProvider.isLightMode,
                onChanged: (isLight) {
                  themeProvider.toggleTheme(isLight);
                },
              ),
            ),
          ),
          const Divider(height: 40),

          // خيار تسجيل الخروج (وظيفته معطلة مؤقتًا)
          _buildProfileOption(
            context: context,
            icon: Icons.logout,
            title: 'تسجيل الخروج',
            onTap: () {
              // لا يوجد منطق هنا حاليًا لأننا لا نستخدم AuthProvider
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم تعطيل تسجيل الخروج في الوضع التجريبي.'),
                ),
              );
            },
            isLogout: true,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? trailing,
    bool isLogout = false,
  }) {
    final theme = Theme.of(context);
    final Color color = isLogout
        ? theme.colorScheme.error
        : theme.textTheme.bodyLarge!.color!;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          color: color,
          fontWeight: isLogout ? FontWeight.bold : FontWeight.w500,
        ),
      ),
      trailing:
          trailing ??
          (isLogout ? null : const Icon(Icons.arrow_forward_ios, size: 16)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
    );
  }
}

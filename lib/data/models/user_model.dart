// lib/data/models/user_model.dart

import 'dart:io';

/// يمثل دور المستخدم في التطبيق.
enum UserRole { tenant, owner }

/// نموذج بيانات يمثل المستخدم في التطبيق.
/// مصمم ليكون قابلاً للتطوير ومستعدًا للربط مع قاعدة بيانات.
class UserModel {
  /// المعرف الفريد للمستخدم (سيأتي من قاعدة البيانات مستقبلًا).
  final String uid;

  /// الاسم الكامل للمستخدم.
  final String fullName;

  /// رقم الهاتف.
  final String phone;

  /// دور المستخدم (مستأجر أم مالك).
  final UserRole role;

  /// تاريخ الميلاد.
  final DateTime? dateOfBirth;

  /// رابط صورة الملف الشخصي (سيأتي من خدمة تخزين سحابية).
  final String? profileImageUrl;

  /// ملف صورة الملف الشخصي (يستخدم مؤقتًا عند اختيار صورة جديدة من الجهاز).
  final File? profileImageFile;

  /// تاريخ إنشاء الحساب.
  final DateTime createdAt;

  const UserModel({
    required this.uid,
    required this.fullName,
    required this.phone,
    required this.role,
    required this.createdAt,
    this.dateOfBirth,
    this.profileImageUrl,
    this.profileImageFile,
  });

  /// دالة مساعدة لإنشاء مستخدم وهمي لأغراض الاختبار والتصميم.
  /// هذا يسمح بعرض بيانات في `ProfilePage` حتى بدون تسجيل دخول حقيقي.
  factory UserModel.dummy() {
    return UserModel(
      uid: 'dummy-uid-12345',
      fullName: 'عبدالله الفلاني',
      phone: '+966 55 123 4567',
      role: UserRole.tenant,
      createdAt: DateTime.now(),
      profileImageUrl: 'https://i.pravatar.cc/150?img=53', // استخدام رابط صورة وهمية
    );
  }
}

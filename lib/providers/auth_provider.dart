// lib/providers/auth_provider.dart

import 'dart:io';
import 'package:appname/data/models/user_model.dart';
import 'package:flutter/foundation.dart';

/// مدير حالة مسؤول عن تتبع وتغيير حالة مصادقة المستخدم.
/// يعمل كمصدر للحقيقة الوحيد لهوية المستخدم الحالي.
class AuthProvider with ChangeNotifier {
  
  /// متغير الحالة الخاص الذي يحتفظ ببيانات المستخدم الذي قام بتسجيل الدخول.
  /// يكون `null` إذا لم يقم أي مستخدم بتسجيل الدخول.
  UserModel? _currentUser;

  /// `getter` عام يوفر وصولاً آمناً (للقراءة فقط) لبيانات المستخدم الحالي.
  /// الشاشات مثل `ProfilePage` ستستخدم هذا للوصول إلى المعلومات.
  UserModel? get user => _currentUser;

  /// `getter` مساعد لمعرفة ما إذا كان هناك مستخدم قد سجل دخوله أم لا.
  bool get isAuthenticated => _currentUser != null;

  /// دالة لتسجيل مستخدم جديد.
  /// يتم استدعاؤها من `SignUpPage`.
  void signUp({
    required String fullName,
    required String phone,
    required UserRole role,
    DateTime? dateOfBirth,
    File? profileImageFile,
  }) {
    // في تطبيق حقيقي، ستقوم هنا بالآتي:
    // 1. إرسال البيانات إلى خادم (API) لإنشاء الحساب.
    // 2. إذا تم اختيار صورة (`profileImageFile`)، تقوم برفعها إلى خدمة تخزين سحابي.
    // 3. الخادم سيعيد لك `uid` للمستخدم الجديد ورابط الصورة `profileImageUrl`.
    
    // حاليًا، نقوم فقط بإنشاء مستخدم وهمي محليًا.
    _currentUser = UserModel(
      // ننشئ UID عشوائيًا لمحاكاة قاعدة البيانات.
      uid: DateTime.now().millisecondsSinceEpoch.toString(), 
      fullName: fullName,
      phone: phone,
      role: role,
      dateOfBirth: dateOfBirth,
      profileImageFile: profileImageFile,
      // في تطبيق حقيقي، ستأخذ الرابط من الخادم.
      profileImageUrl: null, 
      createdAt: DateTime.now(),
    );

    // إعلام كل "المستمعين" بأن حالة المصادقة قد تغيرت.
    notifyListeners();
  }

  /// دالة لتسجيل دخول مستخدم حالي (للمستقبل).
  void signIn({required String phone, required String password}) {
    // في تطبيق حقيقي، ستقوم بالتحقق من بيانات الدخول مع الخادم.
    // إذا كان الدخول ناجحًا، الخادم سيعيد بيانات المستخدم.
    
    // حاليًا، سنقوم بتسجيل دخول المستخدم الوهمي مباشرة.
    _currentUser = UserModel.dummy();
    notifyListeners();
  }

  /// دالة لتسجيل خروج المستخدم الحالي.
  /// يتم استدعاؤها من `ProfilePage`.
  void logout() {
    // مسح بيانات المستخدم من الحالة.
    _currentUser = null;
    notifyListeners();
  }
}

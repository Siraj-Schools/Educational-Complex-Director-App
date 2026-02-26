// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'سراج';

  @override
  String get welcome => 'مرحباً بك';

  @override
  String get loginTitle => 'تسجيل الدخول إلى النظام';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get systemName => 'نظام سراج لإدارة المجمعات التربوية';

  @override
  String get systemDescription => 'منصة متكاملة لإدارة المدارس، الكوادر التعليمية، والطلاب بكفاءة واحترافية.';

  @override
  String get emailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get invalidEmail => 'صيغة البريد الإلكتروني غير صحيحة';

  @override
  String get passwordRequired => 'كلمة المرور مطلوبة';
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Siraj';

  @override
  String get welcome => 'Welcome';

  @override
  String get loginTitle => 'Login to the System';

  @override
  String get email => 'Email Address';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot your password?';

  @override
  String get login => 'Login';

  @override
  String get systemName => 'Siraj System for Educational Complex Management';

  @override
  String get systemDescription => 'An integrated platform for managing schools, educational staff, and students efficiently and professionally.';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get invalidEmail => 'Invalid email format';

  @override
  String get passwordRequired => 'Password is required';
}

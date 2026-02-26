
import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/l10n/app_localizations_ar.dart';
import 'package:educational_complex_director_app/utils/s_responsive_layout.dart';
import 'package:educational_complex_director_app/view/pages/authpageresponsive/auth_page_desktop_and_tablet.dart';
import 'package:educational_complex_director_app/view/pages/authpageresponsive/auth_page_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  Future<void> handleLogin() async {
    if (_authPageStateModel.formKey.currentState!.validate()) {
      //TODO: Implement login logic here
    
    }
  }
  String? emailValidator(String? value) {
      final local=AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return local.emailRequired;
    }
    // Simple email regex
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) {
      return local.invalidEmail;
    }
    return null;
  }
  String? passwordValidator(String? value) {
    final local=AppLocalizations.of(context)!;
     if (value == null || value.trim().isEmpty) {
      return local.passwordRequired;
    }
   
    return null;
  }
  late final AuthPageStateModel _authPageStateModel;

@override
void initState() {
  super.initState();

  _authPageStateModel = AuthPageStateModel(
    onLoginPressed: handleLogin,
    emailValidator: emailValidator,
    passwordValidator: passwordValidator,
  );
  _authPageStateModel.obscurePassword.addListener(() => setState(() {
    
  }));
}

  @override
  Widget build(BuildContext context) {
    
    return  SResponsiveLayout(
      mobile: AuthPageMobile(authmodel: _authPageStateModel,),
      tablet: AuthPageDesktopAndTablet(authmodel: _authPageStateModel,),
      desktop: AuthPageDesktopAndTablet(authmodel: _authPageStateModel,),
    );
  }
}
class AuthPageStateModel{
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
   final ValueNotifier<bool> obscurePassword = ValueNotifier(true);
  final Future<void> Function() onLoginPressed;
  final String? Function(String?) emailValidator;
  final String? Function(String?) passwordValidator;
   AuthPageStateModel({
    required this.onLoginPressed,
   required this.emailValidator,
   required this.passwordValidator,
  });
}
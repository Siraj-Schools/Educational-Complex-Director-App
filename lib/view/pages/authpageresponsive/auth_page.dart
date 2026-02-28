import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/routes/routes.dart';

import 'package:educational_complex_director_app/services/local_storage_services.dart';
import 'package:educational_complex_director_app/utils/s_config.dart';

import 'package:educational_complex_director_app/utils/s_responsive_layout.dart';
import 'package:educational_complex_director_app/view/components/loading_dialog.dart';
import 'package:educational_complex_director_app/view/pages/authpageresponsive/auth_page_desktop_and_tablet.dart';
import 'package:educational_complex_director_app/view/pages/authpageresponsive/auth_page_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  Future<void> handleLogin() async {
    if (formKey.currentState!.validate()) {
      //TODO: Implement login logic here
      await Get.showOverlay(
        asyncFunction: () async {
          await Future.delayed(const Duration(seconds: 4));
          await LocalStorageService.setToken("aass");
        },
        loadingWidget: LoadingDialog(
          extraMessage: AppLocalizations.of(context)!.checkingCredentials,
        ),
        opacityColor: Colors.black.withAlpha(50),
      );

      await Get.offAllNamed(Sroutes.main);
    }
  }

  String? emailValidator(String? value) {
    final local = AppLocalizations.of(context)!;
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
    final local = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return local.passwordRequired;
    }

    return null;
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    SConfig.init(context);
    final Widget form = Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            local.loginTitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),

          SConfig.spaceBig,

          TextFormField(
            controller: emailController,
            textDirection: TextDirection.ltr,
            onFieldSubmitted: (value) async => await handleLogin(),
            decoration: InputDecoration(
              labelText: local.email,
              prefixIcon: const Icon(
                Icons.email_outlined,
                color: SConfig.secondaryBackground,
              ),
              hintText: "example@gmail.com",
              hintTextDirection: TextDirection.ltr,
            ),
            validator: emailValidator,
          ),

          SConfig.spaceMedium,

          TextFormField(
            controller: passwordController,
            obscureText: obscurePassword,
            validator: passwordValidator,
            onFieldSubmitted: (value) async => await handleLogin(),

            textDirection: TextDirection.ltr,

            decoration: InputDecoration(
              labelText: local.password,
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: SConfig.secondaryBackground,
              ),
              hintText: "********",
              hintTextDirection: TextDirection.ltr,

              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: SConfig.primaryColor,
                ),
                onPressed: () {
                  setState(() {
                    obscurePassword = !obscurePassword;
                  });
                },
              ),
            ),
          ),

          SConfig.spaceSmall,

          Align(
            alignment: local.localeName != "ar"
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: Text(
                local.forgotPassword,
                style: const TextStyle(
                  color: SConfig.accentColor,
                ),
              ),
            ),
          ),

          SConfig.spaceMedium,

          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: SConfig.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () async => await handleLogin(),
              child: Text(
                local.login,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
        ],
      ),
    );

    return SResponsiveLayout(
      mobile: AuthPageMobile(
        form: form,
      ),
      tablet: AuthPageDesktopAndTablet(
        form: form,
      ),
      desktop: AuthPageDesktopAndTablet(
        form: form,
      ),
    );
  }
}

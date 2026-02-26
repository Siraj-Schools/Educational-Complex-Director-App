
import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/utils/s_config.dart';
import 'package:educational_complex_director_app/view/pages/authpageresponsive/auth_page.dart';
import 'package:flutter/material.dart';

class AuthPageMobile extends StatelessWidget {
  const AuthPageMobile({super.key,required this.authmodel});

 final AuthPageStateModel authmodel;
  @override
  Widget build(BuildContext context ) {
    final local = AppLocalizations.of(context)!;
    SConfig.init(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24,),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
               
                // 🔷 LOGO
                
                Image.asset(
                  "assets/logo.png",
                  height: SConfig.heightSize! * 0.4,
                  
                ),
                // SConfig.spaceMedium,
          
                Text(
                  local.loginTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                  
                ),
          
                SConfig.spaceMedium,
          
                Form(
                  key: authmodel.formKey,
                  child: Column(
                    children: [
                      // 📧 EMAIL
                      TextFormField(
                        validator: authmodel.emailValidator,
                        controller: authmodel.emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: local.email,
                          prefixIcon: const Icon(Icons.email_outlined,color: SConfig.secondaryBackground,),
                          hintText: "example@gmail.com"
                        ),
                      ),
          
                      SConfig.spaceMedium,
          
                      // 🔒 PASSWORD
                      TextFormField(
                        controller: authmodel.passwordController,
                        obscureText: authmodel.obscurePassword.value,
                        validator: authmodel.passwordValidator,
                        decoration: InputDecoration(
                          hintText: "********",
                          labelText: local.password,
                          prefixIcon: const Icon(Icons.lock_outline,color: SConfig.secondaryBackground,),
                          suffixIcon: IconButton(
                            icon: Icon(authmodel.obscurePassword.value
                                ? Icons.visibility_off
                                : Icons.visibility,color: SConfig.primaryColor,),
                            onPressed: () {
                              authmodel.obscurePassword.value = !authmodel.obscurePassword.value;
                            },
                          ),
                        ),
                      ),
          
                      SConfig.spaceSmall,
          
                      // 🔑 FORGOT PASSWORD
                      Align(
                        alignment: local.localeName!="ar"
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
          
                      // 🚀 LOGIN BUTTON
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
                          onPressed: () {},
                          child: Text(local.login,style: Theme.of(context).textTheme.labelLarge,),
                        ),
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
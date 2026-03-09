import 'package:educational_complex_director_app/utils/s_config.dart';

import 'package:flutter/material.dart';

class AuthPageMobile extends StatelessWidget {
  const AuthPageMobile({super.key, required this.form});
  final Widget form;
  @override
  Widget build(BuildContext context) {
    SConfig.init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // 🔷 LOGO
                Image.asset(
                  "assets/logo.png",
                  width: 250,
                ),

                form,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

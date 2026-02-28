
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
         
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // 🔷 LOGO
                Image.asset(
                  "assets/logo.png",
                  height:300,
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

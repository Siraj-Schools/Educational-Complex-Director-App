import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/utils/s_config.dart';

import 'package:flutter/material.dart';


class AuthPageDesktopAndTablet extends StatelessWidget {
  const AuthPageDesktopAndTablet({super.key,required this.form});
  final Widget form;
  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    SConfig.init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Row(
        children: [
          // 🔷 LEFT SIDE (FORM)
          Expanded(
            flex: 4,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child:form
                ),
              ),
            ),
          ),

          // 🔶 RIGHT SIDE (BRANDING PANEL)
      Expanded(
   flex: 6,
    child: Builder(
    builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;

      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    const Color(0xFF0A1F25), // deep slate
                    const Color(0xFF062C33), // desaturated teal
                  ]
                : [
                    const Color(0xFF114451), // muted navy
                    const Color(0xFF1C7D81), // dark cyan
                  ],
          ),
        ),
        child: Stack(
          children: [
            

            // 🟠 Top-right soft orange accent circle
            Positioned(
              top: -80,
              right: -80,
              child: Container(
                height: 180,
                width: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: SConfig.accentColor.withAlpha(25),
                ),
              ),
            ),

            // 🟡 Bottom-left soft yellow accent circle
            Positioned(
              bottom: -100,
              left: -100,
              child: Container(
                height: 220,
                width: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: SConfig.highlightColor.withAlpha(13),
                ),
              ),
            ),

            // 🔷 Center content
            Center(
              child: Padding(
                padding: const EdgeInsets.all(48),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 🌟 Floating logo with radial glow
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Radial glow behind logo
                        Container(
                          width: SConfig.heightSize! * 0.45,
                          height: SConfig.heightSize! * 0.45,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              center: Alignment.center,
                              radius: 0.6,
                              colors: isDark
                                  ? [
                                      Colors.white,
                                      SConfig.primaryColor,
                                    ]
                                  : [
                                      Colors.white,
                                     Colors.white.withAlpha(204),

                                      SConfig.secondaryBackground.withAlpha(204),
                                    ],
                            ),
                          ),
                        ),

                        // Logo itself
                        Image.asset(
                          "assets/logo.png",
                          height: SConfig.heightSize! * 0.4,
                        ),
                      ],
                    ),

                    SConfig.spaceMedium,

                    Text(
                      local.systemName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SConfig.spaceSmall,

                    Text(
                      local.systemDescription,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  ),
),
],
      ),
    );
  }
}
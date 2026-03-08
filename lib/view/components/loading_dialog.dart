import 'dart:ui';

import 'package:educational_complex_director_app/utils/s_config.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingDialog extends StatelessWidget {
  final String? extraMessage;
  final Widget? loading;
  const LoadingDialog({super.key, this.extraMessage, this.loading});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    SConfig.init(context);

    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          // width: dialogWidth,
          constraints: const BoxConstraints(
            maxWidth: 300,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 30,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? SConfig.secondaryBackground.withAlpha(64)
                : Colors.white.withAlpha(150),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: SConfig.primaryColor.withAlpha(51),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(30),
                blurRadius: 25,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔄 Animated Loader
              //  const SizedBox(
              //     height: 90,
              //     width: 90,
              //     child: CircularProgressIndicator(
              //       strokeWidth: 6,
              //       color: SConfig.primaryColor,
              //     ),
              //   ),
              loading != null
                  ? loading!
                  : LoadingAnimationWidget.flickr(
                      leftDotColor: SConfig.secondaryBackground,
                      rightDotColor: SConfig.successColor,
                      size: 90,
                    ),

              const SizedBox(height: 24),

              // 📝 Main Text
              if (extraMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  extraMessage!,

                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: isDark
                        ? Colors.white.withAlpha(200)
                        : Colors.black.withAlpha(200),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

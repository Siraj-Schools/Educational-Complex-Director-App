import 'dart:ui';

import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/utils/s_config.dart';

import 'package:flutter/material.dart';

import 'package:get/route_manager.dart';

class ConfirmationDialog extends StatelessWidget {
  final String message;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const ConfirmationDialog({
    super.key,
    required this.message,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    SConfig.init(context);

    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 340),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
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
              /// Icon Badge
              // const FaIcon(
              //   FontAwesomeIcons.question,

              //   size: 50,
              //   color: SConfig.primaryColor,
              // ),

              // const SizedBox(height: 22),

              /// Message
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),

              const SizedBox(height: 28),

              /// Buttons
              Row(
                children: [
                  /// Cancel
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.transparent,
                        backgroundColor: SConfig.errorColor.withBlue(60),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: onCancel ?? () => Get.back(result: false),
                      child: Text(loc.cancel),
                    ),
                  ),

                  const SizedBox(width: 14),

                  /// Confirm
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SConfig.successColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: onConfirm ?? () => Get.back(result: true),
                      child: Text(loc.confirm),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:ui';

import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/models/helpers/new_credentials.dart';
import 'package:educational_complex_director_app/utils/s_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ShowNewCredentialsDialog extends StatelessWidget {
  const ShowNewCredentialsDialog({super.key, required this.newCredentials});
  final NewCredentials newCredentials;
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    SConfig.init(context);

    return Dialog(
      backgroundColor: SConfig.primaryColor,
      elevation: 0,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(240),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: SConfig.primaryColor.withAlpha(100),
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
              Text(
                loc.newCredentials,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: SConfig.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: TextEditingController(text: newCredentials.email),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: loc.email,
                  prefixIcon: const Icon(
                    Icons.person,
                    color: SConfig.primaryColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.copy,
                      size: 20,
                      color: SConfig.secondaryBackground.withAlpha(200),
                    ),
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(text: newCredentials.email),
                      );
                      Get.showSnackbar(
                        GetSnackBar(
                          title: loc.save,
                          message: loc.credentialsCopied,
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: SConfig.primaryColor,
                          borderRadius: 12,
                          messageText: Text(
                            loc.credentialsCopied,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),

                          duration: const Duration(seconds: 1),
                          margin: const EdgeInsets.symmetric(vertical: 24),
                          maxWidth: SConfig.screenWidth! * 0.6,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: TextEditingController(
                  text: newCredentials.password,
                ),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: loc.password,
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: SConfig.primaryColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.copy,
                      size: 20,
                      color: SConfig.secondaryBackground.withAlpha(200),
                    ),
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(text: newCredentials.password),
                      );
                      Get.showSnackbar(
                        GetSnackBar(
                          title: loc.save,
                          message: loc.credentialsCopied,
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: SConfig.primaryColor,
                          borderRadius: 12,
                          messageText: Text(
                            loc.credentialsCopied,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),

                          duration: const Duration(seconds: 1),
                          margin: const EdgeInsets.symmetric(vertical: 24),
                          maxWidth: SConfig.screenWidth! * 0.6,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SConfig.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Get.back(),
                  child: Text(
                    loc.ok,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

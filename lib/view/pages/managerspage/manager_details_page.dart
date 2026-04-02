import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/routes/routes.dart';
import 'package:educational_complex_director_app/utils/s_config.dart';
import 'package:educational_complex_director_app/view/components/error_dialog.dart';
import 'package:educational_complex_director_app/view/pages/managerspage/manager_info_form.dart';
import 'package:educational_complex_director_app/view_model/bread_crumb_notifier.dart';
import 'package:educational_complex_director_app/view_model/schoolmanager/school_manager_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ManagerDetailsPage extends ConsumerWidget {
  const ManagerDetailsPage({super.key, required this.managerId});
  final String managerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    const accent = Color(0xFF3F51B5); // Royal Blue

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              IconButton.filled(
                icon: const Icon(Icons.arrow_back_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: accent.withAlpha(20),
                  foregroundColor: accent,
                ),
                onPressed: () {
                  ref.read(managersBreadcrumbProvider.notifier).pop();
                  Get.back(id: Sroutes.managersNavigationId);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── PREMIUM HEADER ──────────────────────────────────────────────────
          ...ref
              .watch(schoolManagerDetailsNotifierProvider(managerId))
              .when(
                data: (manager) => [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF1A237E),
                          SConfig.primaryColor,
                        ], // Deep Indigo
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(36)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${manager.firstName} ${manager.middleName} ${manager.lastName}',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    loc.schoolManager,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withAlpha(200),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Wrap(
                                    spacing: 12,
                                    runSpacing: 8,
                                    children: [
                                      _infoChip(
                                        Icons.email_outlined,
                                        manager.email,
                                      ),
                                      _infoChip(
                                        Icons.phone_android_rounded,
                                        manager.mobileNumber,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ── MAIN CONTENT ────────────────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ManagerInfoForm(manager: manager),
                  ),
                ],

                loading: () => [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Center(
                      child: LoadingAnimationWidget.beat(
                        color: accent,
                        size: 90,
                      ),
                    ),
                  ),
                ],
                error: (e, s) => [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Center(
                      child: ErrorDialog(
                        message: loc.errorOccurred,
                        okText: loc.retry,
                        blur: 0,
                        onOK: () async {
                          await ref
                              .read(
                                schoolManagerDetailsNotifierProvider(
                                  managerId,
                                ).notifier,
                              )
                              .refresh();
                        },
                      ),
                    ),
                  ),
                ],
              ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(40),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withAlpha(60)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

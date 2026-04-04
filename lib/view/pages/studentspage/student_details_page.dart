import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/routes/routes.dart';
import 'package:educational_complex_director_app/utils/s_config.dart';
import 'package:educational_complex_director_app/view/components/error_dialog.dart';
import 'package:educational_complex_director_app/view/pages/studentspage/student_info_form.dart';
import 'package:educational_complex_director_app/view_model/bread_crumb_notifier.dart';
import 'package:educational_complex_director_app/view_model/student/student_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class StudentDetailsPage extends ConsumerWidget {
  const StudentDetailsPage({super.key, required this.studentId});
  final String studentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    const accent = Color.fromARGB(255, 164, 0, 0);

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
                  ref.read(studentsBreadcrumbProvider.notifier).pop();
                  Get.back(id: Sroutes.studentsNavigationId);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── PREMIUM HEADER ──────────────────────────────────────────────────
          ...ref
              .watch(studentDetailsNotifierProvider(studentId))
              .when(
                data: (student) => [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          accent,
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
                                    student.student.fullName,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${loc.standardName}: ${student.student.standardName}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withAlpha(200),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${loc.parent}: ${student.parent.parentFullName}",
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
                                        student.student.email,
                                      ),
                                      _infoChip(
                                        Icons.phone_android_rounded,
                                        student.mobileNumber,
                                      ),
                                      _infoChip(
                                        Icons.badge_outlined,
                                        student.student.nationalId,
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

                  const SizedBox(height: 40),

                  // ── MAIN CONTENT ────────────────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: StudentInfoForm(
                      studentDetails: student,
                    ),
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
                                studentDetailsNotifierProvider(
                                  studentId,
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

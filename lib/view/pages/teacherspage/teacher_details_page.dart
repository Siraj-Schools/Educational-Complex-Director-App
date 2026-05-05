import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/models/constants/qualifications.dart';
import 'package:educational_complex_director_app/models/constants/school_types.dart';
import 'package:educational_complex_director_app/models/constants/teacher_designation.dart';
import 'package:educational_complex_director_app/models/teacher/teacher_details.dart';
import 'package:educational_complex_director_app/routes/routes.dart';
import 'package:educational_complex_director_app/utils/s_config.dart';
import 'package:educational_complex_director_app/view/components/confirmation_dialog.dart';
import 'package:educational_complex_director_app/view/components/error_dialog.dart';
import 'package:educational_complex_director_app/view/components/loading_dialog.dart';
import 'package:educational_complex_director_app/view/components/select_school_and_designation_dialog.dart';
import 'package:educational_complex_director_app/view/pages/teacherspage/teacher_info_form.dart';
import 'package:educational_complex_director_app/view_model/bread_crumb_notifier.dart';
import 'package:educational_complex_director_app/view_model/teacher/teacher_details.dart';
import 'package:educational_complex_director_app/view_model/user.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class TeacherDetailsPage extends ConsumerWidget {
  const TeacherDetailsPage({super.key, required this.teacherId});
  final String teacherId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SConfig.init(context);
    final teacherDetails = ref.watch(teacherDetailsNotifierProvider(teacherId));
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          // ── Back button ───────────────────────────────────────────
          IconButton.filled(
            icon: const Icon(Icons.arrow_back_rounded),
            iconSize: 28,
            style: IconButton.styleFrom(
              backgroundColor: SConfig.primaryColor.withAlpha(20),
              foregroundColor: SConfig.primaryColor,
            ),
            onPressed: () {
              ref.read(teachersBreadcrumbProvider.notifier).pop();
              Get.back(id: Sroutes.teachersNavigationId);
            },
          ),
          const SizedBox(height: 10),
          ...teacherDetails.when(
            data: (data) => [
              SizedBox(
                width: double.infinity,
                child: _teacherHeader(context, data),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: TeacherInfoForm(
                  details: data,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: _schoolAndAcademicInfo(context, data, ref),
              ),
            ],
            error: (error, stackTrace) => [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,

                child: Center(
                  child: ErrorDialog(
                    message: error.toString(),
                    blur: 0,
                  ),
                ),
              ),
            ],
            loading: () => [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,

                child: Center(
                  child: LoadingAnimationWidget.beat(
                    color: SConfig.primaryColor.withGreen(150),
                    size: 90,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ===========================
  /// SIDE INFO PANEL
  /// ===========================
  Widget _teacherHeader(BuildContext context, TeacherDetails details) {
    final loc = AppLocalizations.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [
              SConfig.accentColor.withRed(50),
              SConfig.secondaryBackground,
            ],
          ),
        ),

        /// DESKTOP
        child: SConfig.isDesktop()
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// LEFT SIDE
                  Expanded(
                    child: Row(
                      children: [
                        const SizedBox(width: 20),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              details.teacher.fullName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 6),
                            Text(
                              "${loc!.school}: ${details.school?.name}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              "${details.designation.localizedName(loc)} • ${details.teacher.countryName}",
                              style: const TextStyle(color: Colors.white70),
                            ),

                            const SizedBox(height: 14),

                            Wrap(
                              spacing: 12,
                              children: [
                                _headerChip(
                                  Icons.badge,
                                  details.teacher.registrationNumber,
                                ),

                                _headerChip(
                                  Icons.school,
                                  details.teacher.qualificationName.loc(loc),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// RIGHT SIDE (DESCRIPTION)
                ],
              )
            /// MOBILE / TABLET
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        details.teacher.fullName,

                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "${loc!.school}: ${details.school?.name}",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 6),

                      Text(
                        "${details.designation.localizedName(loc)} • ${details.teacher.countryName}",
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _headerChip(
                        Icons.badge,
                        details.teacher.registrationNumber,
                      ),

                      _headerChip(
                        Icons.school,
                        details.teacher.qualificationName.loc(loc),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget _headerChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(50),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoColumn(String label, String value, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: SConfig.textDark.withAlpha(150),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: SConfig.textDark,
          ),
        ),
      ],
    );
  }

  Widget _schoolAndAcademicInfo(
    BuildContext context,
    TeacherDetails details,
    WidgetRef ref,
  ) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final double itemWidth = SConfig.isMobile() ? double.infinity : 220;
    final double largeItemWidth = SConfig.isMobile() ? double.infinity : 280;
    final isDirector =
        ref.watch(userViewModelProvider).value?.isDirector ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// TOP ACTIONS
        if (isDirector)
          SizedBox(
            width: double.infinity,
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: SConfig.isMobile()
                  ? WrapAlignment.start
                  : WrapAlignment.end,
              children: details.school != null
                  ? [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SConfig.primaryColor.withAlpha(20),
                          foregroundColor: SConfig.primaryColor,
                          elevation: 0,
                          shadowColor: Colors.transparent,

                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(
                          Icons.transfer_within_a_station,
                          size: 20,
                        ),
                        label: Text(
                          loc.transferTeacherToAnotherSchool,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          await handleChangingAndAssigningTeacherSchool(
                            ref,
                            context,
                            details,
                          );
                        },
                      ),
                    ]
                  : [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SConfig.primaryColor.withAlpha(20),
                          foregroundColor: SConfig.primaryColor,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.person_remove, size: 20),
                        label: Text(
                          loc.assignTeacherToSchool,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          await handleChangingAndAssigningTeacherSchool(
                            ref,
                            context,
                            details,
                            true,
                          );
                        },
                      ),
                    ],
            ),
          ),

        const SizedBox(height: 24),

        /// UNIFIED INFO CONTAINER
        if (details.school != null)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: SConfig.secondaryBackground.withAlpha(40),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// SCHOOL HEADER
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: SConfig.secondaryBackground.withAlpha(20),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.domain, color: SConfig.primaryColor),
                      const SizedBox(width: 12),
                      Text(
                        loc.schoolInformation,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                /// SCHOOL INFO BODY
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    children: [
                      SizedBox(
                        width: largeItemWidth,
                        child: _infoColumn(
                          loc.schoolName,
                          details.school!.name,
                          context,
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: _infoColumn(
                          loc.emisNumber,
                          details.school!.emisNumber,
                          context,
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: _infoColumn(
                          loc.schoolType,
                          SchoolTypeEnum.values
                              .firstWhere(
                                (e) => e.name == details.school!.schoolType,
                                orElse: () => SchoolTypeEnum.Basic,
                              )
                              .loc(loc),
                          context,
                        ),
                      ),
                      SizedBox(
                        width: largeItemWidth,
                        child: _infoColumn(
                          loc.schoolEmail,
                          details.school!.email,
                          context,
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: _infoColumn(
                          loc.phone,
                          details.school!.phone,
                          context,
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: _infoColumn(
                          loc.address,
                          details.school!.address,
                          context,
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: _infoColumn(
                          loc.cityId,
                          details.school!.cityName,
                          context,
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: _infoColumn(
                          loc.stateId,
                          details.school!.stateName,
                          context,
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(
                  height: 1,
                  color: SConfig.secondaryBackground.withAlpha(40),
                ),

                /// ACADEMIC YEAR HEADER
                // Container(
                //   padding: const EdgeInsets.symmetric(
                //     horizontal: 24,
                //     vertical: 16,
                //   ),
                //   color: SConfig.accentColor.withAlpha(15),
                //   child: Row(
                //     children: [
                //       const Icon(Icons.date_range, color: SConfig.accentColor),
                //       const SizedBox(width: 12),
                //       Text(
                //         loc.academicYearInfo,
                //         style: theme.textTheme.titleMedium?.copyWith(
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                // /// ACADEMIC YEAR BODY
                // Padding(
                //   padding: const EdgeInsets.all(24),
                //   child: Wrap(
                //     spacing: 24,
                //     runSpacing: 24,
                //     children: [
                //       SizedBox(
                //         width: largeItemWidth,
                //         child: _infoColumn(
                //           loc.academicYear,
                //           details.academicYear.name,
                //           context,
                //         ),
                //       ),
                //       SizedBox(
                //         width: itemWidth,
                //         child: _infoColumn(
                //           loc.startDate,
                //           details.academicYear.startDate
                //               .toLocal()
                //               .toString()
                //               .split(' ')[0],
                //           context,
                //         ),
                //       ),
                //       SizedBox(
                //         width: itemWidth,
                //         child: _infoColumn(
                //           loc.endDate,
                //           details.academicYear.endDate
                //               .toLocal()
                //               .toString()
                //               .split(
                //                 ' ',
                //               )[0],
                //           context,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> handleChangingAndAssigningTeacherSchool(
    WidgetRef ref,
    BuildContext context,
    TeacherDetails details, [
    bool? isAssigningSchool,
  ]) async {
    final loc = AppLocalizations.of(context)!;
    final notifier = ref.read(
      teacherDetailsNotifierProvider(teacherId).notifier,
    );
    final Map<String, dynamic>? selectedSchoolAndDesignation =
        await Get.dialog<Map<String, dynamic>>(
          const SelectSchoolAndDesignationDialog(
            isSchoolOnly: false,
          ),
        );
    if (selectedSchoolAndDesignation != null) {
      final bool? confirmed = await Get.dialog<bool>(
        ConfirmationDialog(
          message: loc.confirmAction,
          onConfirm: () => Get.back<bool>(result: true),
        ),
        barrierDismissible: false,
      );

      if (confirmed != true) return;

      final success = await Get.showOverlay<bool>(
        asyncFunction: () async {
          // await Future.delayed(const Duration(seconds: 1));

          if (isAssigningSchool == true) {
            await notifier.assignTeacherToSchool(
              selectedSchoolAndDesignation['schoolId'],

              selectedSchoolAndDesignation['designation'],
            );
          } else {
            await notifier.changeTeacherSchool(
              selectedSchoolAndDesignation['schoolId'],

              selectedSchoolAndDesignation['designation'],
            );
          }
          await notifier.changeTeacherSchool(
            selectedSchoolAndDesignation['schoolId'],

            selectedSchoolAndDesignation['designation'],
          );

          return notifier.error == null;
        },
        loadingWidget: LoadingDialog(
          extraMessage: loc.savingForm,
          loading: LoadingAnimationWidget.discreteCircle(
            color: SConfig.secondaryBackground,
            secondRingColor: SConfig.accentColor,
            thirdRingColor: SConfig.primaryColor,
            size: 90,
          ),
        ),
      );
      if (!success) {
        await Get.dialog<void>(
          ErrorDialog(message: loc.errorOccurred),
          barrierDismissible: false,
        );
      }
    }
  }
}

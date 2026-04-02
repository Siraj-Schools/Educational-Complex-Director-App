import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/models/constants/school_types.dart';
// ignore: unused_import

import 'package:educational_complex_director_app/models/school/school_details.dart';
import 'package:educational_complex_director_app/routes/routes.dart';
import 'package:educational_complex_director_app/utils/s_config.dart';
import 'package:educational_complex_director_app/view/components/error_dialog.dart';
import 'package:educational_complex_director_app/view/pages/schoolspage/school_info_form.dart';
import 'package:educational_complex_director_app/view_model/bread_crumb_notifier.dart';
import 'package:educational_complex_director_app/view_model/school/school_details.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SchoolDetailsPage extends ConsumerWidget {
  const SchoolDetailsPage({super.key, required this.schoolId});
  final String schoolId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SConfig.init(context);
    final schoolDetails = ref.watch(schoolDetailsNotifierProvider(schoolId));
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
              ref.read(schoolsBreadcrumbProvider.notifier).pop();
              Get.back(id: Sroutes.schoolsNavigationId);
            },
          ),
          const SizedBox(height: 10),

          ...schoolDetails.when(
            data: (data) => [
              SizedBox(
                width: double.infinity,
                child: _schoolHeader(context, data),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: SchoolInfoForm(
                  details: data,
                ),
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
                    color: SConfig.primaryColor,
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
  Widget _schoolHeader(BuildContext context, SchoolDetails details) {
    final description = details.details;
    final loc = AppLocalizations.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [
              SConfig.primaryColor,
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
                              details.school.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              "${SchoolTypeEnum.values.firstWhere(
                                (element) => element.name == details.school.schoolType,
                              ).loc(loc!)} • ${details.school.cityName}",
                              style: const TextStyle(color: Colors.white70),
                            ),

                            const SizedBox(height: 14),
                            if (details.manager != null)
                              Wrap(
                                spacing: 12,
                                children: [
                                  _headerChip(
                                    Icons.badge,
                                    details.manager!.registrationNumber,
                                  ),

                                  _headerChip(
                                    Icons.person,
                                    details.manager!.fullName,
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// RIGHT SIDE (DESCRIPTION)
                  if (description.isNotEmpty)
                    SizedBox(
                      width: 340,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: description.map((e) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    e,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
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
                        details.school.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "${SchoolTypeEnum.values.firstWhere(
                          (element) => element.name == details.school.schoolType,
                        ).loc(loc!)} • ${details.school.cityName}",
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  if (details.manager != null)
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _headerChip(
                          Icons.badge,
                          details.manager!.registrationNumber,
                        ),

                        _headerChip(
                          Icons.person,
                          details.manager!.fullName,
                        ),
                      ],
                    ),

                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    ExpandableDescriptionList(texts: description),
                  ],
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
}

class ExpandableDescriptionList extends StatefulWidget {
  final List<String> texts;

  const ExpandableDescriptionList({super.key, required this.texts});

  @override
  State<ExpandableDescriptionList> createState() =>
      _ExpandableDescriptionListState();
}

class _ExpandableDescriptionListState extends State<ExpandableDescriptionList> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final isDesktop = SConfig.isDesktop();

    final visibleTexts = expanded || isDesktop
        ? widget.texts
        : widget.texts.take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...visibleTexts.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 18,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    e,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withAlpha(230),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        if (!isDesktop && widget.texts.length > 2)
          TextButton(
            onPressed: () => setState(() => expanded = !expanded),
            child: Text(
              expanded ? "Show less" : "Read more",
              style: const TextStyle(color: Colors.white70),
            ),
          ),
      ],
    );
  }
}

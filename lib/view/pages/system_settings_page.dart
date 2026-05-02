import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/models/system_settings.dart';
import 'package:educational_complex_director_app/utils/s_config.dart';
import 'package:educational_complex_director_app/view/components/add_academic_year_dialog.dart';
import 'package:educational_complex_director_app/view/components/confirmation_dialog.dart';
import 'package:educational_complex_director_app/view/components/error_dialog.dart';
import 'package:educational_complex_director_app/view/components/loading_dialog.dart';
import 'package:educational_complex_director_app/view/components/select_academic_year_dialog.dart';
import 'package:educational_complex_director_app/view/components/add_button.dart';

import 'package:educational_complex_director_app/view_model/system_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SystemSettingsPage extends ConsumerWidget {
  const SystemSettingsPage({super.key});

  Future<void> _updateField(
    WidgetRef ref,
    Future<void> Function() action,
    AppLocalizations loc,
  ) async {
    final bool? confirmed = await Get.dialog<bool>(
      ConfirmationDialog(
        message: loc.confirmAction,
        onConfirm: () => Get.back<bool>(result: true),
      ),
      barrierDismissible: false,
    );
    if (confirmed != true) return;

    final succes = await Get.showOverlay<bool>(
      asyncFunction: () async {
        await action();
        return ref.read(systemSettingsProvider.notifier).error == null;
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

    if (!succes) {
      Get.snackbar(
        loc.errorOccurred,
        ref.read(systemSettingsProvider.notifier).error.toString(),
        backgroundColor: SConfig.errorColor,
        colorText: Colors.white,
      );
    } else {
      await ref.read(systemSettingsProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final state = ref.watch(systemSettingsProvider);

    return state.when(
      data: (settings) {
        return RefreshIndicator(
          onRefresh: () => ref.read(systemSettingsProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: AddButton(
                  onPressed: () {
                    Get.dialog(const AddAcademicYearDialog());
                  },
                  label: loc.addAcademicYear,
                  accent: SConfig.primaryColor,
                ),
              ),
              SConfig.spaceMedium,
              _buildSettingRow(
                context,
                title: loc.currentAcademicYear,
                value: settings.currentAcademicYearName,
                onEdit: () async {
                  final newId = await Get.dialog<String>(
                    const SelectAcademicYearDialog(),
                  );
                  if (newId != null) {
                    _updateField(
                      ref,
                      () => ref
                          .read(systemSettingsProvider.notifier)
                          .updateCurrentAcademicYear(academicYearId: newId),
                      loc,
                    );
                  }
                },
                loc: loc,
              ),
              SConfig.spaceSmall,
              _buildSettingRow(
                context,
                title: loc.nextAcademicYear,
                value: settings.nextAcademicYearName,
                onEdit: () async {
                  final newId = await Get.dialog<String>(
                    const SelectAcademicYearDialog(),
                  );
                  if (newId != null) {
                    _updateField(
                      ref,
                      () => ref
                          .read(systemSettingsProvider.notifier)
                          .updateNextAcademicYear(academicYearId: newId),
                      loc,
                    );
                  }
                },
                loc: loc,
              ),
              SConfig.spaceSmall,
              _buildChapterToggleRow(
                context,
                title: loc.currentChapter,
                isFirstChapter:
                    settings.currentChapterId == SystemSettings.firstChapterId,
                onChanged: (isFirst) async {
                  final newId = isFirst
                      ? SystemSettings.firstChapterId
                      : SystemSettings.secondChapterId;
                  _updateField(
                    ref,
                    () => ref
                        .read(systemSettingsProvider.notifier)
                        .updateCurrentChapter(chapterId: newId),
                    loc,
                  );
                },
                loc: loc,
              ),
              SConfig.spaceSmall,
              _buildToggleRow(
                context,
                title: loc.isPromotion,
                value: settings.isPromotion,
                onChanged: (val) async {
                  _updateField(
                    ref,
                    () => ref
                        .read(systemSettingsProvider.notifier)
                        .updatePromotionStatus(isPromotion: val),
                    loc,
                  );
                },
                loc: loc,
              ),
              SConfig.spaceSmall,
              _buildToggleRow(
                context,
                title: loc.isChapterPromotion,
                value: settings.isChapterPromotion,
                onChanged: (val) async {
                  _updateField(
                    ref,
                    () => ref
                        .read(systemSettingsProvider.notifier)
                        .updateChapterPromotionStatus(
                          isChapterPromotion: val,
                        ),
                    loc,
                  );
                },
                loc: loc,
              ),
            ],
          ),
        );
      },
      error: (error, stack) {
        return Center(
          child: ErrorDialog(
            message: loc.errorOccurred,
            blur: 0,
            okText: loc.retry,
            onOK: () async {
              await ref.read(systemSettingsProvider.notifier).refresh();
            },
          ),
        );
      },
      loading: () {
        return Center(
          child: LoadingAnimationWidget.hexagonDots(
            color: SConfig.accentColor.withAlpha(180),
            size: 90,
          ),
        );
      },
    );
  }

  Widget _buildSettingRow(
    BuildContext context, {
    required String title,
    required String value,
    required VoidCallback onEdit,
    required AppLocalizations loc,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: SConfig.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: SConfig.accentColor),
              tooltip: loc.edit,
              onPressed: onEdit,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleRow(
    BuildContext context, {
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required AppLocalizations loc,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: SConfig.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Transform.scale(
              scale: 0.9,
              child: Switch(
                value: value,
                onChanged: onChanged,
                activeThumbColor: Colors.white,
                inactiveThumbColor: Colors.white,
                activeTrackColor: SConfig.successColor,
                inactiveTrackColor: SConfig.errorColor.withAlpha(200),
                trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                thumbIcon: WidgetStateProperty.all(
                  const Icon(Icons.circle, color: Colors.transparent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChapterToggleRow(
    BuildContext context, {
    required String title,
    required bool isFirstChapter,
    required ValueChanged<bool> onChanged,
    required AppLocalizations loc,
  }) {
    return Card(
      elevation: 2,
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(2)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: SConfig.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 36,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withAlpha(50)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => onChanged(true),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: isFirstChapter
                            ? SConfig.primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: isFirstChapter
                            ? [
                                BoxShadow(
                                  color: SConfig.primaryColor.withAlpha(60),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        loc.chapter1,
                        style: TextStyle(
                          color: isFirstChapter
                              ? Colors.white
                              : (Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade700),
                          fontWeight: isFirstChapter
                              ? FontWeight.bold
                              : FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => onChanged(false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: !isFirstChapter
                            ? SConfig.primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: !isFirstChapter
                            ? [
                                BoxShadow(
                                  color: SConfig.primaryColor.withAlpha(60),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        loc.chapter2,
                        style: TextStyle(
                          color: !isFirstChapter
                              ? Colors.white
                              : (Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade700),
                          fontWeight: !isFirstChapter
                              ? FontWeight.bold
                              : FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

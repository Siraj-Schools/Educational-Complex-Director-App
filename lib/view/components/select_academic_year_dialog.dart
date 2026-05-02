import 'dart:ui';
import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/utils/s_config.dart';
import 'package:educational_complex_director_app/view/components/error_dialog.dart';
import 'package:educational_complex_director_app/view_model/academic_year.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SelectAcademicYearDialog extends ConsumerWidget {
  const SelectAcademicYearDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final academicYearsState = ref.watch(academicYearProvider);

    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(
            color: isDark
                ? SConfig.secondaryBackground.withAlpha(64)
                : Colors.white.withAlpha(200),
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
              Text(
                loc.selectAcademicYear,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              SConfig.spaceMedium,
              academicYearsState.when(
                data: (years) {
                  if (years.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(loc.noDataFound),
                    );
                  }
                  return Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: years.length,
                      itemBuilder: (context, index) {
                        final year = years[index];
                        return Card(
                          elevation: 1,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(
                              year.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "${year.startDate.toString().split(' ')[0]} - ${year.endDate.toString().split(' ')[0]}",
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                            onTap: () {
                              Get.back(result: year.id);
                            },
                          ),
                        );
                      },
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
                        await ref.read(academicYearProvider.notifier).refresh();
                      },
                    ),
                  );
                },
                loading: () {
                  return Center(
                    child: LoadingAnimationWidget.hexagonDots(
                      color: SConfig.secondaryBackground.withAlpha(180),
                      size: 90,
                    ),
                  );
                },
              ),
              SConfig.spaceMedium,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.transparent,
                    backgroundColor: SConfig.errorColor.withAlpha(200),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => Get.back(),
                  child: Text(loc.cancel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:ui';
import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/utils/s_config.dart';
import 'package:educational_complex_director_app/view/components/confirmation_dialog.dart';
import 'package:educational_complex_director_app/view/components/loading_dialog.dart';
import 'package:educational_complex_director_app/view_model/academic_year.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AddAcademicYearDialog extends ConsumerStatefulWidget {
  const AddAcademicYearDialog({super.key});

  @override
  ConsumerState<AddAcademicYearDialog> createState() =>
      _AddAcademicYearDialogState();
}

class _AddAcademicYearDialogState extends ConsumerState<AddAcademicYearDialog> {
  final _formKey = GlobalKey<FormState>();

  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart
          ? DateTime.now()
          : _startDate?.add(const Duration(days: 365)) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: SConfig.primaryColor,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = _startDate!.add(const Duration(days: 365));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _submit(AppLocalizations loc) async {
    if (_formKey.currentState!.validate() &&
        _startDate != null &&
        _endDate != null) {
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
          await ref
              .read(academicYearProvider.notifier)
              .createAcademicYear(
                startDate: _startDate!,
                endDate: _endDate!,
              );
          return ref.read(academicYearProvider.notifier).error == null;
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
          ref.read(academicYearProvider.notifier).error.toString(),
          backgroundColor: SConfig.errorColor,
          colorText: Colors.white,
        );
      } else {
        await ref.read(academicYearProvider.notifier).refresh();
        Get.back();
      }
    }
  }

  Widget _buildDatePickerCard(
    BuildContext context,
    String label,
    DateTime? date,
    bool isStart,
  ) {
    return InkWell(
      onTap: () => _selectDate(context, isStart),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: SConfig.primaryColor.withAlpha(50)),
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today,
              color: SConfig.primaryColor,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date == null ? "" : date.toString().split(' ')[0],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
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

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 380),
          decoration: BoxDecoration(
            color: isDark
                ? SConfig.secondaryBackground.withAlpha(200)
                : Colors.white.withAlpha(240),
            borderRadius: BorderRadius.circular(24),
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
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: SConfig.primaryColor.withAlpha(20),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: SConfig.primaryColor.withAlpha(40),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.school,
                        color: SConfig.primaryColor,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      loc.addAcademicYear,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),

              // Body
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildDatePickerCard(
                        context,
                        loc.startDate,
                        _startDate,
                        true,
                      ),
                      if (_startDate == null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "${loc.startDate} ${loc.required}",
                              style: const TextStyle(
                                color: SConfig.errorColor,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 16),
                      _buildDatePickerCard(
                        context,
                        loc.endDate,
                        _endDate,
                        false,
                      ),

                      if (_endDate == null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "${loc.endDate} ${loc.required}",
                              style: const TextStyle(
                                color: SConfig.errorColor,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 32),

                      // Actions
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.grey.shade700,
                                side: BorderSide(color: Colors.grey.shade300),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () => Get.back(),
                              child: Text(loc.cancel),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: SConfig.primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () async => await _submit(loc),
                              child: Text(loc.save),
                            ),
                          ),
                        ],
                      ),
                    ],
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

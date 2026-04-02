import 'dart:async';
import 'dart:ui';

import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/models/constants/school_types.dart';
import 'package:educational_complex_director_app/models/constants/teacher_designation.dart';
import 'package:educational_complex_director_app/utils/s_config.dart';
import 'package:educational_complex_director_app/view/components/error_dialog.dart';
import 'package:educational_complex_director_app/view_model/school/schools.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';

class SelectSchoolAndDesignationDialog extends ConsumerStatefulWidget {
  const SelectSchoolAndDesignationDialog({
    super.key,
    required this.isSchoolOnly,
  });
  final bool isSchoolOnly;
  @override
  ConsumerState<SelectSchoolAndDesignationDialog> createState() =>
      _SelectSchoolAndDesignationDialogState();
}

class _SelectSchoolAndDesignationDialogState
    extends ConsumerState<SelectSchoolAndDesignationDialog> {
  String? _selectedSchoolId;
  String? _selectedSchoolName;
  TeacherDesignation? _selectedDesignation;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final schoolsAsync = ref.watch(schoolsNotifierProvider(false));
    final notifier = ref.read(schoolsNotifierProvider(false).notifier);
    final searchQuery = notifier.searchQuery;
    if (_searchController.text != searchQuery) {
      _searchController.value = TextEditingValue(
        text: searchQuery,
        selection: TextSelection.collapsed(offset: searchQuery.length),
      );
    }

    SConfig.init(context);

    return Dialog(
      backgroundColor: SConfig.primaryColor,
      elevation: 0,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 550),
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
                widget.isSchoolOnly
                    ? loc.selectSchool
                    : loc.selectSchoolAndDesignation,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: SConfig.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              if (!widget.isSchoolOnly) ...[
                DropdownButtonFormField<TeacherDesignation>(
                  menuMaxHeight: 300,
                  initialValue: _selectedDesignation,
                  decoration: InputDecoration(
                    labelText: loc.selectDesignation,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  items: TeacherDesignation.values
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.localizedName(loc)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDesignation = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  onChanged: (value) async {
                    _debounce?.cancel();
                    _debounce = Timer(
                      const Duration(milliseconds: 400),
                      () async {
                        await notifier.search(_searchController.text);
                      },
                    );
                  },
                  decoration: InputDecoration(
                    hintText: loc.searchSchool,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: SConfig.primaryColor,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification.metrics.pixels >=
                          notification.metrics.maxScrollExtent * 0.8 &&
                      !notifier.isLoadingMore &&
                      notifier.errorLoadingMore == null &&
                      notifier.hasNextPage) {
                    notifier.loadMore();
                  }
                  return false;
                },
                child: Expanded(
                  child: schoolsAsync.when(
                    data: (schools) {
                      if (schools.isEmpty) {
                        return Center(
                          child: Text(
                            loc.noDataFound,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount:
                            schools.length +
                            ((notifier.isLoadingMore ||
                                    notifier.errorLoadingMore != null)
                                ? 1
                                : 0),
                        itemBuilder: (context, index) {
                          if (index < schools.length) {
                            final school = schools[index];
                            final isSelected = _selectedSchoolId == school.id;

                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected
                                      ? SConfig.accentColor
                                      : SConfig.secondaryBackground,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(14),
                                color: isSelected
                                    ? SConfig.accentColor.withAlpha(20)
                                    : SConfig.successColor.withAlpha(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(10),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                title: Text(
                                  school.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                subtitle: Text(
                                  SchoolTypeEnum.values
                                      .firstWhere(
                                        (element) =>
                                            element.name == school.schoolType,
                                      )
                                      .loc(loc),
                                ),
                                trailing: isSelected
                                    ? const Icon(
                                        Icons.check_circle,
                                        color: SConfig.accentColor,
                                      )
                                    : null,
                                onTap: () {
                                  setState(() {
                                    _selectedSchoolId = school.id;
                                    _selectedSchoolName = school.name;
                                  });
                                },
                              ),
                            );
                          }
                          if (notifier.isLoadingMore) {
                            return SizedBox(
                              width: double.infinity,
                              child: Center(
                                child: LoadingAnimationWidget.waveDots(
                                  color: SConfig.primaryColor,
                                  size: 60,
                                ),
                              ),
                            );
                          }
                          if (notifier.errorLoadingMore != null) {
                            return SizedBox(
                              width: double.infinity,
                              child: Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: SConfig.errorColor,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () async {
                                    await notifier.loadMore();
                                  },
                                  child: Text(loc.retry),
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      );
                    },
                    error: (error, stack) {
                      return Center(
                        child: ErrorDialog(
                          message: error.toString(),
                          blur: 0,
                          okText: loc.retry,
                          onOK: () async {
                            await notifier.refresh();
                          },
                        ),
                      );
                    },
                    loading: () {
                      return Center(
                        child: LoadingAnimationWidget.hexagonDots(
                          color: SConfig.primaryColor,
                          size: 90,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(loc.cancel),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SConfig.successColor,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: widget.isSchoolOnly
                        ? _selectedSchoolId != null
                              ? () {
                                  Get.back(
                                    result: {
                                      'schoolId': _selectedSchoolId,
                                      'schoolName': _selectedSchoolName,
                                    },
                                  );
                                }
                              : null
                        : _selectedSchoolId != null &&
                              _selectedDesignation != null
                        ? () {
                            Get.back(
                              result: {
                                'schoolId': _selectedSchoolId,
                                'designation': _selectedDesignation,
                              },
                            );
                          }
                        : null,
                    child: Text(loc.confirm),
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

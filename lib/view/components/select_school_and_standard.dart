import 'dart:async';
import 'dart:ui';

import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/models/constants/school_types.dart';
import 'package:educational_complex_director_app/models/school/standard.dart';
// ignore: unused_import
import 'package:educational_complex_director_app/services/log_services.dart';
import 'package:educational_complex_director_app/utils/s_config.dart';
import 'package:educational_complex_director_app/view/components/error_dialog.dart';
import 'package:educational_complex_director_app/view_model/school/schools.dart';
import 'package:educational_complex_director_app/view_model/school/standards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SelectSchoolAndStandardDialog extends ConsumerStatefulWidget {
  const SelectSchoolAndStandardDialog({super.key});

  @override
  ConsumerState<SelectSchoolAndStandardDialog> createState() =>
      _SelectSchoolAndStandardDialogState();
}

class _SelectSchoolAndStandardDialogState
    extends ConsumerState<SelectSchoolAndStandardDialog> {
  int _step = 0; // 0 for school selection, 1 for standard selection
  String? _selectedSchoolId;
  String? _selectedSchoolName;
  String? _selectedStandardId;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _standardSearchController =
      TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _standardSearchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    SConfig.init(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450, maxHeight: 600),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(245),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: SConfig.primaryColor.withAlpha(40),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(40),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.05, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: _step == 0
                ? _buildSchoolStep(context, loc)
                : _buildStandardStep(context, loc),
          ),
        ),
      ),
    );
  }

  Widget _buildSchoolStep(BuildContext context, AppLocalizations loc) {
    final schoolsAsync = ref.watch(schoolsNotifierProvider(false));
    final notifier = ref.read(schoolsNotifierProvider(false).notifier);
    final searchQuery = notifier.searchQuery;

    if (_searchController.text != searchQuery) {
      _searchController.value = TextEditingValue(
        text: searchQuery,
        selection: TextSelection.collapsed(offset: searchQuery.length),
      );
    }

    return Padding(
      key: const ValueKey('school_step'),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          _buildHeader(loc.selectSchool, Icons.school_rounded),
          const SizedBox(height: 20),
          _buildSearchField(
            _searchController,
            loc.searchSchool,
            (value) {
              _debounce?.cancel();
              _debounce = Timer(const Duration(milliseconds: 500), () async {
                await notifier.search(value);
              });
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: schoolsAsync.when(
              data: (schools) => schools.isEmpty
                  ? _buildEmptyState(loc.noDataFound)
                  : _buildSchoolList(schools, notifier, loc),
              error: (err, stack) => _buildErrorState(err.toString(), () async {
                await notifier.refresh();
              }, loc),
              loading: () => _buildLoadingState(),
            ),
          ),
          const SizedBox(height: 16),
          _buildFooterButtons(
            onCancel: () => Get.back(),
            onNext: _selectedSchoolId != null
                ? () => setState(() => _step = 1)
                : null,
            nextText: loc.next,
            cancelText: loc.cancel,
          ),
        ],
      ),
    );
  }

  Widget _buildStandardStep(BuildContext context, AppLocalizations loc) {
    final standardsAsync = ref.watch(
      standardsNotifierProvider(_selectedSchoolId!),
    );

    return Padding(
      key: const ValueKey('standard_step'),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          _buildHeader(loc.selectStandard, Icons.class_rounded),
          const SizedBox(height: 20),
          _buildSearchField(
            _standardSearchController,
            loc.searchStandard,
            (value) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: standardsAsync.when(
              data: (standards) {
                final filtered = standards
                    .where(
                      (s) => s.name.toLowerCase().contains(
                        _standardSearchController.text.toLowerCase(),
                      ),
                    )
                    .toList();
                return filtered.isEmpty
                    ? _buildEmptyState(loc.noDataFound)
                    : _buildStandardList(filtered, loc);
              },
              error: (err, stack) => _buildErrorState(err.toString(), () {
                ref.invalidate(standardsNotifierProvider(_selectedSchoolId!));
              }, loc),
              loading: () => _buildLoadingState(),
            ),
          ),
          const SizedBox(height: 16),
          _buildFooterButtons(
            onCancel: () => setState(() => _step = 0),
            onNext: _selectedStandardId != null
                ? () {
                    Get.back<Map<String, String>>(
                      result: {
                        'schoolId': _selectedSchoolId!,
                        'standardId': _selectedStandardId!,
                        'schoolName': _selectedSchoolName!,
                      },
                    );
                  }
                : null,
            nextText: loc.confirm,
            cancelText: loc.back,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: SConfig.primaryColor, size: 28),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: SConfig.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField(
    TextEditingController controller,
    String hint,
    ValueChanged<String> onChanged,
  ) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search, color: SConfig.primaryColor),
        filled: true,
        fillColor: SConfig.primaryColor.withAlpha(10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSchoolList(
    List<dynamic> schools,
    SchoolsNotifier notifier,
    AppLocalizations loc,
  ) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels >=
                notification.metrics.maxScrollExtent * 0.8 &&
            !notifier.isLoadingMore &&
            notifier.hasNextPage) {
          notifier.loadMore();
        }
        return false;
      },
      child: ListView.builder(
        itemCount: schools.length + (notifier.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < schools.length) {
            final school = schools[index];
            final isSelected = _selectedSchoolId == school.id;
            return _buildSelectionItem(
              title: school.name,
              subtitle: SchoolTypeEnum.values
                  .firstWhere((e) => e.name == school.schoolType)
                  .loc(loc),
              isSelected: isSelected,
              onTap: () => setState(() {
                _selectedSchoolId = school.id;
                _selectedSchoolName = school.name;
              }),
            );
          }
          return _buildLoadingMoreIndicator();
        },
      ),
    );
  }

  Widget _buildStandardList(List<Standard> standards, AppLocalizations loc) {
    return ListView.builder(
      itemCount: standards.length,
      itemBuilder: (context, index) {
        final standard = standards[index];
        final isSelected = _selectedStandardId == standard.id;
        return _buildSelectionItem(
          title: standard.name,
          subtitle: standard.type,
          isSelected: isSelected,
          onTap: () => setState(() => _selectedStandardId = standard.id),
        );
      },
    );
  }

  Widget _buildSelectionItem({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected ? SConfig.primaryColor.withAlpha(15) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected ? SConfig.primaryColor : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? SConfig.primaryColor : Colors.black87,
          ),
        ),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: SConfig.primaryColor)
            : null,
        onTap: onTap,
      ),
    );
  }

  Widget _buildFooterButtons({
    required VoidCallback onCancel,
    required VoidCallback? onNext,
    required String nextText,
    required String cancelText,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: onCancel,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(cancelText),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: SConfig.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              nextText,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(message, style: TextStyle(color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget _buildErrorState(
    String error,
    VoidCallback onRetry,
    AppLocalizations loc,
  ) {
    return Center(
      child: ErrorDialog(
        message: error,
        blur: 0,
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: LoadingAnimationWidget.inkDrop(
        color: SConfig.primaryColor,
        size: 50,
      ),
    );
  }

  Widget _buildLoadingMoreIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: LoadingAnimationWidget.hexagonDots(
          color: SConfig.primaryColor,
          size: 90,
        ),
      ),
    );
  }
}

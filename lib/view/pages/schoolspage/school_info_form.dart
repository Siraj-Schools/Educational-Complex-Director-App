import 'dart:async';

import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/models/constants/gender.dart';
import 'package:educational_complex_director_app/models/constants/marital_status.dart';
import 'package:educational_complex_director_app/models/constants/school_types.dart';
import 'package:educational_complex_director_app/models/geography.dart';
import 'package:educational_complex_director_app/models/school/school_details.dart';
import 'package:educational_complex_director_app/routes/routes.dart';

import 'package:educational_complex_director_app/utils/s_config.dart';
import 'package:educational_complex_director_app/view/components/confirmation_dialog.dart';
import 'package:educational_complex_director_app/view/components/error_dialog.dart';
import 'package:educational_complex_director_app/view/components/loading_dialog.dart';
import 'package:educational_complex_director_app/view/components/select_manager_dialog.dart';
import 'package:educational_complex_director_app/view_model/Geography/cities.dart';
import 'package:educational_complex_director_app/view_model/Geography/countries.dart';
import 'package:educational_complex_director_app/view_model/Geography/states.dart';
import 'package:educational_complex_director_app/view_model/bread_crumb_notifier.dart';
import 'package:educational_complex_director_app/view_model/school/school_details.dart';
import 'package:educational_complex_director_app/view_model/school/schools.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SchoolInfoForm extends ConsumerStatefulWidget {
  final SchoolDetails? details;

  const SchoolInfoForm({
    super.key,
    this.details,
  });

  @override
  ConsumerState<SchoolInfoForm> createState() => _SchoolInfoFormState();
}

class _SchoolInfoFormState extends ConsumerState<SchoolInfoForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    name.dispose();
    schoolEmail.dispose();
    phone.dispose();
    address.dispose();
    emis.dispose();
    managerEmail.dispose();
    username.dispose();
    password.dispose();
    nationalId.dispose();
    firstName.dispose();
    middleName.dispose();
    lastName.dispose();
    managerPhone.dispose();
    debounce?.cancel();
    super.dispose();
  }

  // ── Controllers ─────────────────────────────────────────────────────────────
  late TextEditingController name;
  late TextEditingController schoolEmail;
  late TextEditingController phone;
  late TextEditingController address;
  late TextEditingController emis;

  late TextEditingController managerEmail;
  late TextEditingController username;
  late TextEditingController password;
  late TextEditingController nationalId;
  late TextEditingController firstName;
  late TextEditingController middleName;
  late TextEditingController lastName;
  late TextEditingController managerPhone;

  String schoolStateId = '11111111-1111-1111-1111-111111111112';
  String schoolCityId = '11111111-1111-1111-1111-111111110201';

  String managerCountryId = '11111111-1111-1111-1111-111111111111';
  String managerStateId = '11111111-1111-1111-1111-111111111112';
  String managerCityId = '11111111-1111-1111-1111-111111110201';
  int selectedSchoolType = 1;

  int selectedGender = 1;
  int selectedMarital = 1;
  DateTime? dateOfBirth;

  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$');
  final phoneRegex = RegExp(r'^[0-9]{7,15}$');
  late final bool isAdding;
  bool isSchoolEditing = false;
  bool isManagerEditing = false;
  bool isSomethingEdited = false;
  Timer? debounce;

  @override
  void initState() {
    super.initState();
    final d = widget.details;
    isAdding = d == null;
    isSchoolEditing = isAdding;
    isManagerEditing = isAdding;
    name = TextEditingController(text: d?.school.name ?? '');
    schoolEmail = TextEditingController(text: d?.school.email ?? '');
    phone = TextEditingController(text: d?.school.phone ?? '');
    address = TextEditingController(text: d?.school.address ?? '');
    emis = TextEditingController(text: d?.school.emisNumber ?? '');

    managerEmail = TextEditingController(text: d?.manager?.email ?? '');
    username = TextEditingController(text: d?.manager?.userName ?? '');
    password = TextEditingController(text: '');

    nationalId = TextEditingController(text: d?.manager?.nationalId ?? '');

    firstName = TextEditingController(text: d?.manager?.firstName ?? '');
    middleName = TextEditingController(text: d?.manager?.middleName ?? '');
    lastName = TextEditingController(text: d?.manager?.lastName ?? '');

    managerPhone = TextEditingController(
      text: d?.manager?.mobileNumber ?? '',
    );
    if (!isAdding) {
      if (d!.manager != null) {
        selectedGender = d.manager!.gender.index;
        selectedMarital = d.manager!.maritalStatus.index;
      }
      selectedSchoolType = SchoolTypeEnum.values
          .firstWhere(
            (element) => element.name == d.school.schoolType,
            orElse: () => SchoolTypeEnum.Primary,
          )
          .index;
    }

    dateOfBirth = d?.manager?.dateOfBirth;
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  double _fieldWidth() {
    if (SConfig.isMobile()) return double.infinity;
    if (SConfig.isTablet()) return 300;
    return 340;
  }

  Widget _textField(
    BuildContext context,
    TextEditingController controller,
    String label, {
    required bool enabled,
    TextInputType? keyboard,
    String? hint,
    String? Function(String?)? validator,
  }) {
    final loc = AppLocalizations.of(context)!;
    return SizedBox(
      width: _fieldWidth(),
      child: TextFormField(
        controller: controller,
        onChanged: (value) {
          debounce = Timer(
            const Duration(seconds: 1),
            () => setState(() {
              isSomethingEdited = true;
            }),
          );
        },
        enabled: enabled,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: enabled ? null : SConfig.textDark.withAlpha(160),
        ),
        keyboardType: keyboard,
        validator:
            validator ??
            (v) => (v == null || v.isEmpty) ? '$label ${loc.required}' : null,
        decoration: InputDecoration(
          hintText: hint,
          labelText: label,
        ),
      ),
    );
  }

  Widget _dateField(BuildContext context, {required bool enabled}) {
    final loc = AppLocalizations.of(context)!;
    final String dateText = dateOfBirth == null
        ? ''
        : '${dateOfBirth!.year}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}';

    return SizedBox(
      width: _fieldWidth(),
      child: TextFormField(
        validator: (v) => (v == null || v.isEmpty) ? loc.required : null,

        enabled: enabled,
        readOnly: true,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: enabled ? null : SConfig.textDark.withAlpha(160),
        ),
        controller: TextEditingController(text: dateText),
        decoration: InputDecoration(
          labelText: loc.dateOfBirth,
          suffixIcon: const Icon(
            Icons.calendar_today_rounded,
            color: SConfig.secondaryBackground,
          ),
        ),
        onTap: enabled
            ? () async {
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                  initialDate: dateOfBirth ?? DateTime(2000),
                );
                if (picked != null) setState(() => dateOfBirth = picked);
              }
            : null,
      ),
    );
  }

  Widget buildDropdown({
    required String label,
    required List<Geography> items,
    required String value,
    required bool enabled,
    required Function(String?) onChanged,
  }) {
    return SizedBox(
      width: _fieldWidth(),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        menuMaxHeight: 300,
        isExpanded: true,
        decoration: InputDecoration(labelText: label),
        items: [
          ...items.map(
            (e) => DropdownMenuItem(value: e.id, child: Text(e.name)),
          ),
        ],
        onChanged: enabled ? onChanged : null,
      ),
    );
  }

  Widget buildDropdownEnums({
    required String label,
    required List<DropdownMenuItem<int>> items,
    required int value,
    required bool enabled,
    required Function(int?) onChanged,
  }) {
    return SizedBox(
      width: _fieldWidth(),
      child: DropdownButtonFormField<int>(
        initialValue: value,
        menuMaxHeight: 300,
        isExpanded: true,
        decoration: InputDecoration(labelText: label),
        items: items,
        onChanged: enabled ? onChanged : null,
      ),
    );
  }

  // ── Section card (Teal for School, Orange-ish for Manager) ──────────────
  Widget _sectionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget content,
    bool? isSectionEditing,
    VoidCallback? onEdit,
    VoidCallback? onSave,
    VoidCallback? onCancel,
  }) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: SConfig.primaryColor.withAlpha(50),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Edit/Save/Cancel
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 16, 0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: SConfig.primaryColor.withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: SConfig.primaryColor),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: SConfig.textDark,
                  ),
                ),
                const Spacer(),
                if (!isAdding && onEdit == null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () async {
                          await _handleRemoveManager();
                        },
                        icon: const Icon(
                          Icons.person_remove_rounded,
                          size: 20,
                        ),
                        label: Text(
                          loc.removeManager,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: SConfig.errorColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: SConfig.errorColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await handleChangingManager();
                        },
                        icon: const Icon(
                          Icons.manage_accounts_rounded,
                          size: 20,
                        ),
                        label: Text(
                          loc.changeManager,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SConfig.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ],
                  ),

                if (!isAdding && onEdit != null)
                  if (isSectionEditing == true)
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: isSomethingEdited ? onSave : null,
                          icon: const Icon(Icons.save, size: 18),
                          label: Text(loc.save),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: SConfig.successColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit, size: 18),
                      label: Text(loc.edit),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SConfig.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Divider(
              thickness: 1,
              color: SConfig.secondaryBackground,
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 24, 12, 24),
            child: content,
          ),
        ],
      ),
    );
  }

  // ── Save handlers ─────────────────────────────────────────────────────────────
  Future<void> _handleSave(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final loc = AppLocalizations.of(context)!;

    final bool? confirmed = await Get.dialog<bool>(
      ConfirmationDialog(
        message: loc.confirmAction,
        onConfirm: () => Get.back<bool>(result: true),
      ),
      barrierDismissible: false,
    );

    if (confirmed != true) return;

    final success = await Get.showOverlay<bool>(
      asyncFunction: isAdding
          ? () async {
              final notifier = ref.read(
                schoolsNotifierProvider(true).notifier,
              );

              await notifier.createSchool(
                {
                  "name": name.text,
                  "schoolEmail": schoolEmail.text,
                  "phone": phone.text,
                  "address": address.text,
                  "schoolStateId": schoolStateId,
                  "schoolCityId": schoolCityId,
                  "schoolTypeId": SchoolTypeEnum.values[selectedSchoolType].id,
                  "emisNumber": emis.text,
                  "managerEmail": managerEmail.text,
                  "userName": username.text,
                  "password": password.text,
                  "nationalId": nationalId.text,
                  "firstName": firstName.text,
                  "middleName": middleName.text,
                  "lastName": lastName.text,
                  "managerMobileNumber": managerPhone.text,
                  "gender": selectedGender,
                  "dateOfBirth":
                      '${dateOfBirth!.year}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}',
                  "maritalStatus": selectedMarital,
                  "managerCityId": managerCityId,
                  "managerStateId": managerStateId,
                  "managerCountryId": managerCountryId,
                },
              );

              return notifier.errorAddingSchool == null;
            }
          : () async {
              final notifier = ref.read(
                schoolDetailsNotifierProvider(
                  widget.details!.school.id,
                ).notifier,
              );
              await notifier.updateSchool(
                widget.details!.school.id,
                {
                  "id": widget.details!.school.id,
                  "name": name.text,
                  "email": schoolEmail.text,
                  "phone": phone.text,
                  "address": address.text,
                  "emisNUmber": emis.text,
                },
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

    if (success == true) {
      if (isAdding) {
        ref.read(schoolsBreadcrumbProvider.notifier).pop();
        Get.back(id: Sroutes.schoolsNavigationId);
      } else {
        if (mounted) {
          setState(() {
            isSchoolEditing = false;
            isManagerEditing = false;
          });
        }
      }
    } else {
      await Get.dialog<void>(
        ErrorDialog(message: loc.errorOccurred),
        barrierDismissible: false,
      );
    }
  }

  Future<void> _handleRemoveManager() async {
    final loc = AppLocalizations.of(context)!;

    final notifier = ref.read(
      schoolDetailsNotifierProvider(widget.details!.school.id).notifier,
    );
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

        await notifier.removeManager(widget.details!.school.id);

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

  Future<void> handleChangingManager() async {
    final loc = AppLocalizations.of(context)!;
    final notifier = ref.read(
      schoolDetailsNotifierProvider(widget.details!.school.id).notifier,
    );
    final String? selectedManager = await Get.dialog<String>(
      const SelectManagerDialog(),
    );
    if (selectedManager != null) {
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

          await notifier.changeManager(selectedManager);

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

  // ── View-mode info banner ───────────────────────────────────────────────────
  Widget _viewModeBanner(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: SConfig.primaryColor.withAlpha(15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SConfig.primaryColor.withAlpha(60)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: SConfig.primaryColor,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              loc.viewModeHint,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: SConfig.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    SConfig.init(context);
    final loc = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isAdding) ...[
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
                ],
                const SizedBox(height: 20),

                // ── View-mode banner ─────────────────────────────────────────
                if (!isSchoolEditing && !isManagerEditing && !isAdding)
                  _viewModeBanner(context),

                // ── 🛡️ SCHOOL STUFF ─────────────────────────────────────────
                _sectionCard(
                  context: context,
                  icon: Icons.apartment_rounded,
                  title: loc.schoolInformation,
                  isSectionEditing: isSchoolEditing,
                  onEdit: () => setState(() => isSchoolEditing = true),
                  onCancel: () => setState(() {
                    isSchoolEditing = false;
                  }),
                  onSave: () => _handleSave(context),
                  content: Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    alignment: WrapAlignment.start,
                    children: [
                      _textField(
                        context,
                        name,
                        loc.schoolName,
                        enabled: isSchoolEditing,
                      ),
                      _textField(
                        context,
                        emis,
                        loc.emisNumber,
                        enabled: isSchoolEditing,
                        hint: '2024092001',
                      ),
                      buildDropdownEnums(
                        label: loc.schoolType,
                        value: selectedSchoolType,
                        enabled: isAdding,
                        onChanged: (v) =>
                            setState(() => selectedSchoolType = v!),
                        items: SchoolTypeEnum.values
                            .sublist(1)
                            .map(
                              (g) => DropdownMenuItem(
                                value: g.index,
                                child: Text(g.loc(loc)),
                              ),
                            )
                            .toList(),
                      ),
                      _textField(
                        context,
                        schoolEmail,
                        loc.schoolEmail,
                        enabled: isSchoolEditing,
                        hint: 'school@example.com',
                        keyboard: TextInputType.emailAddress,
                        validator: (v) => emailRegex.hasMatch(v ?? '')
                            ? null
                            : loc.invalidEmail,
                      ),
                      _textField(
                        context,
                        phone,
                        loc.phone,
                        enabled: isSchoolEditing,
                        keyboard: TextInputType.phone,
                        hint: '09498561',
                        validator: (v) => phoneRegex.hasMatch(v ?? '')
                            ? null
                            : loc.invalidPhone,
                      ),
                      _textField(
                        context,
                        address,
                        loc.address,
                        enabled: isSchoolEditing,
                      ),
                      // -- School State --
                      ref
                          .watch(
                            schoolStatesProvider(
                              '11111111-1111-1111-1111-111111111111',
                            ),
                          )
                          .when(
                            data: (data) {
                              if (!data.any((e) => e.id == schoolStateId)) {
                                if (!isAdding && widget.details != null) {
                                  final match = data.firstWhereOrNull(
                                    (e) =>
                                        e.name ==
                                        widget.details!.school.stateName,
                                  );
                                  schoolStateId = match?.id ?? data.first.id;
                                } else {
                                  schoolStateId = data.first.id;
                                }
                              }
                              return buildDropdown(
                                label: loc.stateId,
                                value: schoolStateId,
                                enabled: isAdding,
                                onChanged: (v) =>
                                    setState(() => schoolStateId = v!),
                                items: data,
                              );
                            },
                            error: (_, _) => const SizedBox.shrink(),
                            loading: () => buildDropdown(
                              label: loc.stateId,
                              value: '',
                              enabled: false,
                              items: [],
                              onChanged: (_) {},
                            ),
                          ),
                      // -- School City --
                      ref
                          .watch(schoolCitiesProvider(schoolStateId))
                          .when(
                            data: (data) {
                              if (!data.any((e) => e.id == schoolCityId)) {
                                if (!isAdding && widget.details != null) {
                                  final match = data.firstWhereOrNull(
                                    (e) =>
                                        e.name ==
                                        widget.details!.school.cityName,
                                  );
                                  schoolCityId = match?.id ?? data.first.id;
                                } else {
                                  schoolCityId = data.first.id;
                                }
                              }
                              return buildDropdown(
                                label: loc.cityId,
                                value: schoolCityId,
                                enabled: isAdding,
                                onChanged: (v) =>
                                    setState(() => schoolCityId = v!),
                                items: data,
                              );
                            },
                            error: (_, _) => const SizedBox.shrink(),
                            loading: () => buildDropdown(
                              label: loc.cityId,
                              value: '',
                              enabled: false,
                              items: [],
                              onChanged: (_) {},
                            ),
                          ),
                    ],
                  ),
                ),

                // ── 👤 MANAGER STUFF ─────────────────────────────────────────
                if (widget.details?.manager != null || isAdding)
                  _sectionCard(
                    context: context,
                    icon: Icons.manage_accounts_rounded,
                    title: loc.managerInformation,
                    isSectionEditing: isManagerEditing,
                    onEdit: null,
                    onCancel: null,
                    onSave: null,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 24,
                          runSpacing: 24,
                          alignment: WrapAlignment.start,
                          children: [
                            _textField(
                              context,
                              managerEmail,
                              loc.managerEmail,
                              enabled: isAdding,
                              hint: 'manager@example.com',
                              keyboard: TextInputType.emailAddress,
                              validator: (v) => emailRegex.hasMatch(v ?? '')
                                  ? null
                                  : loc.invalidEmail,
                            ),
                            _textField(
                              context,
                              username,
                              loc.username,
                              enabled: isAdding,
                            ),
                            if (isAdding)
                              _textField(
                                context,
                                password,
                                loc.password,
                                enabled: isAdding,
                              ),
                            _textField(
                              context,
                              managerPhone,
                              loc.managerPhone,
                              enabled: isAdding,
                              keyboard: TextInputType.phone,
                              hint: '09498561',
                              validator: (v) => phoneRegex.hasMatch(v ?? '')
                                  ? null
                                  : loc.invalidPhone,
                            ),
                            _textField(
                              context,
                              firstName,
                              loc.firstName,
                              enabled: isAdding,
                            ),
                            _textField(
                              context,
                              middleName,
                              loc.middleName,
                              enabled: isAdding,
                            ),
                            _textField(
                              context,
                              lastName,
                              loc.lastName,
                              enabled: isAdding,
                            ),
                            _textField(
                              context,
                              nationalId,
                              loc.nationalId,
                              enabled: isAdding,
                              keyboard: TextInputType.number,
                              hint: '***03180036',
                            ),
                            buildDropdownEnums(
                              label: loc.gender,
                              value: selectedGender,
                              enabled: isAdding,
                              onChanged: (v) =>
                                  setState(() => selectedGender = v!),
                              items: GenderEnum.values
                                  .sublist(1)
                                  .map(
                                    (g) => DropdownMenuItem(
                                      value: g.index,
                                      child: Text(g.loc(loc)),
                                    ),
                                  )
                                  .toList(),
                            ),
                            buildDropdownEnums(
                              label: loc.maritalStatus,
                              value: selectedMarital,
                              enabled: isAdding,
                              onChanged: (v) =>
                                  setState(() => selectedMarital = v!),
                              items: MaritalStatusEnum.values
                                  .sublist(1)
                                  .map(
                                    (g) => DropdownMenuItem(
                                      value: g.index,
                                      child: Text(g.loc(loc)),
                                    ),
                                  )
                                  .toList(),
                            ),
                            _dateField(context, enabled: isAdding),
                            // -- Manager Country --
                            ref
                                .watch(countriesProvider)
                                .when(
                                  data: (data) {
                                    if (!data.any(
                                      (e) => e.id == managerCountryId,
                                    )) {
                                      if (!isAdding && widget.details != null) {
                                        final match = data.firstWhereOrNull(
                                          (e) =>
                                              e.name ==
                                              widget
                                                  .details!
                                                  .manager
                                                  ?.countryName,
                                        );
                                        managerCountryId =
                                            match?.id ?? data.first.id;
                                      } else {
                                        managerCountryId = data.last.id;
                                      }
                                    }
                                    return buildDropdown(
                                      label: loc.country,
                                      value: managerCountryId,
                                      enabled: isAdding,
                                      onChanged: (v) =>
                                          setState(() => managerCountryId = v!),
                                      items: data,
                                    );
                                  },
                                  error: (_, _) => const SizedBox.shrink(),
                                  loading: () => buildDropdown(
                                    label: loc.country,
                                    value: '',
                                    enabled: false,
                                    items: [],
                                    onChanged: (_) {},
                                  ),
                                ),
                            // -- Manager State --
                            ref
                                .watch(managerStatesProvider(managerCountryId))
                                .when(
                                  data: (data) {
                                    if (!data.any(
                                      (e) => e.id == managerStateId,
                                    )) {
                                      if (!isAdding && widget.details != null) {
                                        final match = data.firstWhereOrNull(
                                          (e) =>
                                              e.name ==
                                              widget
                                                  .details!
                                                  .manager
                                                  ?.stateName,
                                        );
                                        managerStateId =
                                            match?.id ?? data.first.id;
                                      } else {
                                        managerStateId = data.first.id;
                                      }
                                    }
                                    return buildDropdown(
                                      label: loc.stateId,
                                      value: managerStateId,
                                      enabled: isAdding,
                                      onChanged: (v) =>
                                          setState(() => managerStateId = v!),
                                      items: data,
                                    );
                                  },
                                  error: (_, _) => const SizedBox.shrink(),
                                  loading: () => buildDropdown(
                                    label: loc.stateId,
                                    value: '',
                                    enabled: false,
                                    items: [],
                                    onChanged: (_) {},
                                  ),
                                ),
                            // -- Manager City --
                            ref
                                .watch(managerCitiesProvider(managerStateId))
                                .when(
                                  data: (data) {
                                    if (!data.any(
                                      (e) => e.id == managerCityId,
                                    )) {
                                      if (!isAdding && widget.details != null) {
                                        final match = data.firstWhereOrNull(
                                          (e) =>
                                              e.name ==
                                              widget.details!.manager?.cityName,
                                        );
                                        managerCityId =
                                            match?.id ?? data.first.id;
                                      } else {
                                        managerCityId = data.first.id;
                                      }
                                    }
                                    return buildDropdown(
                                      label: loc.cityId,
                                      value: managerCityId,
                                      enabled: isAdding,
                                      onChanged: (v) =>
                                          setState(() => managerCityId = v!),
                                      items: data,
                                    );
                                  },
                                  error: (_, _) => const SizedBox.shrink(),
                                  loading: () => buildDropdown(
                                    label: loc.cityId,
                                    value: '',
                                    enabled: false,
                                    items: [],
                                    onChanged: (_) {},
                                  ),
                                ),
                          ],
                        ),
                      ],
                    ),
                  ),
                if (widget.details?.manager == null && !isAdding)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: SConfig.isMobile()
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.spaceBetween,
                      children: [
                        if (!SConfig.isMobile())
                          Text(
                            loc.noManagerFoundMessage,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        SizedBox(
                          width: 200,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await handleChangingManager();
                            },
                            icon: const Icon(
                              Icons.manage_accounts_rounded,
                              size: 20,
                            ),
                            label: Text(
                              loc.assignManager,
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: SConfig.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                // ── GLOBAL SAVE (FOR ADDING) ──────────────────────────────────
                if (isAdding)
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SConfig.successColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                        ),
                        label: Text(
                          loc.save,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                fontSize: 18,
                                letterSpacing: 1.2,
                              ),
                        ),
                        onPressed: () async {
                          await _handleSave(context);
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

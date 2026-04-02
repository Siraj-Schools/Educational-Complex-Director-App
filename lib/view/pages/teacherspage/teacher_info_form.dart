import 'dart:async';

import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/models/constants/gender.dart';
import 'package:educational_complex_director_app/models/constants/marital_status.dart';
import 'package:educational_complex_director_app/models/constants/qualifications.dart';
import 'package:educational_complex_director_app/models/constants/teacher_designation.dart';
import 'package:educational_complex_director_app/models/geography.dart';
import 'package:educational_complex_director_app/models/helpers/new_credentials.dart';
import 'package:educational_complex_director_app/models/teacher/teacher_details.dart';
import 'package:educational_complex_director_app/routes/routes.dart';
import 'package:educational_complex_director_app/services/log_services.dart';
import 'package:educational_complex_director_app/utils/s_config.dart';
import 'package:educational_complex_director_app/view/components/confirmation_dialog.dart';
import 'package:educational_complex_director_app/view/components/error_dialog.dart';
import 'package:educational_complex_director_app/view/components/loading_dialog.dart';
import 'package:educational_complex_director_app/view/components/select_school_and_designation_dialog.dart';
import 'package:educational_complex_director_app/view/components/show_new_credentials_dialog.dart';
import 'package:educational_complex_director_app/view_model/Geography/cities.dart';
import 'package:educational_complex_director_app/view_model/Geography/countries.dart';
import 'package:educational_complex_director_app/view_model/Geography/states.dart';
import 'package:educational_complex_director_app/view_model/bread_crumb_notifier.dart';
import 'package:educational_complex_director_app/view_model/teacher/teacher_details.dart';
import 'package:educational_complex_director_app/view_model/teacher/teachers.dart';
import 'package:educational_complex_director_app/view_model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class TeacherInfoForm extends ConsumerStatefulWidget {
  final TeacherDetails? details;

  const TeacherInfoForm({
    super.key,
    this.details,
  });

  @override
  ConsumerState<TeacherInfoForm> createState() => _TeacherInfoFormState();
}

class _TeacherInfoFormState extends ConsumerState<TeacherInfoForm> {
  final _formKey = GlobalKey<FormState>();

  // ── Controllers ─────────────────────────────────────────────────────────────
  late TextEditingController email;
  late TextEditingController username;
  late TextEditingController password;
  late TextEditingController nationalId;
  late TextEditingController firstName;
  late TextEditingController middleName;
  late TextEditingController lastName;
  late TextEditingController phone;

  // ── Dropdown values ──────────────────────────────────────────────────────────
  String teacherCountryId = '11111111-1111-1111-1111-111111111111';
  String teacherStateId = '11111111-1111-1111-1111-111111111112';
  String teacherCityId = '11111111-1111-1111-1111-111111110201';

  String qualificationId = QualificationEnum.Primary.id;
  String? schoolId;
  String? schoolName;
  int selectedGender = 1;
  int selectedMarital = 1;
  int selectedDesignation = 0;

  DateTime? dateOfBirth;

  // ── Mode flags ───────────────────────────────────────────────────────────────
  late final bool isAdding;
  bool isEditing = false;
  bool isSomethingEdited = false;
  Timer? _debounce;

  // ── Validators ───────────────────────────────────────────────────────────────
  final _emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$');
  final _phoneRegex = RegExp(r'^[0-9+\-]{7,20}$');

  @override
  void initState() {
    super.initState();
    final d = widget.details;
    isAdding = d == null;
    isEditing = isAdding;

    email = TextEditingController(text: d?.teacher.email ?? '');
    username = TextEditingController(text: d?.userName ?? '');
    password = TextEditingController();
    nationalId = TextEditingController(text: d?.teacher.nationalId ?? '');
    firstName = TextEditingController(text: d?.teacher.firstName ?? '');
    middleName = TextEditingController(text: d?.teacher.middleName ?? '');
    lastName = TextEditingController(text: d?.teacher.lastName ?? '');
    phone = TextEditingController(text: d?.teacher.mobileNumber ?? '');

    dateOfBirth = d?.dateOfBirth;

    if (!isAdding) {
      selectedDesignation = d!.designation.index;
      selectedGender = d.gender.index;
      selectedMarital = d.maritalStatus.index;
      schoolId = d.teacher.schoolId;
    }
  }

  @override
  void dispose() {
    email.dispose();
    username.dispose();
    password.dispose();
    nationalId.dispose();
    firstName.dispose();
    middleName.dispose();
    lastName.dispose();
    phone.dispose();
    _debounce?.cancel();
    super.dispose();
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
    bool enabled = true,
    TextInputType? keyboard,
    String? hint,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    final loc = AppLocalizations.of(context)!;
    return SizedBox(
      width: _fieldWidth(),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboard,
        obscureText: obscure,
        onChanged: (_) {
          if (!isSomethingEdited) {
            setState(() => isSomethingEdited = true);
          }
        },
        validator:
            validator ??
            (v) => (v == null || v.isEmpty) ? '$label ${loc.required}' : null,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: enabled ? null : SConfig.textDark.withAlpha(160),
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
        ),
      ),
    );
  }

  Widget _dateField(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final String dateText = dateOfBirth == null
        ? ''
        : '${dateOfBirth!.year}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}';

    return SizedBox(
      width: _fieldWidth(),
      child: TextFormField(
        enabled: isEditing,
        readOnly: true,
        controller: TextEditingController(text: dateText),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isEditing ? null : SConfig.textDark.withAlpha(160),
        ),
        validator: (_) => dateOfBirth == null ? loc.required : null,
        decoration: InputDecoration(
          labelText: loc.dateOfBirth,
          suffixIcon: const Icon(
            Icons.calendar_today_rounded,
            color: SConfig.secondaryBackground,
          ),
        ),
        onTap: isEditing
            ? () async {
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                  initialDate: dateOfBirth ?? DateTime(2000),
                );
                if (picked != null) {
                  setState(() {
                    dateOfBirth = picked;
                    isSomethingEdited = true;
                  });
                }
              }
            : null,
      ),
    );
  }

  Widget _dropdownGeography({
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
        isExpanded: true,
        menuMaxHeight: 300,
        decoration: InputDecoration(labelText: label),
        items: items
            .map((e) => DropdownMenuItem(value: e.id, child: Text(e.name)))
            .toList(),
        onChanged: enabled
            ? (v) {
                onChanged(v);
                setState(() => isSomethingEdited = true);
              }
            : null,
      ),
    );
  }

  Widget _dropdownEnum<T>({
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
        onChanged: enabled
            ? (v) {
                onChanged(v);
                setState(() => isSomethingEdited = true);
              }
            : null,
      ),
    );
  }

  Widget _sectionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 24, 12, 24),
            child: content,
          ),
        ],
      ),
    );
  }

  Future<void> handleChangingTeacherPassword(
    BuildContext context,
  ) async {
    final loc = AppLocalizations.of(context)!;
    final notifier = ref.read(
      teacherDetailsNotifierProvider(widget.details!.teacher.id).notifier,
    );
    final bool? confirmed = await Get.dialog<bool>(
      ConfirmationDialog(
        message: loc.confirmAction,
        onConfirm: () => Get.back<bool>(result: true),
      ),
      barrierDismissible: false,
    );

    if (confirmed != true) return;
    NewCredentials? newCredentials;
    final success = await Get.showOverlay<bool>(
      asyncFunction: () async {
        // await Future.delayed(const Duration(seconds: 1));

        newCredentials = await notifier.resetTeacherPassword();

        return notifier.error == null && newCredentials != null;
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
    } else {
      await Get.dialog<void>(
        ShowNewCredentialsDialog(newCredentials: newCredentials!),
        barrierDismissible: false,
      );
    }
  }

  Widget _topBar(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (!isAdding && isEditing)
          //make a button to handle reset password
          //make it better looking
          OutlinedButton(
            onPressed: () => handleChangingTeacherPassword(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: SConfig.errorColor,
              side: BorderSide(color: SConfig.errorColor.withAlpha(150)),
            ),
            child: Text(loc.changePasswordOfTeacher),
          ),

        if (isAdding)
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
          )
        else
          const SizedBox.shrink(),

        if (!isAdding &&
            (ref.read(userViewModelProvider).value?.isDirector ?? false))
          Row(
            children: [
              if (isEditing && !isSomethingEdited)
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: SConfig.errorColor,
                    side: BorderSide(color: SConfig.errorColor.withAlpha(150)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => setState(() {
                    isEditing = false;
                    isSomethingEdited = false;
                  }),
                  icon: const Icon(Icons.close, size: 18),
                  label: Text(loc.cancelEdit),
                ),
              if (!isEditing)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SConfig.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => setState(() => isEditing = true),
                  icon: const Icon(Icons.edit, size: 18),
                  label: Text(loc.edit),
                ),
              if (isEditing && isSomethingEdited) const SizedBox(width: 12),
              if (isEditing && isSomethingEdited)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SConfig.successColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _handleSave(context),
                  icon: const Icon(Icons.save, size: 18),
                  label: Text(loc.save),
                ),
            ],
          ),
      ],
    );
  }

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

    final addingBody = {
      'email': email.text,
      'userName': username.text,
      'password': password.text,
      'nationalId': nationalId.text,
      'firstName': firstName.text,
      'middleName': middleName.text,
      'lastName': lastName.text,
      'mobileNumber': phone.text,
      'gender': selectedGender,
      'dateOfBirth':
          "${dateOfBirth!.year}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
      'maritalStatus': selectedMarital,
      'cityId': teacherCityId,
      'stateId': teacherStateId,
      'countryId': teacherCountryId,
      'qualificationId': qualificationId,
      'schoolId': schoolId,
      'designation': selectedDesignation,
    };
    final editBody = {
      "userId": widget.details?.teacher.id,
      'firstName': firstName.text,
      'middleName': middleName.text,
      'lastName': lastName.text,
      'mobileNumber': phone.text,
      'gender': selectedGender,
      'dateOfBirth':
          "${dateOfBirth!.year}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",

      "email": email.text,
    };
    final success = await Get.showOverlay<bool>(
      asyncFunction: () async {
        if (isAdding) {
          final notifier = ref.read(
            teachersNotifierProvider.notifier,
          );
          LogService.i(addingBody.toString());
          await notifier.createTeacher(addingBody);
          return notifier.errorAddingTeacher == null;
        } else {
          final notifier = ref.read(
            teacherDetailsNotifierProvider(widget.details!.teacher.id).notifier,
          );
          LogService.i(editBody.toString());
          await notifier.updateTeacher(editBody);
          return notifier.error == null;
        }
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
        ref.read(teachersBreadcrumbProvider.notifier).pop();
        Get.back(id: Sroutes.teachersNavigationId);
      } else {
        setState(() {
          isEditing = false;
          isSomethingEdited = false;
        });
      }
    } else {
      await Get.dialog<void>(
        ErrorDialog(message: loc.errorOccurred),
        barrierDismissible: false,
      );
    }
  }

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
                if (!isEditing && !isAdding) _viewModeBanner(context),
                _topBar(context),
                const SizedBox(height: 20),
                // ── Account Information ──────────────────────────────────────
                _sectionCard(
                  context: context,
                  icon: Icons.manage_accounts_rounded,
                  title: loc.accountInformation,
                  content: Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    children: [
                      _textField(
                        context,
                        email,
                        loc.email,
                        enabled: isEditing,
                        keyboard: TextInputType.emailAddress,
                        hint: 'teacher@example.com',
                        validator: (v) => _emailRegex.hasMatch(v ?? '')
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
                          obscure: false,
                        ),
                    ],
                  ),
                ),

                // ── Personal Information ─────────────────────────────────────
                _sectionCard(
                  context: context,
                  icon: Icons.person_rounded,
                  title: loc.personalInformation,
                  content: Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    children: [
                      _textField(
                        context,
                        firstName,
                        loc.firstName,
                        enabled: isEditing,
                      ),
                      _textField(
                        context,
                        middleName,
                        loc.middleName,
                        enabled: isEditing,
                      ),
                      _textField(
                        context,
                        lastName,
                        loc.lastName,
                        enabled: isEditing,
                      ),
                      _textField(
                        context,
                        nationalId,
                        loc.nationalId,
                        enabled: isAdding,
                        keyboard: TextInputType.number,
                      ),
                      _textField(
                        context,
                        phone,
                        loc.phone,
                        enabled: isEditing,
                        keyboard: TextInputType.phone,
                        hint: '09xxxxxxx',
                        validator: (v) => _phoneRegex.hasMatch(v ?? '')
                            ? null
                            : loc.invalidPhone,
                      ),
                      _dropdownEnum(
                        label: loc.gender,
                        value: selectedGender,
                        enabled: isEditing,
                        onChanged: (v) => setState(() => selectedGender = v!),
                        items: GenderEnum.values
                            .where((e) => e != GenderEnum.None)
                            .map(
                              (g) => DropdownMenuItem(
                                value: g.index,
                                child: Text(g.loc(loc)),
                              ),
                            )
                            .toList(),
                      ),
                      _dropdownEnum(
                        label: loc.maritalStatus,
                        value: selectedMarital,
                        enabled: isAdding,
                        onChanged: (v) => setState(() => selectedMarital = v!),
                        items: MaritalStatusEnum.values
                            .where((e) => e != MaritalStatusEnum.None)
                            .map(
                              (m) => DropdownMenuItem(
                                value: m.index,
                                child: Text(m.loc(loc)),
                              ),
                            )
                            .toList(),
                      ),
                      _dateField(context),
                    ],
                  ),
                ),

                // ── Location ─────────────────────────────────────────────────
                _sectionCard(
                  context: context,
                  icon: Icons.location_on_rounded,
                  title: loc.location,
                  content: ref
                      .watch(countriesProvider)
                      .when(
                        data: (countries) {
                          if (!countries.any((c) => c.id == teacherCountryId) &&
                              countries.isNotEmpty) {
                            teacherCountryId = countries.first.id;
                          }
                          return ref
                              .watch(schoolStatesProvider(teacherCountryId))
                              .when(
                                data: (states) {
                                  if (!states.any(
                                        (s) => s.id == teacherStateId,
                                      ) &&
                                      states.isNotEmpty) {
                                    teacherStateId = states.first.id;
                                  }
                                  return Wrap(
                                    spacing: 24,
                                    runSpacing: 24,
                                    children: [
                                      _dropdownGeography(
                                        label: loc.country,
                                        items: countries,
                                        value: teacherCountryId,
                                        enabled: isAdding,
                                        onChanged: (v) {
                                          setState(() {
                                            teacherCountryId = v!;
                                          });
                                        },
                                      ),
                                      _dropdownGeography(
                                        label: loc.stateId,
                                        items: states,
                                        value: teacherStateId,
                                        enabled: isAdding,
                                        onChanged: (v) {
                                          setState(() {
                                            teacherStateId = v!;
                                          });
                                        },
                                      ),
                                      ref
                                          .watch(
                                            schoolCitiesProvider(
                                              teacherStateId,
                                            ),
                                          )
                                          .when(
                                            data: (cities) {
                                              if (!cities.any(
                                                    (c) =>
                                                        c.id == teacherCityId,
                                                  ) &&
                                                  cities.isNotEmpty) {
                                                teacherCityId = cities.first.id;
                                              }
                                              return _dropdownGeography(
                                                label: loc.cityId,
                                                items: cities,
                                                value: teacherCityId,
                                                enabled: isAdding,
                                                onChanged: (v) => setState(
                                                  () => teacherCityId = v!,
                                                ),
                                              );
                                            },
                                            error: (err, stack) =>
                                                const SizedBox.shrink(),
                                            loading: () =>
                                                const SizedBox.shrink(),
                                          ),
                                    ],
                                  );
                                },
                                error: (err, stack) => const SizedBox.shrink(),
                                loading: () => const SizedBox.shrink(),
                              );
                        },
                        error: (err, stack) => const SizedBox.shrink(),
                        loading: () => const SizedBox.shrink(),
                      ),
                ),

                // ── Professional Information ─────────────────────────────────
                _sectionCard(
                  context: context,
                  icon: Icons.work_rounded,
                  title: loc.professionalInformation,
                  content: Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    children: [
                      _dropdownEnum(
                        label: loc.qualification,
                        value: QualificationEnum.values.indexWhere(
                          (e) => e.id == qualificationId,
                        ),
                        enabled: isAdding,
                        onChanged: (v) => setState(
                          () =>
                              qualificationId = QualificationEnum.values[v!].id,
                        ),
                        items: QualificationEnum.values
                            .where((e) => e != QualificationEnum.None)
                            .map(
                              (q) => DropdownMenuItem(
                                value: q.index,
                                child: Text(q.loc(loc)),
                              ),
                            )
                            .toList(),
                      ),
                      if (isAdding)
                        SizedBox(
                          width: _fieldWidth(),
                          child: InkWell(
                            onTap: () async {
                              final result =
                                  await Get.dialog<Map<String, dynamic>>(
                                    const SelectSchoolAndDesignationDialog(
                                      isSchoolOnly: true,
                                    ),
                                  );
                              if (result != null) {
                                setState(() {
                                  schoolId = result['schoolId'];
                                  schoolName = result['schoolName'];
                                  isSomethingEdited = true;
                                });
                              }
                            },
                            child: IgnorePointer(
                              child: TextFormField(
                                readOnly: true,
                                controller: TextEditingController(
                                  text: schoolName ?? '',
                                ),
                                style: const TextStyle(
                                  color: SConfig.textDark,
                                  fontWeight: FontWeight.bold,
                                ),
                                validator: (v) => (schoolId == null)
                                    ? '${loc.school} ${loc.required}'
                                    : null,
                                decoration: InputDecoration(
                                  labelText: loc.school,
                                  suffixIcon: const Icon(
                                    Icons.search,
                                    color: SConfig.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      _dropdownEnum(
                        label: loc.designation,
                        value: selectedDesignation,
                        enabled: isAdding,
                        onChanged: (v) =>
                            setState(() => selectedDesignation = v!),
                        items: TeacherDesignation.values
                            .map(
                              (d) => DropdownMenuItem(
                                value: d.index,
                                child: Text(d.localizedName(loc)),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),

                if (isAdding)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SConfig.successColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () async => await _handleSave(context),
                        icon: const Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        label: Text(
                          loc.save,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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

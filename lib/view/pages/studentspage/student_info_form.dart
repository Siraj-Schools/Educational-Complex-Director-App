import 'dart:async';

import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/models/constants/gender.dart';
import 'package:educational_complex_director_app/models/constants/marital_status.dart';
import 'package:educational_complex_director_app/models/constants/parent_relation.dart';
import 'package:educational_complex_director_app/models/constants/qualifications.dart';
import 'package:educational_complex_director_app/models/geography.dart';
import 'package:educational_complex_director_app/models/helpers/new_credentials.dart';
import 'package:educational_complex_director_app/models/student/student_details.dart';
import 'package:educational_complex_director_app/routes/routes.dart';
import 'package:educational_complex_director_app/services/log_services.dart';
import 'package:educational_complex_director_app/utils/s_config.dart';
import 'package:educational_complex_director_app/view/components/confirmation_dialog.dart';
import 'package:educational_complex_director_app/view/components/error_dialog.dart';
import 'package:educational_complex_director_app/view/components/loading_dialog.dart';
import 'package:educational_complex_director_app/view/components/select_school_and_designation_dialog.dart';
import 'package:educational_complex_director_app/view/components/select_school_and_standard.dart';
import 'package:educational_complex_director_app/view/components/show_new_credentials_dialog.dart';
import 'package:educational_complex_director_app/view_model/Geography/cities.dart';
import 'package:educational_complex_director_app/view_model/Geography/countries.dart';
import 'package:educational_complex_director_app/view_model/Geography/states.dart';
import 'package:educational_complex_director_app/view_model/bread_crumb_notifier.dart';
import 'package:educational_complex_director_app/view_model/student/student_details.dart';
import 'package:educational_complex_director_app/view_model/student/students.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class StudentInfoForm extends ConsumerStatefulWidget {
  final StudentDetails? studentDetails;

  const StudentInfoForm({
    super.key,
    this.studentDetails,
  });

  @override
  ConsumerState<StudentInfoForm> createState() => _StudentInfoFormState();
}

class _StudentInfoFormState extends ConsumerState<StudentInfoForm> {
  final _formKey = GlobalKey<FormState>();

  // ── Student Controllers ─────────────────────────────────────────────────────
  late TextEditingController studentEmail;

  late TextEditingController studentNationalId;
  late TextEditingController studentFirstName;
  late TextEditingController studentMiddleName;
  late TextEditingController studentLastName;
  late TextEditingController studentMobileNumber;
  late TextEditingController studentNationality;
  late TextEditingController motherName;

  // ── Parent Controllers ──────────────────────────────────────────────────────
  late TextEditingController parentFirstName;
  late TextEditingController parentMiddleName;
  late TextEditingController parentLastName;
  late TextEditingController parentNationalId;
  late TextEditingController parentMobileNumber;
  late TextEditingController parentEmail;
  // ── Dropdown values & State ──────────────────────────────────────────────────
  String studentCountryId = '11111111-1111-1111-1111-111111111111';
  String studentStateId = '11111111-1111-1111-1111-111111111112';
  String studentCityId = '11111111-1111-1111-1111-111111110201';

  String parentCountryId = '11111111-1111-1111-1111-111111111111';
  String parentStateId = '11111111-1111-1111-1111-111111111112';
  String parentCityId = '11111111-1111-1111-1111-111111110201';

  int studentGender = 1;
  int studentMaritalStatus = 1;
  DateTime? studentDob;

  int parentGender = 1;
  int parentMaritalStatus = 1;
  int parentRelation = 0;
  String? parentQualificationId;
  DateTime? parentDob;
  //selection
  String? schoolId;
  String? standardId;
  String? schoolName;

  // ── Mode flags ───────────────────────────────────────────────────────────────
  late final bool isAdding;
  bool isEditing = false;
  bool isSomethingEdited = false;

  // ── Validators ───────────────────────────────────────────────────────────────
  final _emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$');
  final _phoneRegex = RegExp(r'^[0-9+\-]{7,20}$');

  @override
  void initState() {
    super.initState();
    final d = widget.studentDetails;
    isAdding = d == null;
    isEditing = isAdding;
    // Student fields
    studentEmail = TextEditingController(text: d?.student.email ?? '');
    studentNationalId = TextEditingController(
      text: d?.student.nationalId ?? '',
    );
    studentFirstName = TextEditingController(text: d?.student.firstName ?? '');
    studentMiddleName = TextEditingController(
      text: d?.student.middleName ?? '',
    );
    studentLastName = TextEditingController(text: d?.student.lastName ?? '');
    studentMobileNumber = TextEditingController(
      text: d?.mobileNumber ?? '',
    ); // Not in basic Student model?
    studentNationality = TextEditingController(text: '');
    motherName = TextEditingController(text: '');

    // Parent fields
    parentEmail = TextEditingController(text: d?.parent.parentEmail ?? '');
    parentFirstName = TextEditingController(
      text: d?.parent.parentFirstName ?? '',
    );
    parentMiddleName = TextEditingController(
      text: d?.parent.parentMiddleName ?? '',
    );
    parentLastName = TextEditingController(
      text: d?.parent.parentLastName ?? '',
    );
    parentNationalId = TextEditingController(
      text: d?.parent.parentNationalId ?? '',
    );
    parentMobileNumber = TextEditingController(
      text: d?.parent.parentMobileNumber ?? '',
    );

    if (!isAdding) {
      studentDob =
          d!.dateOfBirth; // Need proper DateTime parsing if available in model
      studentGender = d.gender.index;
      parentDob = d.parent.parentDateOfBirth;
      parentRelation = d.parent.parentRelation.index;
      parentGender = d.parent.parentGender.index;
    }
  }

  @override
  void dispose() {
    studentEmail.dispose();

    studentNationalId.dispose();
    studentFirstName.dispose();
    studentMiddleName.dispose();
    studentLastName.dispose();
    studentMobileNumber.dispose();
    studentNationality.dispose();
    motherName.dispose();
    parentEmail.dispose();
    parentFirstName.dispose();
    parentMiddleName.dispose();
    parentLastName.dispose();
    parentNationalId.dispose();
    parentMobileNumber.dispose();
    super.dispose();
  }

  // ── Helper UI Widgets ────────────────────────────────────────────────────────

  double _fieldWidth() {
    if (SConfig.isMobile()) return double.infinity;
    if (SConfig.isTablet()) return 280;
    return 300;
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
        onChanged: (_) => setState(() => isSomethingEdited = true),
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

  Widget _sectionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget content,
    bool isStudent = false,
  }) {
    const accent = Color.fromARGB(255, 164, 0, 0);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: SConfig.primaryColor.withAlpha(50)),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: SConfig.primaryColor.withAlpha(20),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, size: 18, color: accent.withAlpha(150)),
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
                if (isStudent && !isAdding)
                  _topBar(AppLocalizations.of(context)!),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Divider(thickness: 1, color: Colors.grey),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
            child: content,
          ),
        ],
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

  Widget _datePickerField({
    required BuildContext context,
    required String label,
    required DateTime? value,
    required bool enabled,
    required Function(DateTime) onPicked,
  }) {
    final loc = AppLocalizations.of(context)!;
    final String dateText = value == null
        ? ''
        : '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';

    return SizedBox(
      width: _fieldWidth(),
      child: TextFormField(
        enabled: enabled,
        readOnly: true,
        controller: TextEditingController(text: dateText),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: enabled ? null : SConfig.textDark.withAlpha(160),
        ),
        validator: (_) => value == null ? loc.required : null,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(
            Icons.calendar_today_rounded,
            size: 20,
            color: SConfig.primaryColor,
          ),
        ),
        onTap: enabled
            ? () async {
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  initialDate: value ?? DateTime(2010),
                );
                if (picked != null) {
                  onPicked(picked);
                  setState(() => isSomethingEdited = true);
                }
              }
            : null,
      ),
    );
  }

  // ── Action Handlers ──────────────────────────────────────────────────────────

  Future<void> _handleSave(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    final loc = AppLocalizations.of(context)!;
    const accent = Color.fromARGB(255, 164, 0, 0);
    final confirmed = await Get.dialog<bool>(
      ConfirmationDialog(
        message: loc.confirmAction,
        onConfirm: () => Get.back(result: true),
      ),
    );
    if (confirmed != true) return;

    final Map<String, dynamic> body = isAdding
        ? {
            "schoolId": schoolId,
            "standardId": standardId,
            "studentFirstName": studentFirstName.text,
            "studentMiddleName": studentMiddleName.text,
            "studentLastName": studentLastName.text,
            "studentNationalId": studentNationalId.text,
            "studentDob": studentDob?.toIso8601String().split('T')[0],
            "studentGender": studentGender,
            "studentNationality": studentNationality.text,
            "studentMobileNumber": studentMobileNumber.text.isEmpty
                ? null
                : studentMobileNumber.text,
            "studentMaritalStatus": studentMaritalStatus,
            "studentCityId": studentCityId,
            "studentStateId": studentStateId,
            "studentCountryId": studentCountryId,
            "motherName": motherName.text,
            "parentFirstName": parentFirstName.text,
            "parentMiddleName": parentMiddleName.text,
            "parentLastName": parentLastName.text,
            "parentNationalId": parentNationalId.text,
            "parentMobileNumber": parentMobileNumber.text,
            "parentGender": parentGender,
            "parentDob": parentDob?.toIso8601String().split('T')[0],
            "parentMaritalStatus": parentMaritalStatus,
            "parentCityId": parentCityId,
            "parentStateId": parentStateId,
            "parentCountryId": parentCountryId,
            "parentRelation": parentRelation,
            "parentQualificationId": parentQualificationId,
          }
        : {
            "userId": widget.studentDetails!.student.id,
            "firstName": studentFirstName.text,
            "middleName": studentMiddleName.text,
            "lastName": studentLastName.text,
            "mobileNumber": studentMobileNumber.text,
            "gender": studentGender,
            "dateOfBirth": studentDob?.toIso8601String().split('T')[0],
            "email": studentEmail.text,
          };

    final success = await Get.showOverlay<bool>(
      asyncFunction: () async {
        LogService.d(body.toString());
        if (isAdding) {
          final n = ref.read(studentsNotifierProvider.notifier);
          await n.createStudent(body);
          return n.errorAddingStudent == null;
        } else {
          final n = ref.read(
            studentDetailsNotifierProvider(
              widget.studentDetails!.student.id,
            ).notifier,
          );
          await n.updateStudent(body);
          return n.error == null;
        }
      },
      loadingWidget: LoadingDialog(
        extraMessage: loc.savingForm,
        loading: LoadingAnimationWidget.discreteCircle(
          color: accent,
          secondRingColor: SConfig.accentColor,
          thirdRingColor: SConfig.primaryColor,
          size: 90,
        ),
      ),
    );

    if (success == true) {
      if (isAdding) {
        ref.read(studentsBreadcrumbProvider.notifier).pop();
        Get.back(id: Sroutes.studentsNavigationId);
      } else {
        if (mounted) {
          setState(() {
            isEditing = false;
            isSomethingEdited = false;
          });
        }
      }
    } else {
      await Get.dialog(
        ErrorDialog(message: loc.errorOccurred),
        barrierDismissible: false,
      );
    }
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    SConfig.init(context);
    final loc = AppLocalizations.of(context)!;
    const accent = Color.fromARGB(255, 164, 0, 0);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                //backButton
                if (isAdding)
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
                  ), //transfer
                if (!isAdding)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accent.withAlpha(20),
                          foregroundColor: accent,
                          elevation: 0,
                          shadowColor: Colors.transparent,

                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 20,
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
                          loc.transferStudentToAnotherSchool,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          await _handleTransferStudent(
                            ref,
                            context,
                            widget.studentDetails!,
                            accent,
                          );
                        },
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                if (!isAdding && !isEditing) _viewModeBanner(loc),

                const SizedBox(height: 10),
                // Student Personal Section
                _sectionCard(
                  context: context,
                  icon: Icons.person_rounded,
                  title: loc.studentInformation,
                  isStudent: true,
                  content: Wrap(
                    spacing: 24,
                    runSpacing: 20,
                    children: [
                      if (!isAdding)
                        _textField(
                          context,
                          studentEmail,
                          loc.email,
                          enabled: isEditing,
                          keyboard: TextInputType.emailAddress,
                          validator: (v) => _emailRegex.hasMatch(v ?? '')
                              ? null
                              : loc.invalidEmail,
                        ),
                      _textField(
                        context,
                        studentFirstName,
                        loc.firstName,
                        enabled: isEditing,
                      ),
                      _textField(
                        context,
                        studentMiddleName,
                        loc.middleName,
                        enabled: isEditing,
                      ),
                      _textField(
                        context,
                        studentLastName,
                        loc.lastName,
                        enabled: isEditing,
                      ),
                      _textField(
                        context,
                        studentNationalId,
                        loc.nationalId,
                        enabled: isAdding,
                        keyboard: TextInputType.number,
                      ),
                      _textField(
                        context,
                        studentMobileNumber,
                        "${loc.phone} (${loc.optional})",
                        enabled: isEditing,
                        keyboard: TextInputType.phone,
                        hint: '09xxxxxxx',
                        validator: (v) => v!.isEmpty || _phoneRegex.hasMatch(v)
                            ? null
                            : loc.invalidPhone,
                      ),
                      if (isAdding)
                        _textField(
                          context,
                          motherName,
                          loc.motherName,
                          enabled: isAdding,
                        ),
                      if (isAdding)
                        _textField(
                          context,
                          studentNationality,
                          loc.nationality,
                          enabled: isAdding,
                        ),
                      _dropdownEnum(
                        label: loc.gender,
                        value: studentGender,
                        enabled: isEditing,
                        onChanged: (v) => setState(() => studentGender = v!),
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
                      if (isAdding)
                        _dropdownEnum(
                          label: loc.maritalStatus,
                          value: studentMaritalStatus,
                          enabled: isAdding,
                          onChanged: (v) =>
                              setState(() => studentMaritalStatus = v!),
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

                      _datePickerField(
                        context: context,
                        label: loc.dateOfBirth,
                        value: studentDob,
                        enabled: isEditing,
                        onPicked: (d) => setState(() => studentDob = d),
                      ),
                      if (isAdding)
                        SizedBox(
                          width: _fieldWidth(),
                          child: InkWell(
                            onTap: () async {
                              final result =
                                  await Get.dialog<Map<String, dynamic>>(
                                    const SelectSchoolAndStandardDialog(),
                                  );
                              if (result != null) {
                                setState(() {
                                  schoolId = result['schoolId'];
                                  schoolName = result['schoolName'];
                                  standardId = result['standardId'];
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
                    ],
                  ),
                ),

                // Student Location Section
                if (isAdding)
                  _sectionCard(
                    context: context,
                    icon: Icons.location_on_rounded,
                    title: loc.studentLocation,
                    content: ref
                        .watch(countriesProvider)
                        .when(
                          data: (countries) {
                            if (!countries.any(
                                  (c) => c.id == studentCountryId,
                                ) &&
                                countries.isNotEmpty) {
                              studentCountryId = countries.first.id;
                            }
                            return ref
                                .watch(schoolStatesProvider(studentCountryId))
                                .when(
                                  data: (states) {
                                    if (!states.any(
                                          (s) => s.id == studentStateId,
                                        ) &&
                                        states.isNotEmpty) {
                                      studentStateId = states.first.id;
                                    }
                                    return ref
                                        .watch(
                                          schoolCitiesProvider(studentStateId),
                                        )
                                        .when(
                                          data: (cities) {
                                            if (!cities.any(
                                                  (c) => c.id == studentCityId,
                                                ) &&
                                                cities.isNotEmpty) {
                                              studentCityId = cities.first.id;
                                            }
                                            return Wrap(
                                              spacing: 24,
                                              runSpacing: 20,
                                              children: [
                                                _dropdownGeography(
                                                  label: loc.country,
                                                  items: countries,
                                                  value: studentCountryId,
                                                  enabled: isAdding,
                                                  onChanged: (v) => setState(
                                                    () => studentCountryId = v!,
                                                  ),
                                                ),
                                                _dropdownGeography(
                                                  label: loc.stateId,
                                                  items: states,
                                                  value: studentStateId,
                                                  enabled: isAdding,
                                                  onChanged: (v) => setState(
                                                    () => studentStateId = v!,
                                                  ),
                                                ),
                                                _dropdownGeography(
                                                  label: loc.cityId,
                                                  items: cities,
                                                  value: studentCityId,
                                                  enabled: isAdding,
                                                  onChanged: (v) => setState(
                                                    () => studentCityId = v!,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                          loading: () =>
                                              const SizedBox.shrink(),
                                          error: (e, s) =>
                                              const SizedBox.shrink(),
                                        );
                                  },
                                  loading: () => const SizedBox.shrink(),
                                  error: (e, s) => const SizedBox.shrink(),
                                );
                          },
                          loading: () => const SizedBox.shrink(),
                          error: (e, s) => const SizedBox.shrink(),
                        ),
                  ),
                //changePassword
                if (!isAdding)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,

                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SConfig.errorColor,
                          foregroundColor: Colors.white,
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
                        icon: const Icon(Icons.lock_reset, size: 20),
                        label: Text(
                          AppLocalizations.of(context)!.changePasswordOfParent,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          await _handleChangePasswordOfParent(
                            ref,
                            context,
                            widget.studentDetails!,
                            accent,
                          );
                        },
                      ),
                    ],
                  ),
                const SizedBox(height: 16),

                // Parent Section
                _sectionCard(
                  context: context,
                  icon: Icons.family_restroom_rounded,
                  title: loc.parentInformation,
                  content: Wrap(
                    spacing: 24,
                    runSpacing: 20,
                    children: [
                      if (!isAdding)
                        _textField(
                          context,
                          parentEmail,
                          loc.email,
                          enabled: isAdding,
                          keyboard: TextInputType.emailAddress,
                          validator: (v) => _emailRegex.hasMatch(v ?? '')
                              ? null
                              : loc.invalidEmail,
                        ),

                      _textField(
                        context,
                        parentFirstName,
                        loc.firstName,
                        enabled: isAdding,
                      ),
                      _textField(
                        context,
                        parentMiddleName,
                        loc.middleName,
                        enabled: isAdding,
                      ),
                      _textField(
                        context,
                        parentLastName,
                        loc.lastName,
                        enabled: isAdding,
                      ),
                      _textField(
                        context,
                        parentNationalId,
                        loc.nationalId,
                        enabled: isAdding,
                        keyboard: TextInputType.number,
                      ),
                      _textField(
                        context,
                        parentMobileNumber,
                        loc.phone,
                        enabled: isAdding,
                        keyboard: TextInputType.phone,
                      ),
                      _dropdownEnum(
                        label: loc.relation,
                        value: parentRelation,
                        enabled: isAdding,
                        onChanged: (v) => setState(() => parentRelation = v!),
                        items: ParentRelationEnum.values
                            .map(
                              (r) => DropdownMenuItem(
                                value: r.index,
                                child: Text(r.loc(loc)),
                              ),
                            )
                            .toList(),
                      ),
                      _dropdownEnum(
                        label: loc.gender,
                        value: parentGender,
                        enabled: isAdding,
                        onChanged: (v) => setState(() => parentGender = v!),
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
                      _datePickerField(
                        context: context,
                        label: loc.dateOfBirth,
                        value: parentDob,
                        enabled: isAdding,
                        onPicked: (d) => setState(() => parentDob = d),
                      ),
                      _dropdownEnum(
                        label: "${loc.qualification} (${loc.optional})",
                        value: QualificationEnum.values
                            .firstWhere(
                              (e) => e.id == parentQualificationId,
                              orElse: () => QualificationEnum.None,
                            )
                            .index,
                        enabled: isAdding,
                        onChanged: (v) => setState(
                          () {
                            if (v == 0) {
                              parentQualificationId = null;
                            } else {
                              parentQualificationId =
                                  QualificationEnum.values[v!].id;
                            }
                          },
                        ),
                        items: QualificationEnum.values.map(
                          (q) {
                            return DropdownMenuItem(
                              value: q.index,
                              child: Text(q.loc(loc)),
                            );
                          },
                        ).toList(),
                      ),
                    ],
                  ),
                ),
                if (isAdding)
                  _sectionCard(
                    context: context,
                    icon: Icons.location_on_rounded,
                    title: loc.parentLocation,
                    content: ref
                        .watch(countriesProvider)
                        .when(
                          data: (countries) {
                            if (!countries.any(
                                  (c) => c.id == parentCountryId,
                                ) &&
                                countries.isNotEmpty) {
                              parentCountryId = countries.first.id;
                            }
                            return ref
                                .watch(schoolStatesProvider(parentCountryId))
                                .when(
                                  data: (states) {
                                    if (!states.any(
                                          (s) => s.id == parentStateId,
                                        ) &&
                                        states.isNotEmpty) {
                                      parentStateId = states.first.id;
                                    }
                                    return ref
                                        .watch(
                                          schoolCitiesProvider(parentStateId),
                                        )
                                        .when(
                                          data: (cities) {
                                            if (!cities.any(
                                                  (c) => c.id == parentCityId,
                                                ) &&
                                                cities.isNotEmpty) {
                                              parentCityId = cities.first.id;
                                            }
                                            return Wrap(
                                              spacing: 24,
                                              runSpacing: 20,
                                              children: [
                                                _dropdownGeography(
                                                  label: loc.country,
                                                  items: countries,
                                                  value: parentCountryId,
                                                  enabled: isAdding,
                                                  onChanged: (v) => setState(
                                                    () => parentCountryId = v!,
                                                  ),
                                                ),
                                                _dropdownGeography(
                                                  label: loc.stateId,
                                                  items: states,
                                                  value: parentStateId,
                                                  enabled: isAdding,
                                                  onChanged: (v) => setState(
                                                    () => parentStateId = v!,
                                                  ),
                                                ),
                                                _dropdownGeography(
                                                  label: loc.cityId,
                                                  items: cities,
                                                  value: parentCityId,
                                                  enabled: isAdding,
                                                  onChanged: (v) => setState(
                                                    () => parentCityId = v!,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                          loading: () => const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          error: (e, s) =>
                                              Text(loc.errorOccurred),
                                        );
                                  },
                                  loading: () => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  error: (e, s) => Text(loc.errorOccurred),
                                );
                          },
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (e, s) => Text(loc.errorOccurred),
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
                            horizontal: 48,
                            vertical: 18,
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
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                fontSize: 18,
                                letterSpacing: 1.2,
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

  Widget _topBar(AppLocalizations loc) {
    const accent = Color.fromARGB(255, 164, 0, 0);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (!isAdding && !isEditing)
          ElevatedButton.icon(
            onPressed: () => setState(() => isEditing = true),
            icon: const Icon(Icons.edit, size: 18),
            label: Text(loc.edit),
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              foregroundColor: Colors.white,
            ),
          ),
        if (isEditing && !isAdding && !isSomethingEdited)
          TextButton(
            onPressed: () => setState(() => isEditing = false),
            child: Text(loc.cancel),
          ),
        if (isEditing && (!isAdding && isSomethingEdited))
          ElevatedButton.icon(
            onPressed: () => _handleSave(context),
            icon: const Icon(Icons.save, size: 18),
            label: Text(loc.save),
            style: ElevatedButton.styleFrom(
              backgroundColor: SConfig.successColor,
              foregroundColor: Colors.white,
            ),
          ),
      ],
    );
  }

  Widget _viewModeBanner(AppLocalizations loc) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: SConfig.primaryColor.withAlpha(15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SConfig.primaryColor.withAlpha(40)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: SConfig.primaryColor, size: 20),
          const SizedBox(width: 10),
          Text(
            loc.viewModeHint,
            style: const TextStyle(color: SConfig.primaryColor),
          ),
        ],
      ),
    );
  }

  Future<void> _handleChangePasswordOfParent(
    WidgetRef ref,
    BuildContext context,
    StudentDetails details,
    Color accent,
  ) async {
    final loc = AppLocalizations.of(context)!;
    final notifier = ref.read(
      studentDetailsNotifierProvider(details.student.id).notifier,
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

        newCredentials = await notifier.resetStudentParentPassword();

        return notifier.error == null && newCredentials != null;
      },
      loadingWidget: LoadingDialog(
        extraMessage: loc.savingForm,
        loading: LoadingAnimationWidget.discreteCircle(
          color: accent,
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

  Future<void> _handleTransferStudent(
    WidgetRef ref,
    BuildContext context,
    StudentDetails details,
    Color accent,
  ) async {
    final loc = AppLocalizations.of(context)!;
    final notifier = ref.read(
      studentDetailsNotifierProvider(details.student.id).notifier,
    );
    final Map<String, dynamic>? selectedSchoolAndStandard =
        await Get.dialog<Map<String, dynamic>>(
          const SelectSchoolAndDesignationDialog(
            isSchoolOnly: true,
          ),
        );
    if (selectedSchoolAndStandard != null) {
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

          await notifier.transferStudent(
            newSchoolId: selectedSchoolAndStandard['schoolId'],
          );

          return notifier.error == null;
        },
        loadingWidget: LoadingDialog(
          extraMessage: loc.savingForm,
          loading: LoadingAnimationWidget.discreteCircle(
            color: accent,
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

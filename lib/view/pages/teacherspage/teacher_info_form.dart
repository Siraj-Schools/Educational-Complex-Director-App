import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/models/constants/countries.dart';
import 'package:educational_complex_director_app/models/constants/dummy_schools.dart';
import 'package:educational_complex_director_app/models/constants/gender.dart';
import 'package:educational_complex_director_app/models/constants/marital_status.dart';
import 'package:educational_complex_director_app/models/constants/qualifications.dart';
import 'package:educational_complex_director_app/models/constants/states.dart';
import 'package:educational_complex_director_app/models/helpers/lookup_items.dart';
import 'package:educational_complex_director_app/models/teacher/teacher_details.dart';
import 'package:educational_complex_director_app/routes/routes.dart';
import 'package:educational_complex_director_app/utils/s_config.dart';
import 'package:educational_complex_director_app/view/components/confirmation_dialog.dart';
import 'package:educational_complex_director_app/view/components/error_dialog.dart';
import 'package:educational_complex_director_app/view/components/loading_dialog.dart';
import 'package:educational_complex_director_app/view_model/bread_crumb_notifier.dart';
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
  late TextEditingController designationController;

  // ── Dropdown values ──────────────────────────────────────────────────────────
  String countryId = '1';
  String stateId = '1';
  String cityId = '1';
  String qualificationId = '10000000-0000-0000-0000-000000000001';
  String schoolId = 'ec20a588-583b-495e-bcd1-afd05fb9050e';
  int selectedGender = 0;
  int selectedMarital = 0;
  DateTime? dateOfBirth;

  // ── Mode flags ───────────────────────────────────────────────────────────────
  late final bool isAdding;
  bool isEditing = false;

  // ── Validators ───────────────────────────────────────────────────────────────
  final _emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$');
  final _phoneRegex = RegExp(r'^[0-9+\-]{7,20}$');

  // ────────────────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    final d = widget.details;
    isAdding = d == null;
    isEditing = isAdding; // add → editing; view → not editing

    email = TextEditingController(text: d?.email ?? '');
    username = TextEditingController(text: d?.userName ?? '');
    password = TextEditingController();
    nationalId = TextEditingController(text: d?.nationalId ?? '');
    firstName = TextEditingController(text: d?.firstName ?? '');
    middleName = TextEditingController(text: d?.middleName ?? '');
    lastName = TextEditingController(text: d?.lastName ?? '');
    phone = TextEditingController(text: d?.mobileNumber ?? '');
    designationController = TextEditingController(text: d?.designation ?? '');
    dateOfBirth = d?.dateOfBirth;

    if (!isAdding) {
      selectedGender = GenderEnum.values
          .firstWhere(
            (g) => g.name.toLowerCase() == d!.gender.toLowerCase(),
            orElse: () => GenderEnum.values.first,
          )
          .index;

      selectedMarital = MaritalStatusEnum.values
          .firstWhere(
            (m) => m.name.toLowerCase() == d!.maritalStatus.toLowerCase(),
            orElse: () => MaritalStatusEnum.values.first,
          )
          .index;

      if (countriesMap.containsKey(d!.countryName)) {
        countryId = countriesMap[d.countryName]!;
      }
      if (syrianStatesMap.containsKey(d.stateName)) {
        stateId = syrianStatesMap[d.stateName]!;
      }
      if (syrianStatesMap.containsKey(d.cityName)) {
        cityId = syrianStatesMap[d.cityName]!;
      }
      if (qualificationsMap.containsKey(d.qualificationName)) {
        qualificationId = qualificationsMap[d.qualificationName]!;
      }
      schoolId = d.schoolId;
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
    designationController.dispose();
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
    bool? forceEnabled,
    TextInputType? keyboard,
    String? hint,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    final enabled = forceEnabled ?? isEditing;
    return SizedBox(
      width: _fieldWidth(),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboard,
        obscureText: obscure,
        validator:
            validator ?? (v) => (v == null || v.isEmpty) ? 'Required' : null,
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
        validator: (_) => dateOfBirth == null ? 'Required' : null,
        decoration: InputDecoration(
          labelText: loc.dateOfBirth,
          suffixIcon: const Icon(
            Icons.calendar_today_rounded,
            color: SConfig.primaryColor,
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
                if (picked != null) setState(() => dateOfBirth = picked);
              }
            : null,
      ),
    );
  }

  Widget _dropdown({
    required String label,
    required List<LookupItem> items,
    required String value,
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
            .map((e) => DropdownMenuItem(value: e.id, child: Text(e.value)))
            .toList(),
        onChanged: isEditing ? onChanged : null,
      ),
    );
  }

  Widget _dropdownEnum({
    required String label,
    required List<DropdownMenuItem<int>> items,
    required int value,
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
        onChanged: isEditing ? onChanged : null,
      ),
    );
  }

  // ── Section card ─────────────────────────────────────────────────────────────
  /// Wraps content in a card with an orange left-border accent strip.
  Widget _sectionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: SConfig.secondaryBackground.withAlpha(60),
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
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Orange accent strip
          Container(
            width: 5,
            decoration: const BoxDecoration(
              color: SConfig.accentColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                bottomLeft: Radius.circular(18),
              ),
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section title row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: SConfig.accentColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          icon,
                          size: 18,
                          color: SConfig.accentColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: SConfig.textDark,
                            ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),
                  Divider(
                    color: SConfig.accentColor.withAlpha(60),
                    thickness: 1,
                  ),
                  const SizedBox(height: 16),

                  content,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Top action bar ──────────────────────────────────────────────────────────
  Widget _topBar(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back button
        IconButton.filled(
          icon: const Icon(Icons.arrow_back_rounded),
          iconSize: 36,
          padding: EdgeInsets.zero,
          style: IconButton.styleFrom(
            backgroundColor: SConfig.primaryColor.withAlpha(20),
            foregroundColor: SConfig.primaryColor,
          ),
          onPressed: () {
            ref.read(teachersBreadcrumbProvider.notifier).pop();
            Get.back(id: Sroutes.teachersNavigationId);
          },
        ),

        Row(
          children: [
            // Cancel edit (only shown when editing an existing teacher)
            if (isEditing && !isAdding)
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: OutlinedButton.icon(
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
                  onPressed: () => setState(() => isEditing = false),
                  icon: const Icon(Icons.close, size: 18),
                  iconAlignment: IconAlignment.end,
                  label: Text(loc.cancelEdit),
                ),
              ),

            // Edit button (only shown in view mode)
            if (!isEditing && !isAdding)
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SConfig.accentColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => setState(() => isEditing = true),
                  iconAlignment: IconAlignment.end,
                  icon: const Icon(Icons.edit, color: Colors.white, size: 18),
                  label: Text(
                    loc.edit,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
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

  // ── Save handler ─────────────────────────────────────────────────────────────
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

    // Build request body
    final body = {
      'email': email.text,
      'userName': username.text,
      if (isAdding) 'password': password.text,
      'nationalId': nationalId.text,
      'firstName': firstName.text,
      'middleName': middleName.text,
      'lastName': lastName.text,
      'mobileNumber': phone.text,
      'gender': GenderEnum.values[selectedGender].name,
      'dateOfBirth': dateOfBirth!.toIso8601String(),
      'maritalStatus': selectedMarital,
      'cityId': cityId,
      'stateId': stateId,
      'countryId': countryId,
      'qualificationId': qualificationId,
      'schoolId': schoolId,
      'designation': designationController.text,
    };

    // TODO: Replace the Future.delayed below with the actual API call:
    // if (isAdding) {
    //   await DioClient.post('/api/teachers', data: body);
    // } else {
    //   await DioClient.put('/api/teachers/${widget.details!.id}', data: body);
    // }
    // ignore: unused_local_variable
    final _ = body;

    final success = await Get.showOverlay<bool>(
      asyncFunction: () async {
        await Future.delayed(const Duration(seconds: 2));
        return true;
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
      ref.read(teachersBreadcrumbProvider.notifier).pop();
      Get.back(id: Sroutes.teachersNavigationId);
    } else {
      await Get.dialog<void>(
        ErrorDialog(message: loc.errorOccurred),
        barrierDismissible: false,
      );
    }
  }

  // ────────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    SConfig.init(context);
    final loc = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 960),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top action bar ───────────────────────────────────────────
                _topBar(context),

                const SizedBox(height: 20),

                // ── View-mode banner ─────────────────────────────────────────
                if (!isEditing && !isAdding) _viewModeBanner(context),

                // ── 1. Account Information ───────────────────────────────────
                _sectionCard(
                  context: context,
                  icon: Icons.manage_accounts_rounded,
                  title: loc.accountInformation,
                  content: Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      _textField(
                        context,
                        email,
                        loc.email,
                        keyboard: TextInputType.emailAddress,
                        validator: (v) => _emailRegex.hasMatch(v ?? '')
                            ? null
                            : loc.invalidEmail,
                      ),
                      _textField(context, username, loc.username),
                      if (isAdding)
                        _textField(
                          context,
                          password,
                          loc.password,
                          obscure: true,
                        ),
                      _textField(
                        context,
                        phone,
                        loc.phone,
                        keyboard: TextInputType.phone,
                        validator: (v) => _phoneRegex.hasMatch(v ?? '')
                            ? null
                            : loc.invalidPhone,
                      ),
                    ],
                  ),
                ),

                // ── 2. Teacher (Name + ID) ───────────────────────────────────
                _sectionCard(
                  context: context,
                  icon: Icons.person_rounded,
                  title: loc.teacherInformation,
                  content: Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      _textField(context, firstName, loc.firstName),
                      _textField(context, middleName, loc.middleName),
                      _textField(context, lastName, loc.lastName),
                      _textField(
                        context,
                        nationalId,
                        loc.nationalId,
                        keyboard: TextInputType.number,
                      ),
                    ],
                  ),
                ),

                // ── 3. Personal Information ──────────────────────────────────
                _sectionCard(
                  context: context,
                  icon: Icons.badge_rounded,
                  title: loc.personalInformation,
                  content: Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      _dropdownEnum(
                        label: loc.gender,
                        value: selectedGender,
                        onChanged: (v) => setState(() => selectedGender = v!),
                        items: GenderEnum.values
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
                        onChanged: (v) => setState(() => selectedMarital = v!),
                        items: MaritalStatusEnum.values
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

                // ── 4. Location ──────────────────────────────────────────────
                _sectionCard(
                  context: context,
                  icon: Icons.location_on_rounded,
                  title: loc.location,
                  content: Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      _dropdown(
                        label: loc.country,
                        value: countryId,
                        items: getCountries(loc),
                        onChanged: (v) => setState(() => countryId = v!),
                      ),
                      _dropdown(
                        label: loc.stateId,
                        value: stateId,
                        items: getSyrianStates(loc),
                        onChanged: (v) => setState(() => stateId = v!),
                      ),
                      _dropdown(
                        label: loc.cityId,
                        value: cityId,
                        items: getSyrianStates(loc),
                        onChanged: (v) => setState(() => cityId = v!),
                      ),
                    ],
                  ),
                ),

                // ── 5. Professional Information ──────────────────────────────
                _sectionCard(
                  context: context,
                  icon: Icons.school_rounded,
                  title: loc.professionalInformation,
                  content: Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      _dropdown(
                        label: loc.school,
                        value: schoolId,
                        items: getSchools(loc),
                        onChanged: (v) => setState(() => schoolId = v!),
                      ),
                      _dropdown(
                        label: loc.qualification,
                        value: qualificationId,
                        items: getQualifications(loc),
                        onChanged: (v) => setState(() => qualificationId = v!),
                      ),
                      _textField(
                        context,
                        designationController,
                        loc.designation,
                      ),
                    ],
                  ),
                ),

                // ── Save button (only shown when editing) ────────────────────
                if (isEditing)
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SConfig.successColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 36,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      iconAlignment: IconAlignment.end,
                      icon: const Icon(Icons.save_rounded),
                      label: Text(
                        loc.save,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      onPressed: () => _handleSave(context),
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

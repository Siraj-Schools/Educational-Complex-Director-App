import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/models/constants/countries.dart';
import 'package:educational_complex_director_app/models/constants/gender.dart';
import 'package:educational_complex_director_app/models/constants/marital_status.dart';
import 'package:educational_complex_director_app/models/constants/school_types.dart';
import 'package:educational_complex_director_app/models/constants/states.dart';
import 'package:educational_complex_director_app/models/helpers/lookup_items.dart';
import 'package:educational_complex_director_app/models/school/school_details.dart';
import 'package:educational_complex_director_app/routes/routes.dart';

import 'package:educational_complex_director_app/utils/s_config.dart';
import 'package:educational_complex_director_app/view/components/confirmation_dialog.dart';
import 'package:educational_complex_director_app/view/components/error_dialog.dart';
import 'package:educational_complex_director_app/view/components/loading_dialog.dart';
import 'package:educational_complex_director_app/view_model/bread_crumb_notifier.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
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

  String schoolStateId = '1';
  String schoolCityId = '1';
  String schoolTypeId = '1';

  String managerCountryId = '1';
  String managerStateId = '1';
  String managerCityId = '1';

  int selectedGender = 1;
  int selectedMarital = 1;
  DateTime? dateOfBirth;

  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$');
  final phoneRegex = RegExp(r'^[0-9]{7,15}$');
  late final bool isAdding;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    final d = widget.details;
    isAdding = d == null;
    isEditing = isAdding ? true : false;
    name = TextEditingController(text: d?.school.name ?? '');
    schoolEmail = TextEditingController(text: d?.school.email ?? '');
    phone = TextEditingController(text: d?.school.phone ?? '');
    address = TextEditingController(text: d?.school.address ?? '');
    emis = TextEditingController(text: d?.school.emisNumber ?? '');

    managerEmail = TextEditingController(text: d?.manager.email ?? '');
    username = TextEditingController(text: d?.manager.userName ?? '');
    password = TextEditingController(text: '');

    nationalId = TextEditingController(text: d?.manager.nationalId ?? '');

    firstName = TextEditingController(text: d?.manager.firstName ?? '');
    middleName = TextEditingController(text: d?.manager.middleName ?? '');
    lastName = TextEditingController(text: d?.manager.lastName ?? '');

    managerPhone = TextEditingController(
      text: d?.manager.mobileNumber ?? '',
    );
    if (!isAdding) {
      selectedGender = GenderEnum.values
          .firstWhere(
            (element) => element.name == d?.manager.gender,
            orElse: () => GenderEnum.values.first,
          )
          .index;
      selectedMarital = MaritalStatusEnum.values
          .firstWhere(
            (element) => element.name == d?.manager.maritalStatus,
            orElse: () => MaritalStatusEnum.values.first,
          )
          .index;

      if (syrianStatesMap.containsKey(d!.school.stateName)) {
        schoolStateId = syrianStatesMap[d.school.stateName]!;
      }
      if (syrianStatesMap.containsKey(d.school.cityName)) {
        schoolCityId = syrianStatesMap[d.school.cityName]!;
      }
      if (schoolTypesMap.containsKey(d.school.schoolTypeName)) {
        schoolTypeId = schoolTypesMap[d.school.schoolTypeName]!;
      }
      if (countriesMap.containsKey(d.manager.countryName)) {
        managerCountryId = countriesMap[d.manager.countryName]!;
      }
      if (syrianStatesMap.containsKey(d.manager.stateName)) {
        managerStateId = syrianStatesMap[d.manager.stateName]!;
      }
      if (syrianStatesMap.containsKey(d.manager.cityName)) {
        managerCityId = syrianStatesMap[d.manager.cityName]!;
      }
    }

    dateOfBirth = d?.manager.dateOfBirth;
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
    String? Function(String?)? validator,
  }) {
    final bool enabled = forceEnabled ?? isEditing;
    return SizedBox(
      width: _fieldWidth(),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: enabled ? null : SConfig.textDark.withAlpha(160),
        ),
        keyboardType: keyboard,
        validator:
            validator ?? (v) => (v == null || v.isEmpty) ? 'Required' : null,
        decoration: InputDecoration(
          hintText: hint,
          labelText: label,
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
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isEditing ? null : SConfig.textDark.withAlpha(160),
        ),
        controller: TextEditingController(text: dateText),
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
                if (picked != null) setState(() => dateOfBirth = picked);
              }
            : null,
      ),
    );
  }

  Widget buildDropdown({
    required String label,
    required List<LookupItem> items,
    required String value,
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
            (e) => DropdownMenuItem(value: e.id, child: Text(e.value)),
          ),
        ],
        onChanged: isEditing ? onChanged : null,
      ),
    );
  }

  Widget buildDropdownEnums({
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

  // ── Section card (teal accent — distinct from Teacher's orange) ──────────────
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
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Teal accent strip
          Container(
            width: 5,
            decoration: const BoxDecoration(
              color: SConfig.primaryColor,
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
                          color: SConfig.primaryColor.withAlpha(20),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          icon,
                          size: 18,
                          color: SConfig.primaryColor,
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
                    color: SConfig.primaryColor.withAlpha(60),
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
            ref.read(schoolsBreadcrumbProvider.notifier).pop();
            Get.back(id: Sroutes.schoolsNavigationId);
          },
        ),

        Row(
          children: [
            // Cancel edit
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

            // Edit button
            if (!isEditing && !isAdding)
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SConfig.primaryColor,
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

    // TODO: Replace Future.delayed with actual API calls:
    // if (isAdding) {
    //   await DioClient.post('/api/schools', data: body);
    // } else {
    //   await DioClient.put('/api/schools/${widget.details!.school.id}', data: body);
    // }

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
      ref.read(schoolsBreadcrumbProvider.notifier).pop();
      Get.back(id: Sroutes.schoolsNavigationId);
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

                // ── 1. School Information ────────────────────────────────────
                _sectionCard(
                  context: context,
                  icon: Icons.apartment_rounded,
                  title: loc.schoolInformation,
                  content: Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _textField(context, name, loc.schoolName),
                      _textField(
                        context,
                        emis,
                        loc.emisNumber,
                        hint: 'EMIS-2024-001',
                      ),
                      buildDropdown(
                        label: loc.schoolType,
                        value: schoolTypeId,
                        onChanged: (v) => setState(() => schoolTypeId = v!),
                        items: getSchoolTypes(loc),
                      ),
                    ],
                  ),
                ),

                // ── 2. Contact ───────────────────────────────────────────────
                _sectionCard(
                  context: context,
                  icon: Icons.contact_mail_rounded,
                  title: loc.phone,
                  content: Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _textField(
                        context,
                        schoolEmail,
                        loc.schoolEmail,
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
                        keyboard: TextInputType.phone,
                        hint: '09498561',
                        validator: (v) => phoneRegex.hasMatch(v ?? '')
                            ? null
                            : loc.invalidPhone,
                      ),
                    ],
                  ),
                ),

                // ── 3. Location ──────────────────────────────────────────────
                _sectionCard(
                  context: context,
                  icon: Icons.location_city_rounded,
                  title: loc.location,
                  content: Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _textField(context, address, loc.address),
                      buildDropdown(
                        label: loc.stateId,
                        value: schoolStateId,
                        onChanged: (v) => setState(() => schoolStateId = v!),
                        items: getSyrianStates(loc),
                      ),
                      buildDropdown(
                        label: loc.cityId,
                        value: schoolCityId,
                        onChanged: (v) => setState(() => schoolCityId = v!),
                        items: getSyrianStates(loc),
                      ),
                    ],
                  ),
                ),

                // ── 4. Manager Account ───────────────────────────────────────
                _sectionCard(
                  context: context,
                  icon: Icons.manage_accounts_rounded,
                  title: loc.managerInformation,
                  content: Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _textField(
                        context,
                        managerEmail,
                        loc.managerEmail,
                        hint: 'manager@example.com',
                        keyboard: TextInputType.emailAddress,
                        validator: (v) => emailRegex.hasMatch(v ?? '')
                            ? null
                            : loc.invalidEmail,
                      ),
                      _textField(context, username, loc.username),
                      if (isAdding) _textField(context, password, loc.password),
                      _textField(
                        context,
                        managerPhone,
                        loc.managerPhone,
                        keyboard: TextInputType.phone,
                        hint: '09498561',
                        validator: (v) => phoneRegex.hasMatch(v ?? '')
                            ? null
                            : loc.invalidPhone,
                      ),
                    ],
                  ),
                ),

                // ── 5. Manager Name & ID ─────────────────────────────────────
                _sectionCard(
                  context: context,
                  icon: Icons.person_rounded,
                  title: loc.manager,
                  content: Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _textField(context, firstName, loc.firstName),
                      _textField(context, middleName, loc.middleName),
                      _textField(context, lastName, loc.lastName),
                      _textField(
                        context,
                        nationalId,
                        loc.nationalId,
                        keyboard: TextInputType.number,
                        hint: '***03180036',
                      ),
                    ],
                  ),
                ),

                // ── 6. Manager Personal ──────────────────────────────────────
                _sectionCard(
                  context: context,
                  icon: Icons.badge_rounded,
                  title: loc.personalInformation,
                  content: Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      buildDropdownEnums(
                        label: loc.gender,
                        value: selectedGender,
                        onChanged: (v) => setState(() => selectedGender = v!),
                        items: GenderEnum.values
                            .map(
                              (g) => DropdownMenuItem(
                                enabled: isEditing,
                                value: g.index,
                                child: Text(g.loc(loc)),
                              ),
                            )
                            .toList(),
                      ),
                      buildDropdownEnums(
                        label: loc.maritalStatus,
                        value: selectedMarital,
                        onChanged: (v) => setState(() => selectedMarital = v!),
                        items: MaritalStatusEnum.values
                            .map(
                              (g) => DropdownMenuItem(
                                value: g.index,
                                enabled: isEditing,
                                child: Text(g.loc(loc)),
                              ),
                            )
                            .toList(),
                      ),
                      _dateField(context),
                    ],
                  ),
                ),

                // ── 7. Manager Location ──────────────────────────────────────
                _sectionCard(
                  context: context,
                  icon: Icons.location_on_rounded,
                  title: loc.location,
                  content: Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      buildDropdown(
                        label: loc.country,
                        value: managerCountryId,
                        onChanged: (v) => setState(() => managerCountryId = v!),
                        items: getCountries(loc),
                      ),
                      buildDropdown(
                        label: loc.stateId,
                        value: managerStateId,
                        onChanged: (v) => setState(() => managerStateId = v!),
                        items: getSyrianStates(loc),
                      ),
                      buildDropdown(
                        label: loc.cityId,
                        value: managerCityId,
                        onChanged: (v) => setState(() => managerCityId = v!),
                        items: getSyrianStates(loc),
                      ),
                    ],
                  ),
                ),

                // ── Save button ──────────────────────────────────────────────
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

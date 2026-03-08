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

  // Controllers
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

  String schoolStateId = "1";
  String schoolCityId = "1";
  String schoolTypeId = "1";

  String managerCountryId = "1";
  String managerStateId = "1";
  String managerCityId = "1";

  int selectedGender = 1;
  int selectedMarital = 1;
  DateTime? dateOfBirth;
  String gender = "Male";
  String maritalStatus = "Single";

  final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$");
  final phoneRegex = RegExp(r"^[0-9]{7,15}$");
  late final bool isAdding;
  bool isEditing = true;
  @override
  void initState() {
    super.initState();
    final d = widget.details;
    isAdding = d == null;
    isEditing = isAdding ? true : false;
    name = TextEditingController(text: d?.school.name ?? "");
    schoolEmail = TextEditingController(text: d?.school.email ?? "");
    phone = TextEditingController(text: d?.school.phone ?? "");
    address = TextEditingController(text: d?.school.address ?? "");
    emis = TextEditingController(text: d?.school.emisNumber ?? "");

    managerEmail = TextEditingController(text: d?.manager.email ?? "");
    username = TextEditingController(text: d?.manager.userName ?? "");
    password = TextEditingController(text: "");

    nationalId = TextEditingController(text: d?.manager.nationalId ?? "");

    firstName = TextEditingController(text: d?.manager.firstName ?? "");
    middleName = TextEditingController(text: d?.manager.middleName ?? "");
    lastName = TextEditingController(text: d?.manager.lastName ?? "");

    managerPhone = TextEditingController(
      text: d?.manager.mobileNumber ?? "",
    );
    if (!isAdding) {
      selectedGender = GenderEnum.values
          .firstWhere(
            (element) => element.name == d?.manager.gender,
          )
          .index;
      selectedMarital = MaritalStatusEnum.values
          .firstWhere(
            (element) => element.name == d?.manager.maritalStatus,
          )
          .index;

      schoolStateId = syrianStatesMap[d!.school.stateName]!;
      schoolCityId = syrianStatesMap[d.school.cityName]!;
      schoolTypeId = schoolTypesMap[d.school.schoolTypeName]!;

      managerCountryId = countriesMap[d.manager.countryName]!;
      managerStateId = syrianStatesMap[d.manager.stateName]!;
      managerCityId = syrianStatesMap[d.manager.cityName]!;
    }

    dateOfBirth = d?.manager.dateOfBirth;
  }

  Widget _topBar(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// Back
        IconButton.filled(
          icon: const Icon(Icons.arrow_back_rounded),
          iconSize: 40,
          padding: EdgeInsets.zero,
          onPressed: () {
            ref.read(schoolsBreadcrumbProvider.notifier).pop();

            Get.back(id: Sroutes.schoolsNavigationId);
          },
        ),

        /// Edit
        if (!isEditing && widget.details != null)
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: SConfig.accentColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              setState(() {
                isEditing = true;
              });
            },
            iconAlignment: IconAlignment.end,
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
            label: Text(
              loc.edit,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
      ],
    );
  }

  Widget _dateField(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return SizedBox(
      width: _fieldWidth(),
      child: TextFormField(
        enabled: isEditing,
        readOnly: true,
        style: const TextStyle(fontWeight: FontWeight.bold),
        controller: TextEditingController(
          text: dateOfBirth == null
              ? ""
              : "${dateOfBirth!.year}-${dateOfBirth!.month}-${dateOfBirth!.day}",
        ),
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
                  });
                }
              }
            : null,
      ),
    );
  }

  double _fieldWidth() {
    if (SConfig.isMobile()) return double.infinity;

    if (SConfig.isTablet()) return 300;

    return 340;
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

        decoration: InputDecoration(
          labelText: label,
        ),
        items: [
          ...items.map(
            (e) => DropdownMenuItem(
              value: e.id,
              child: Text(e.value),
            ),
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

        decoration: InputDecoration(
          labelText: label,
        ),
        items: items,
        onChanged: isEditing ? onChanged : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SConfig.init(context);

    final loc = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔙 Top Bar
                  _topBar(context),

                  SConfig.spaceBig,

                  /// =========================
                  /// 🏫 SCHOOL SECTION
                  /// =========================
                  _sectionTitle(context, loc.schoolInformation),

                  /// School Name
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _textField(
                        context,
                        name,
                        loc.schoolName,
                        enabled: isEditing,
                      ),
                      _textField(
                        context,
                        emis,
                        loc.emisNumber,
                        enabled: isEditing,
                        hint: "EMIS-2024-001",
                      ),
                      buildDropdown(
                        label: loc.schoolType,
                        value: schoolTypeId,

                        onChanged: (v) => setState(() => schoolTypeId = v!),
                        items: getSchoolTypes(loc),
                      ),
                    ],
                  ),

                  SConfig.spaceBig,

                  /// Contact
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _textField(
                        context,
                        schoolEmail,
                        loc.schoolEmail,
                        hint: "suhaib@example.com",
                        keyboard: TextInputType.emailAddress,
                        validator: (v) =>
                            emailRegex.hasMatch(v!) ? null : loc.invalidEmail,
                        enabled: isEditing,
                      ),
                      _textField(
                        context,
                        phone,
                        loc.phone,
                        keyboard: TextInputType.phone,
                        validator: (v) =>
                            phoneRegex.hasMatch(v!) ? null : loc.invalidPhone,
                        enabled: isEditing,
                        hint: "09498561",
                      ),
                    ],
                  ),

                  SConfig.spaceBig,

                  /// Address

                  // Location
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _textField(
                        context,
                        address,
                        loc.address,
                        enabled: isEditing,
                      ),
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

                  SConfig.spaceBig,

                  /// =========================
                  /// 👤 MANAGER SECTION
                  /// =========================
                  _sectionTitle(context, loc.managerInformation),

                  /// Account Info
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _textField(
                        context,
                        managerEmail,
                        loc.managerEmail,
                        enabled: isEditing,
                        hint: "suhaib@example.com",
                      ),
                      _textField(
                        context,
                        username,
                        loc.username,
                        enabled: isEditing,
                      ),

                      if (isAdding)
                        _textField(
                          context,
                          password,
                          loc.password,
                          enabled: isEditing,
                        ),
                      _textField(
                        context,
                        managerPhone,
                        loc.managerPhone,
                        keyboard: TextInputType.phone,
                        enabled: isEditing,
                        hint: "09498561",
                      ),
                    ],
                  ),

                  SConfig.spaceBig,

                  /// Manager Name
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
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
                        keyboard: TextInputType.number,
                        enabled: isEditing,
                        hint: "***03180036",
                      ),
                    ],
                  ),

                  SConfig.spaceBig,

                  /// Identity

                  /// Personal Info
                  Wrap(
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

                  SConfig.spaceBig,

                  /// Manager Location
                  Wrap(
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

                  SConfig.spaceBig,

                  /// =========================
                  /// SAVE BUTTON
                  /// =========================
                  Align(
                    alignment: Alignment.centerRight,
                    child: Wrap(
                      spacing: 16,
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (isEditing)
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: SConfig.successColor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            iconAlignment: IconAlignment.end,
                            icon: const Icon(
                              Icons.save,
                              // color: Colors.white,
                            ),
                            label: Text(
                              loc.save,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            onPressed: () async {
                              ///TODO apply logic api either addinf or updating:
                              ///adding: return {
                              //   "email": email,
                              //   "username": username,
                              //   "password": password,
                              //   "nationalId": NAT-nationalId,
                              //   "firstName": firstName,
                              //   "middleName": middleName,
                              //   "lastName": lastName,
                              //   "phone": phone,
                              //   "gender": gender,
                              //   "maritalStatus": maritalStatus,
                              //   "dateOfBirth": dateOfBirth.toIso8601String(),
                              //   "countryId": countryId,
                              //   "stateId": stateId,
                              //   "cityId": cityId,
                              // };
                              // if (_formKey.currentState!.validate()) {
                              final bool? continuee = await Get.dialog<bool>(
                                ConfirmationDialog(
                                  message: loc.confirmAction,
                                  onConfirm: () {
                                    Get.back<bool>(result: true);
                                  },
                                ),
                                barrierDismissible: false,
                              );

                              if (continuee != null && continuee) {
                                await Get.showOverlay(
                                  asyncFunction: () async =>
                                      await Future.delayed(
                                        const Duration(seconds: 4),
                                      ),
                                  loadingWidget: LoadingDialog(
                                    extraMessage: loc.savingForm,
                                    loading:
                                        LoadingAnimationWidget.discreteCircle(
                                          color: SConfig.secondaryBackground,
                                          secondRingColor: SConfig.accentColor,
                                          thirdRingColor: SConfig.primaryColor,
                                          size: 90,
                                        ),
                                  ),
                                );
                                ref
                                    .read(schoolsBreadcrumbProvider.notifier)
                                    .pop();
                                Get.back(id: Sroutes.schoolsNavigationId);
                              } else {
                                await Get.dialog<bool>(
                                  ErrorDialog(
                                    message: loc.errorOccurred,
                                  ),
                                  barrierDismissible: false,
                                );
                              }

                              // }
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SConfig.spaceMedium,

        Divider(
          color: SConfig.primaryColor.withAlpha(120),
          thickness: 1.2,
        ),
        SConfig.spaceMedium,
      ],
    );
  }

  Widget _textField(
    BuildContext context,
    TextEditingController controller,
    String label, {
    bool enabled = true,
    TextInputType? keyboard,
    String? hint,
    String? Function(String?)? validator,
  }) {
    return SizedBox(
      width: _fieldWidth(),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        // textDirection: TextDirection.rtl,
        style: const TextStyle(fontWeight: FontWeight.bold),
        keyboardType: keyboard,
        validator: validator ?? (v) => v!.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          hintText: hint,
          labelText: label,
        ),
      ),
    );
  }
}

import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/models/enums/gender.dart';
import 'package:educational_complex_director_app/models/enums/marital_status.dart';
import 'package:educational_complex_director_app/models/school_details.dart';

import 'package:educational_complex_director_app/utils/s_config.dart';
import 'package:educational_complex_director_app/view/components/loading_dialog.dart';

import 'package:educational_complex_director_app/view_model/schools_page_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';

class SchoolInfoForm extends ConsumerStatefulWidget {
  final SchoolDetails? details;
  final bool isEditing;

  const SchoolInfoForm({
    super.key,
    this.details,
    this.isEditing = true,
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
  String? schoolStateId;
  String? schoolCityId;
  String? schoolTypeId;

  String? managerCountryId;
  String? managerStateId;
  String? managerCityId;

  GenderEnum selectedGender = GenderEnum.male;
  MaritalStatusEnum selectedMarital = MaritalStatusEnum.single;
  DateTime? dateOfBirth;
  String gender = "Male";
  String maritalStatus = "Single";

  final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$");
  final phoneRegex = RegExp(r"^[0-9]{7,15}$");

  @override
  void initState() {
    super.initState();

    final d = widget.details;

    name = TextEditingController(text: d?.school.name ?? "");
    schoolEmail = TextEditingController(text: d?.school.email ?? "");
    phone = TextEditingController(text: d?.school.phone ?? "");
    address = TextEditingController(text: d?.school.address ?? "");
    emis = TextEditingController(text: d?.school.emisNumber ?? "");

    schoolStateId = d?.school.stateId ?? "1";
    schoolCityId = d?.school.cityId ?? "1";
    schoolTypeId = d?.school.schoolTypeId ?? "1";

    managerEmail = TextEditingController(text: d?.manager.managerEmail ?? "");
    username = TextEditingController(text: d?.manager.userName ?? "");
    password = TextEditingController(text: d?.manager.password ?? "");

    nationalId = TextEditingController(text: d?.manager.nationalId ?? "");

    firstName = TextEditingController(text: d?.manager.firstName ?? "");
    middleName = TextEditingController(text: d?.manager.middleName ?? "");
    lastName = TextEditingController(text: d?.manager.lastName ?? "");

    managerPhone = TextEditingController(
      text: d?.manager.managerMobileNumber ?? "",
    );

    selectedGender = d?.manager.gender ?? GenderEnum.male;
    selectedMarital = d?.manager.maritalStatus ?? MaritalStatusEnum.single;

    managerCountryId = d?.manager.managerCountryId ?? "1";
    managerStateId = d?.manager.managerStateId ?? "1";
    managerCityId = d?.manager.managerCityId ?? "1";

    dateOfBirth = d?.manager.dateOfBirth;
  }

  Widget _dropdown<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required Function(T?) onChanged,
    bool enabled = true,
  }) {
    return SizedBox(
      width: _fieldWidth(),
      child: DropdownButtonFormField<T>(
        initialValue: value,
        items: items,
        onChanged: enabled ? onChanged : null,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final navVm = ref.read(schoolsPageNavigationProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// Back
        IconButton.filled(
          icon: const Icon(Icons.arrow_back_rounded),
          iconSize: 40,
          padding: EdgeInsets.zero,
          onPressed: () {
            navVm.goBackToList();
          },
        ),

        /// Edit
        if (!widget.isEditing && widget.details != null)
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: SConfig.accentColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: navVm.enableEdit,
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
        enabled: widget.isEditing,
        readOnly: true,
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
        onTap: widget.isEditing
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
    if (SConfig.isTablet()) return 350;
    return 420;
  }

  @override
  Widget build(BuildContext context) {
    SConfig.init(context);

    final loc = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(26, 8, 26, 26),
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
                  children: [
                    _textField(
                      context,
                      name,
                      loc.schoolName,
                      enabled: widget.isEditing,
                    ),
                    _textField(
                      context,
                      emis,
                      loc.emisNumber,
                      enabled: widget.isEditing,
                    ),
                    _dropdown<String>(
                      label: loc.schoolType,
                      value: schoolTypeId!,
                      enabled: widget.isEditing,
                      onChanged: (v) => setState(() => schoolTypeId = v),
                      items: const [
                        DropdownMenuItem(value: "1", child: Text("Public")),
                        DropdownMenuItem(value: "2", child: Text("Private")),
                      ],
                    ),
                  ],
                ),

                SConfig.spaceBig,

                /// Contact
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    _textField(
                      context,
                      schoolEmail,
                      loc.schoolEmail,
                      keyboard: TextInputType.emailAddress,
                      validator: (v) =>
                          emailRegex.hasMatch(v!) ? null : loc.invalidEmail,
                      enabled: widget.isEditing,
                    ),
                    _textField(
                      context,
                      phone,
                      loc.phone,
                      keyboard: TextInputType.phone,
                      validator: (v) =>
                          phoneRegex.hasMatch(v!) ? null : loc.invalidPhone,
                      enabled: widget.isEditing,
                    ),
                  ],
                ),

                SConfig.spaceBig,

                /// Address

                /// EMIS + Location
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    _textField(
                      context,
                      address,
                      loc.address,
                      enabled: widget.isEditing,
                    ),
                    _dropdown<String>(
                      label: loc.stateId,
                      value: schoolStateId!,
                      enabled: widget.isEditing,
                      onChanged: (v) => setState(() => schoolStateId = v),
                      items: const [
                        DropdownMenuItem(value: "1", child: Text("State 1")),
                        DropdownMenuItem(value: "2", child: Text("State 2")),
                      ],
                    ),

                    _dropdown<String>(
                      label: loc.cityId,
                      value: schoolCityId!,
                      enabled: widget.isEditing,
                      onChanged: (v) => setState(() => schoolCityId = v),
                      items: const [
                        DropdownMenuItem(value: "1", child: Text("City 1")),
                        DropdownMenuItem(value: "2", child: Text("City 2")),
                      ],
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
                  children: [
                    _textField(
                      context,
                      managerEmail,
                      loc.managerEmail,
                      enabled: widget.isEditing,
                    ),
                    _textField(
                      context,
                      username,
                      loc.username,
                      enabled: widget.isEditing,
                    ),
                    _textField(
                      context,
                      password,
                      loc.password,
                      enabled: widget.isEditing,
                    ),
                    _textField(
                      context,
                      managerPhone,
                      loc.managerPhone,
                      keyboard: TextInputType.phone,
                      enabled: widget.isEditing,
                    ),
                  ],
                ),

                SConfig.spaceBig,

                /// Manager Name
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    _textField(
                      context,
                      firstName,
                      loc.firstName,
                      enabled: widget.isEditing,
                    ),
                    _textField(
                      context,
                      middleName,
                      loc.middleName,
                      enabled: widget.isEditing,
                    ),
                    _textField(
                      context,
                      lastName,
                      loc.lastName,
                      enabled: widget.isEditing,
                    ),
                    _textField(
                      context,
                      nationalId,
                      loc.nationalId,
                      keyboard: TextInputType.number,
                      enabled: widget.isEditing,
                    ),
                  ],
                ),

                SConfig.spaceBig,

                /// Identity

                /// Personal Info
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    _dropdown<GenderEnum>(
                      label: loc.gender,
                      value: selectedGender,
                      enabled: widget.isEditing,
                      onChanged: (v) => setState(() => selectedGender = v!),
                      items: GenderEnum.values
                          .map(
                            (g) => DropdownMenuItem(
                              value: g,
                              child: Text(g.loc(loc)),
                            ),
                          )
                          .toList(),
                    ),

                    _dropdown<MaritalStatusEnum>(
                      label: loc.maritalStatus,
                      value: selectedMarital,
                      enabled: widget.isEditing,
                      onChanged: (v) => setState(() => selectedMarital = v!),
                      items: MaritalStatusEnum.values
                          .map(
                            (m) => DropdownMenuItem(
                              value: m,
                              child: Text(m.loc(loc)),
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
                  children: [
                    _dropdown<String>(
                      label: loc.country,
                      value: managerCountryId!,
                      enabled: widget.isEditing,
                      onChanged: (v) => setState(() => managerCountryId = v),
                      items: const [
                        DropdownMenuItem(value: "1", child: Text("Syria")),
                        DropdownMenuItem(value: "2", child: Text("Jordan")),
                      ],
                    ),

                    _dropdown<String>(
                      label: loc.stateId,
                      value: managerStateId!,
                      enabled: widget.isEditing,
                      onChanged: (v) => setState(() => managerStateId = v),
                      items: const [
                        DropdownMenuItem(value: "1", child: Text("Damascus")),
                        DropdownMenuItem(value: "2", child: Text("Homs")),
                      ],
                    ),

                    _dropdown<String>(
                      label: loc.cityId,
                      value: managerCityId!,
                      enabled: widget.isEditing,
                      onChanged: (v) => setState(() => managerCityId = v),
                      items: const [
                        DropdownMenuItem(value: "1", child: Text("City 1")),
                        DropdownMenuItem(value: "2", child: Text("City 2")),
                      ],
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
                    children: [
                      if (widget.isEditing)
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
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await Get.showOverlay(
                                asyncFunction: () async => await Future.delayed(
                                  const Duration(seconds: 4),
                                ),
                                loadingWidget: const LoadingDialog(
                                  extraMessage:
                                      "Please wait while we save the form.",
                                ),
                              );
                              ref
                                  .read(schoolsPageNavigationProvider.notifier)
                                  .goBackToList();
                            }
                          },
                          icon: const Icon(Icons.save),
                          label: Text(loc.save),
                        ),
                    ],
                  ),
                ),
              ],
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

        const Divider(
          color: SConfig.primaryColor,
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
          labelText: label,
        ),
      ),
    );
  }
}

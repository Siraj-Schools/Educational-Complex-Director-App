import 'dart:async';

import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/models/constants/gender.dart';
import 'package:educational_complex_director_app/models/constants/marital_status.dart';
import 'package:educational_complex_director_app/models/geography.dart';
import 'package:educational_complex_director_app/models/school/school_manager.dart';
import 'package:educational_complex_director_app/routes/routes.dart';
import 'package:educational_complex_director_app/utils/s_config.dart';
import 'package:educational_complex_director_app/view/components/confirmation_dialog.dart';
import 'package:educational_complex_director_app/view/components/error_dialog.dart';
import 'package:educational_complex_director_app/view/components/geo_error.dart';
import 'package:educational_complex_director_app/view/components/geo_loading.dart';
import 'package:educational_complex_director_app/view/components/loading_dialog.dart';
import 'package:educational_complex_director_app/view_model/Geography/cities.dart';
import 'package:educational_complex_director_app/view_model/Geography/countries.dart';
import 'package:educational_complex_director_app/view_model/Geography/states.dart';
import 'package:educational_complex_director_app/view_model/bread_crumb_notifier.dart';
import 'package:educational_complex_director_app/view_model/schoolmanager/school_manager_details.dart';
import 'package:educational_complex_director_app/view_model/schoolmanager/school_managers.dart';
import 'package:educational_complex_director_app/view_model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ManagerInfoForm extends ConsumerStatefulWidget {
  const ManagerInfoForm({super.key, this.manager});
  final SchoolManager? manager;
  @override
  ConsumerState<ManagerInfoForm> createState() => _ManagerInfoFormState();
}

class _ManagerInfoFormState extends ConsumerState<ManagerInfoForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController managerEmail;
  late TextEditingController username;
  late TextEditingController password;
  late TextEditingController nationalId;
  late TextEditingController firstName;
  late TextEditingController middleName;
  late TextEditingController lastName;
  late TextEditingController managerPhone;

  String managerCountryId = '11111111-1111-1111-1111-111111111111';
  String managerStateId = '11111111-1111-1111-1111-111111111112';
  String managerCityId = '11111111-1111-1111-1111-111111110201';

  int selectedGender = 1;
  int selectedMarital = 1;
  DateTime? dateOfBirth;

  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$');
  final phoneRegex = RegExp(r'^[0-9]{7,15}$');
  late final bool isAdding;

  bool isManagerEditing = false;
  bool isSomethingEdited = false;
  Timer? debounce;

  @override
  void dispose() {
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

  @override
  void initState() {
    super.initState();
    final d = widget.manager;
    isAdding = d == null;
    isManagerEditing = isAdding;
    managerEmail = TextEditingController(text: d?.email ?? '');
    username = TextEditingController(text: d?.userName ?? '');
    password = TextEditingController(text: '');
    nationalId = TextEditingController(text: d?.nationalId ?? '');
    firstName = TextEditingController(text: d?.firstName ?? '');
    middleName = TextEditingController(text: d?.middleName ?? '');
    lastName = TextEditingController(text: d?.lastName ?? '');
    managerPhone = TextEditingController(text: d?.mobileNumber ?? '');
    if (!isAdding) {
      if (d != null) {
        selectedGender = d.gender.index;
        selectedMarital = d.maritalStatus.index;
      }
    }
    dateOfBirth = d?.dateOfBirth;
  }

  double _fieldWidth() {
    if (SConfig.isMobile()) return double.infinity;
    if (SConfig.isTablet()) return 280;
    return 300;
  }

  Widget _textField(
    BuildContext context,
    TextEditingController controller,
    String label, {
    required bool enabled,
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
        obscureText: obscure,
        onChanged: (value) {
          if (!isSomethingEdited) {
            setState(() {
              isSomethingEdited = true;
            });
          }
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
            size: 20,
            color: SConfig.primaryColor, // Deep Blue/Royal Blue
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
        menuMaxHeight: 300,
        isExpanded: true,
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
    bool? isSectionEditing,
    VoidCallback? onEdit,
    VoidCallback? onSave,
    VoidCallback? onCancel,
  }) {
    final theme = Theme.of(context);
    const accent = Color(0xFF3F51B5); // Royal Blue

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withAlpha(50), width: 1),
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
                    color: accent.withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: accent),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: SConfig.textDark,
                  ),
                ),
                const Spacer(),
                if (!isAdding && onEdit != null)
                  if (isSectionEditing == true)
                    Row(
                      children: [
                        if (!isSomethingEdited)
                          TextButton(
                            onPressed: onCancel,
                            child: Text(AppLocalizations.of(context)!.cancel),
                          ),

                        const SizedBox(width: 8),
                        if (isSomethingEdited)
                          ElevatedButton.icon(
                            onPressed: isSomethingEdited ? onSave : null,
                            icon: const Icon(Icons.save, size: 18),
                            label: Text(AppLocalizations.of(context)!.save),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: SConfig.successColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
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
                      label: Text(AppLocalizations.of(context)!.edit),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
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
            child: Divider(thickness: 1, color: Color(0xFFE0E0E0)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
            child: content,
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

    final String dobStr = dateOfBirth == null
        ? ""
        : '${dateOfBirth!.year}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}';

    final body = isAdding
        ? {
            "email": managerEmail.text,
            "password": password.text,
            "userName": username.text,
            "nationalId": nationalId.text,
            "firstName": firstName.text,
            "middleName": middleName.text,
            "lastName": lastName.text,
            "mobileNumber": managerPhone.text,
            "gender": selectedGender,
            "dateOfBirth": dobStr,
            "maritalStatus": selectedMarital,
            "cityId": managerCityId,
            "stateId": managerStateId,
            "countryId": managerCountryId,
          }
        : {
            "userId": widget.manager!.userId,
            "firstName": firstName.text,
            "middleName": middleName.text,
            "lastName": lastName.text,
            "mobileNumber": managerPhone.text,
            "gender": selectedGender,
            "dateOfBirth": dobStr,
            "email": managerEmail.text,
          };

    final success = await Get.showOverlay<bool>(
      asyncFunction: () async {
        if (isAdding) {
          final notifier = ref.read(
            schoolManagersNotifierProvider(true).notifier,
          );

          await notifier.createManager(body);
          return notifier.errorAddingManager == null;
        } else {
          final detailsNotifier = ref.read(
            schoolManagerDetailsNotifierProvider(
              widget.manager!.userId,
            ).notifier,
          );
          await detailsNotifier.updateManager(widget.manager!.userId, body);
          return detailsNotifier.error == null;
        }
      },
      loadingWidget: LoadingDialog(
        extraMessage: loc.savingForm,
        loading: LoadingAnimationWidget.discreteCircle(
          color: const Color(0xFF3F51B5),
          secondRingColor: SConfig.accentColor,
          thirdRingColor: SConfig.primaryColor,
          size: 90,
        ),
      ),
    );

    if (success == true) {
      if (isAdding) {
        ref.invalidate(schoolManagersNotifierProvider(false), asReload: true);
        ref.invalidate(schoolManagersNotifierProvider(true), asReload: true);

        ref.read(managersBreadcrumbProvider.notifier).pop();
        Get.back(id: Sroutes.managersNavigationId);
      } else {
        await ref
            .read(
              schoolManagerDetailsNotifierProvider(
                widget.manager!.userId,
              ).notifier,
            )
            .refresh();
        if (mounted) {
          setState(() {
            isManagerEditing = false;
            isSomethingEdited = false;
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

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDirector =
        ref.watch(userViewModelProvider).value?.isDirector ?? false;
    const accent = Color(0xFF3F51B5);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isAdding) ...[
                  IconButton.filled(
                    icon: const Icon(Icons.arrow_back_rounded),

                    style: IconButton.styleFrom(
                      backgroundColor: accent.withAlpha(20),
                      foregroundColor: accent,
                    ),
                    onPressed: () {
                      ref.read(managersBreadcrumbProvider.notifier).pop();
                      Get.back(id: Sroutes.managersNavigationId);
                    },
                  ),
                ],
                const SizedBox(height: 20),

                if (!isAdding && !isManagerEditing && isDirector)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: accent.withAlpha(15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: accent.withAlpha(60),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          color: Color(0xFF3F51B5),
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            loc.viewModeHint,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: accent,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // ── ACCOUNT SECTION ──────────────────────────────────────────────────
                _sectionCard(
                  context: context,
                  icon: Icons.person_pin_rounded,
                  title: loc.accountInformation,
                  isSectionEditing: isManagerEditing,
                  onEdit: isDirector
                      ? () => setState(() => isManagerEditing = true)
                      : null,
                  onSave: () => _handleSave(context),
                  onCancel: () => setState(() {
                    isManagerEditing = false;
                    isSomethingEdited = false;
                  }),
                  content: Wrap(
                    spacing: 24,
                    runSpacing: 20,
                    children: [
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
                          enabled: true,
                          obscure: false,
                        ),
                      _textField(
                        context,
                        managerEmail,
                        loc.email,
                        enabled: isManagerEditing,
                        keyboard: TextInputType.emailAddress,
                        validator: (v) => emailRegex.hasMatch(v ?? '')
                            ? null
                            : loc.invalidEmail,
                      ),
                    ],
                  ),
                ),

                // ── PERSONAL SECTION ─────────────────────────────────────────────────
                _sectionCard(
                  context: context,
                  icon: Icons.person_outline_rounded,
                  title: loc.personalInformation,
                  content: Wrap(
                    spacing: 24,
                    runSpacing: 20,
                    children: [
                      _textField(
                        context,
                        firstName,
                        loc.firstName,
                        enabled: isManagerEditing,
                      ),
                      _textField(
                        context,
                        middleName,
                        loc.middleName,
                        enabled: isManagerEditing,
                      ),
                      _textField(
                        context,
                        lastName,
                        loc.lastName,
                        enabled: isManagerEditing,
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
                        managerPhone,
                        loc.phone,
                        enabled: isManagerEditing,
                        keyboard: TextInputType.phone,
                        validator: (v) => phoneRegex.hasMatch(v ?? '')
                            ? null
                            : loc.invalidPhone,
                      ),
                      buildDropdownEnums(
                        label: loc.gender,
                        value: selectedGender,
                        enabled: isManagerEditing,
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
                      buildDropdownEnums(
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
                      _dateField(context, enabled: isManagerEditing),
                    ],
                  ),
                ),

                // ── LOCATION SECTION ─────────────────────────────────────────────────
                _sectionCard(
                  context: context,
                  icon: Icons.location_on_rounded,
                  title: loc.location,
                  content: ref
                      .watch(countriesProvider)
                      .when(
                        data: (countries) {
                          if (!countries.any((c) => c.id == managerCountryId) &&
                              countries.isNotEmpty) {
                            managerCountryId = countries.first.id;
                          }
                          return ref
                              .watch(schoolStatesProvider(managerCountryId))
                              .when(
                                data: (states) {
                                  if (!states.any(
                                        (s) => s.id == managerStateId,
                                      ) &&
                                      states.isNotEmpty) {
                                    managerStateId = states.first.id;
                                  }
                                  return Wrap(
                                    spacing: 24,
                                    runSpacing: 24,
                                    children: [
                                      _dropdownGeography(
                                        label: loc.country,
                                        items: countries,
                                        value: managerCountryId,
                                        enabled: isAdding,
                                        onChanged: (v) => setState(
                                          () => managerCountryId = v!,
                                        ),
                                      ),
                                      _dropdownGeography(
                                        label: loc.stateId,
                                        items: states,
                                        value: managerStateId,
                                        enabled: isAdding,
                                        onChanged: (v) =>
                                            setState(() => managerStateId = v!),
                                      ),
                                      ref
                                          .watch(
                                            schoolCitiesProvider(
                                              managerStateId,
                                            ),
                                          )
                                          .when(
                                            data: (cities) {
                                              if (!cities.any(
                                                    (c) =>
                                                        c.id == managerCityId,
                                                  ) &&
                                                  cities.isNotEmpty) {
                                                managerCityId = cities.first.id;
                                              }
                                              return _dropdownGeography(
                                                label: loc.cityId,
                                                items: cities,
                                                value: managerCityId,
                                                enabled: isAdding,
                                                onChanged: (v) => setState(
                                                  () => managerCityId = v!,
                                                ),
                                              );
                                            },
                                            loading: () =>
                                                const GeoLoading(color: accent),
                                            error: (e, s) => GeoError(
                                              onRetry: () {
                                                ref.invalidate(
                                                  schoolCitiesProvider(
                                                    managerStateId,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                    ],
                                  );
                                },
                                loading: () => const GeoLoading(color: accent),
                                error: (e, s) => GeoError(
                                  onRetry: () {
                                    ref.invalidate(
                                      schoolCitiesProvider(managerStateId),
                                    );
                                  },
                                ),
                              );
                        },
                        loading: () => const GeoLoading(color: accent),
                        error: (e, s) => GeoError(
                          onRetry: () {
                            ref.invalidate(countriesProvider);
                          },
                        ),
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
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          await _handleSave(context);
                        },
                        icon: const Icon(Icons.save, color: Colors.white),
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
}

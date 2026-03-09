import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/models/constants/school_types.dart';
import 'package:educational_complex_director_app/models/constants/states.dart';
import 'package:educational_complex_director_app/models/helpers/lookup_items.dart';
import 'package:educational_complex_director_app/models/school/school.dart';
import 'package:educational_complex_director_app/routes/routes.dart';

import 'package:educational_complex_director_app/utils/s_config.dart';

import 'package:educational_complex_director_app/view/pages/schoolspage/school_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';

class SchoolListPage extends ConsumerStatefulWidget {
  const SchoolListPage({super.key});

  @override
  ConsumerState<SchoolListPage> createState() => _SchoolListPageState();
}

class _SchoolListPageState extends ConsumerState<SchoolListPage>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController searchController = TextEditingController();

  String? selectedTypeId;
  String? selectedtCityId;
  String? selectedStateId;
  Widget buildDropdown({
    required String label,
    required List<LookupItem> items,
    required String? value,
    required Function(String?) onChanged,
    required AppLocalizations loc,
  }) {
    return DropdownButtonFormField<String?>(
      initialValue: value,
      menuMaxHeight: 300,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
      ),
      items: [
        DropdownMenuItem(
          value: null,
          child: Text(loc.all),
        ),
        ...items.map(
          (e) => DropdownMenuItem(
            value: e.id,
            child: Text(e.value),
          ),
        ),
      ],
      onChanged: onChanged,
    );
  }

  Widget filterField(Widget child, {bool? smaller}) {
    double width;

    if (SConfig.isMobile()) {
      (smaller != null)
          ? width = SConfig.screenWidth! * 0.30
          : width = SConfig.screenWidth! * 0.40;
    } else if (SConfig.isTablet()) {
      width = 200;
    } else {
      width = 220;
    }

    return SizedBox(
      width: width,
      child: child,
    );
  }

  final List<School> dummySchools = [
    School(
      id: '1',
      schoolType: "",
      schoolTypeDescription: "ssssssssssssssssss",
      name: "Future Academy",
      email: "info@future.com",
      phone: "123456789",
      address: "Oslo",
      stateName: "Damascus",
      cityName: "Damascus",
      schoolTypeName: "1",
      emisNumber: "EMIS00111111",
    ),
    School(
      id: '2',
      schoolType: "",
      schoolTypeDescription: "",
      name: "Future Academy",
      email: "info@future.com",
      phone: "123456789",
      address: "Osloooooooooo",
      stateName: "Damascus",
      cityName: "Damascus",
      schoolTypeName: "Primary",
      emisNumber: "EMIS001",
    ),
    School(
      id: '1',
      schoolType: "",
      schoolTypeDescription: "",
      name: "Future Academy",
      email: "info@future.com",
      phone: "123456789",
      address: "Oslo",
      stateName: "1",
      cityName: "1",
      schoolTypeName: "1",
      emisNumber: "EMIS001",
    ),
    School(
      id: '1',
      schoolType: "",
      schoolTypeDescription: "ssssssssssssssssss",
      name: "Future Academy",
      email: "info@future.com",
      phone: "123456789",
      address: "Oslo",
      stateName: "Damascus",
      cityName: "Damascus",
      schoolTypeName: "1",
      emisNumber: "EMIS00111111",
    ),
    School(
      id: '2',
      schoolType: "",
      schoolTypeDescription: "",
      name: "Future Academy",
      email: "info@future.com",
      phone: "123456789",
      address: "Osloooooooooo",
      stateName: "Damascus",
      cityName: "Damascus",
      schoolTypeName: "Primary",
      emisNumber: "EMIS001",
    ),
    School(
      id: '1',
      schoolType: "",
      schoolTypeDescription: "",
      name: "Future Academy",
      email: "info@future.com",
      phone: "123456789",
      address: "Oslo",
      stateName: "1",
      cityName: "1",
      schoolTypeName: "1",
      emisNumber: "EMIS001",
    ),
    School(
      id: '1',
      schoolType: "",
      schoolTypeDescription: "ssssssssssssssssss",
      name: "Future Academy",
      email: "info@future.com",
      phone: "123456789",
      address: "Oslo",
      stateName: "Damascus",
      cityName: "Damascus",
      schoolTypeName: "1",
      emisNumber: "EMIS00111111",
    ),
    School(
      id: '2',
      schoolType: "",
      schoolTypeDescription: "",
      name: "Future Academy",
      email: "info@future.com",
      phone: "123456789",
      address: "Osloooooooooo",
      stateName: "Damascus",
      cityName: "Damascus",
      schoolTypeName: "Primary",
      emisNumber: "EMIS001",
    ),
    School(
      id: '1',
      schoolType: "",
      schoolTypeDescription: "",
      name: "Future Academy",
      email: "info@future.com",
      phone: "123456789",
      address: "Oslo",
      stateName: "1",
      cityName: "1",
      schoolTypeName: "1",
      emisNumber: "EMIS001",
    ),
  ];
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final loc = AppLocalizations.of(context)!;

    SConfig.init(context);

    int crossAxisCount = 3;

    if (SConfig.isMobile()) {
      crossAxisCount = 1;
    } else if (SConfig.isTablet()) {
      crossAxisCount = 2;
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            decoration: BoxDecoration(
              color: SConfig.secondaryBackground.withAlpha(25),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: SConfig.secondaryBackground.withAlpha(60),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                /// SEARCH
                filterField(
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: loc.searchSchool,
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),

                /// SCHOOL TYPE
                filterField(
                  buildDropdown(
                    label: loc.schoolType,
                    value: selectedTypeId,
                    items: getSchoolTypes(loc),
                    loc: loc,
                    onChanged: (v) {
                      setState(() => selectedTypeId = v);
                    },
                  ),
                  smaller: true,
                ),

                /// STATE
                filterField(
                  buildDropdown(
                    label: loc.stateId,
                    value: selectedStateId,
                    items: getSyrianStates(loc),
                    loc: loc,
                    onChanged: (v) {
                      setState(() => selectedStateId = v);
                    },
                  ),
                  smaller: true,
                ),

                /// CITY
                filterField(
                  buildDropdown(
                    label: loc.cityId,
                    value: selectedtCityId,
                    items: getSyrianStates(loc),
                    loc: loc,
                    onChanged: (v) {
                      setState(() => selectedtCityId = v);
                    },
                  ),
                  smaller: true,
                ),

                /// ADD BUTTON
                SizedBox(
                  height: 40,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SConfig.accentColor.withGreen(100),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                    ),
                    onPressed: () => Get.toNamed(
                      Sroutes.addSchool,
                      id: Sroutes.schoolsNavigationId,
                    ),
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    iconAlignment: IconAlignment.end,
                    label: Text(
                      loc.addSchool,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SConfig.spaceMedium,

          /// GRID
          Expanded(
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,

                mainAxisExtent: 422,
              ),

              itemCount: dummySchools.length,
              itemBuilder: (_, index) {
                final school = dummySchools[index];

                return SchoolCard(
                  school: school,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

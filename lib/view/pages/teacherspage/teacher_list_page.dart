import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/models/constants/countries.dart';
import 'package:educational_complex_director_app/models/constants/states.dart';
import 'package:educational_complex_director_app/models/helpers/lookup_items.dart';
import 'package:educational_complex_director_app/models/teacher/teacher.dart';
import 'package:educational_complex_director_app/routes/routes.dart';

import 'package:educational_complex_director_app/utils/s_config.dart';

import 'package:educational_complex_director_app/view/pages/teacherspage/teacher_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';

class TeacherListPage extends ConsumerStatefulWidget {
  const TeacherListPage({super.key});

  @override
  ConsumerState<TeacherListPage> createState() => _SchoolListPageState();
}

class _SchoolListPageState extends ConsumerState<TeacherListPage>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController searchController = TextEditingController();

  String? selectedCountryId;
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
          : width = SConfig.screenWidth! * 0.42;
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

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }

  final List<Teacher> dummyTeachers = [
    Teacher(
      id: "1",
      userId: "user1",
      firstName: "Ahmed",
      middleName: "Ali",
      lastName: "Hassan",
      email: "ahmed.hassan@school.edu",
      nationalId: "NAT-100001",
      mobileNumber: "+963944000001",
      schoolId: "school1",
      schoolAcademicYearId: "year2026",
      qualificationName: "Undergraduate Degree",
      cityName: "Damascus",
      stateName: "Damascus",
      countryName: "Syria",
    ),
    Teacher(
      id: "2",
      userId: "user2",
      firstName: "Omar",
      middleName: "Khaled",
      lastName: "Mahmoud",
      email: "omar.mahmoud@school.edu",
      nationalId: "NAT-100002",
      mobileNumber: "+963944000002",
      schoolId: "school1",
      schoolAcademicYearId: "year2026",
      qualificationName: "Graduate Degree",
      cityName: "Homs",
      stateName: "Homs",
      countryName: "Syria",
    ),
    Teacher(
      id: "3",
      userId: "user3",
      firstName: "Yousef",
      middleName: "Saleh",
      lastName: "Abdullah",
      email: "yousef.abdullah@school.edu",
      nationalId: "NAT-100003",
      mobileNumber: "+963944000003",
      schoolId: "school2",
      schoolAcademicYearId: "year2026",
      qualificationName: "Undergraduate Degree",
      cityName: "Aleppo",
      stateName: "Aleppo",
      countryName: "Syria",
    ),
    Teacher(
      id: "4",
      userId: "user4",
      firstName: "Mahmoud",
      middleName: "Ibrahim",
      lastName: "Salem",
      email: "mahmoud.salem@school.edu",
      nationalId: "NAT-100004",
      mobileNumber: "+963944000004",
      schoolId: "school2",
      schoolAcademicYearId: "year2026",
      qualificationName: "Doctorate",
      cityName: "Latakia",
      stateName: "Latakia",
      countryName: "Syria",
    ),
    Teacher(
      id: "5",
      userId: "user5",
      firstName: "Khaled",
      middleName: "Hussein",
      lastName: "Nasser",
      email: "khaled.nasser@school.edu",
      nationalId: "NAT-100005",
      mobileNumber: "+963944000005",
      schoolId: "school3",
      schoolAcademicYearId: "year2026",
      qualificationName: "Graduate Degree",
      cityName: "Tartus",
      stateName: "Tartus",
      countryName: "Syria",
    ),
    Teacher(
      id: "6",
      userId: "user6",
      firstName: "Hassan",
      middleName: "Mustafa",
      lastName: "Yasin",
      email: "hassan.yasin@school.edu",
      nationalId: "NAT-100006",
      mobileNumber: "+963944000006",
      schoolId: "school3",
      schoolAcademicYearId: "year2026",
      qualificationName: "Undergraduate Degree",
      cityName: "Hama",
      stateName: "Hama",
      countryName: "Syria",
    ),
    Teacher(
      id: "7",
      userId: "user7",
      firstName: "Samir",
      middleName: "Adnan",
      lastName: "Fares",
      email: "samir.fares@school.edu",
      nationalId: "NAT-100007",
      mobileNumber: "+963944000007",
      schoolId: "school4",
      schoolAcademicYearId: "year2026",
      qualificationName: "Graduate Degree",
      cityName: "Idlib",
      stateName: "Idlib",
      countryName: "Syria",
    ),
    Teacher(
      id: "8",
      userId: "user8",
      firstName: "Bilal",
      middleName: "Tariq",
      lastName: "Karim",
      email: "bilal.karim@school.edu",
      nationalId: "NAT-100008",
      mobileNumber: "+963944000008",
      schoolId: "school4",
      schoolAcademicYearId: "year2026",
      qualificationName: "Undergraduate Degree",
      cityName: "Raqqa",
      stateName: "Raqqa",
      countryName: "Syria",
    ),
    Teacher(
      id: "9",
      userId: "user9",
      firstName: "Fadi",
      middleName: "Nabil",
      lastName: "Saad",
      email: "fadi.saad@school.edu",
      nationalId: "NAT-100009",
      mobileNumber: "+963944000009",
      schoolId: "school5",
      schoolAcademicYearId: "year2026",
      qualificationName: "Graduate Degree",
      cityName: "Daraa",
      stateName: "Daraa",
      countryName: "Syria",
    ),
    Teacher(
      id: "10",
      userId: "user10",
      firstName: "Rami",
      middleName: "Sami",
      lastName: "Haddad",
      email: "rami.haddad@school.edu",
      nationalId: "NAT-100010",
      mobileNumber: "+963944000010",
      schoolId: "school5",
      schoolAcademicYearId: "year2026",
      qualificationName: "Doctorate",
      cityName: "Damascus",
      stateName: "Damascus",
      countryName: "Syria",
    ),
    Teacher(
      id: "11",
      userId: "user11",
      firstName: "Ziad",
      middleName: "Farouk",
      lastName: "Hamdan",
      email: "ziad.hamdan@school.edu",
      nationalId: "NAT-100011",
      mobileNumber: "+963944000011",
      schoolId: "school6",
      schoolAcademicYearId: "year2026",
      qualificationName: "Undergraduate Degree",
      cityName: "Homs",
      stateName: "Homs",
      countryName: "Syria",
    ),
    Teacher(
      id: "12",
      userId: "user12",
      firstName: "Tariq",
      middleName: "Adel",
      lastName: "Najjar",
      email: "tariq.najjar@school.edu",
      nationalId: "NAT-100012",
      mobileNumber: "+963944000012",
      schoolId: "school6",
      schoolAcademicYearId: "year2026",
      qualificationName: "Graduate Degree",
      cityName: "Aleppo",
      stateName: "Aleppo",
      countryName: "Syria",
    ),
  ];
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
                      hintText: loc.searchTeacher,
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),

                filterField(
                  buildDropdown(
                    label: loc.country,
                    value: selectedCountryId,
                    items: getCountries(loc),
                    loc: loc,
                    onChanged: (v) {
                      setState(() => selectedCountryId = v);
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
                      Sroutes.addTeacher,
                      id: Sroutes.teachersNavigationId,
                    ),
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    iconAlignment: IconAlignment.end,
                    label: Text(
                      loc.addTeacher,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SConfig.spaceSmall,

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

              itemCount: dummyTeachers.length,
              itemBuilder: (_, index) {
                final teacher = dummyTeachers[index];

                return TeacherCard(teacher: teacher);
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

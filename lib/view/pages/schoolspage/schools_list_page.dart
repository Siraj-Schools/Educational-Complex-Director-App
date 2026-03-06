import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/models/school.dart';
import 'package:educational_complex_director_app/utils/enums/screen_names.dart';

import 'package:educational_complex_director_app/utils/s_config.dart';
import 'package:educational_complex_director_app/view/mainlayout/main_layout.dart';

import 'package:educational_complex_director_app/view/pages/schoolspage/school_card.dart';
import 'package:educational_complex_director_app/view_model/schools_page_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SchoolListPage extends ConsumerStatefulWidget {
  const SchoolListPage({super.key});

  @override
  ConsumerState<SchoolListPage> createState() => _SchoolListPageState();
}

class _SchoolListPageState extends ConsumerState<SchoolListPage> {
  final TextEditingController searchController = TextEditingController();
  String selectedType = "1";
  String selectedtCity = "1";
  String selectedState = "1";

  final List<School> dummySchools = [
    School(
      id: '1',

      name: "Future Academy",
      email: "info@future.com",
      phone: "123456789",
      address: "Oslo",
      stateId: "1",
      cityId: "1",
      schoolTypeId: "1",
      emisNumber: "EMIS001",
    ),
    School(
      id: '1',
      name: "Future Academy",
      email: "info@future.com",
      phone: "123456789",
      address: "Oslo",
      stateId: "1",
      cityId: "1",
      schoolTypeId: "1",
      emisNumber: "EMIS001",
    ),
    School(
      id: '1',

      name: "Future Academy",
      email: "info@future.com",
      phone: "123456789",
      address: "Oslo",
      stateId: "1",
      cityId: "1",
      schoolTypeId: "1",
      emisNumber: "EMIS001",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    SConfig.init(context);

    final vm = ref.read(schoolsPageNavigationProvider.notifier);

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
          Wrap(
            spacing: 16,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 280,
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: loc.searchSchool,
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: SConfig.accentColor.withGreen(100),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                ),
                onPressed: vm.goToAdd,
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
            ],
          ),
          SConfig.spaceMedium,

          /// FILTER PANEL
          Wrap(
            spacing: 16,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.center,

            children: [
              /// SEARCH

              /// TYPE FILTER
              SizedBox(
                width: 200,
                child: DropdownButtonFormField<String>(
                  initialValue: selectedType,

                  decoration: InputDecoration(
                    labelText: loc.schoolType,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: "1",
                      child: Text(loc.all),
                    ),
                    DropdownMenuItem(
                      value: "2",
                      child: Text(loc.privateSchool),
                    ),
                    DropdownMenuItem(
                      value: "3",
                      child: Text(loc.publicSchool),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => selectedType = value!);
                  },
                ),
              ),
              SizedBox(
                width: 200,
                child: DropdownButtonFormField<String>(
                  initialValue: selectedState,

                  decoration: InputDecoration(
                    labelText: loc.stateId,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: "1",
                      child: Text("State3"),
                    ),
                    DropdownMenuItem(
                      value: "2",
                      child: Text("State2"),
                    ),
                    DropdownMenuItem(
                      value: "3",
                      child: Text("State1"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => selectedState = value!);
                  },
                ),
              ),
              SizedBox(
                width: 200,
                child: DropdownButtonFormField<String>(
                  initialValue: selectedtCity,

                  decoration: InputDecoration(
                    labelText: loc.cityId,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: "1",
                      child: Text("City1"),
                    ),
                    DropdownMenuItem(
                      value: "2",
                      child: Text("City1"),
                    ),
                    DropdownMenuItem(
                      value: "3",
                      child: Text("City3"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => selectedtCity = value!);
                  },
                ),
              ),

              /// ADD SCHOOL BUTTON
            ],
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
                  onDetails: () {
                    vm.goToDetails(school.id);

                    // ref.read(breadCrumbProvider.notifier).state = [
                    //   ScreenNames.schools,
                    //   ScreenNames.schoolDetails,
                    // ];
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

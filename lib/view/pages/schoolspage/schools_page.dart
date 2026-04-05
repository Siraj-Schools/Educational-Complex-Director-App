// ignore_for_file: file_names

import 'package:educational_complex_director_app/routes/routes.dart';
import 'package:educational_complex_director_app/routes/enums/screen_names.dart';
import 'package:educational_complex_director_app/view/pages/schoolspage/school_details_page.dart';
import 'package:educational_complex_director_app/view/pages/schoolspage/school_info_form.dart';
import 'package:educational_complex_director_app/view/pages/schoolspage/schools_list_page.dart';
import 'package:educational_complex_director_app/view_model/bread_crumb_notifier.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';

class SchoolsPage extends ConsumerWidget {
  const SchoolsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BreadCrumbNotifier breadCrumbNotifier = ref.read(
      schoolsBreadcrumbProvider.notifier,
    );
    return Navigator(
      key: Get.nestedKey(Sroutes.schoolsNavigationId),
      onGenerateRoute: (settings) {
        if (settings.name == Sroutes.addSchool) {
          breadCrumbNotifier.setPath([
            ScreenNames.schools,
            ScreenNames.addSchool,
          ]);
          return GetPageRoute(
            page: () => const SchoolInfoForm(),
            settings: settings,
          );
        }

        if (settings.name!.startsWith(Sroutes.schoolDetails)) {
          final schoolId = settings.arguments as String;
          breadCrumbNotifier.setPath([
            ScreenNames.schools,
            ScreenNames.schoolDetails,
          ]);
          return GetPageRoute(
            page: () => SchoolDetailsPage(
              schoolId: schoolId,
            ),
            settings: settings,
          );
        }

        return GetPageRoute(
          page: () => const SchoolListPage(),
          settings: settings,
        );
      },
    );
  }
}

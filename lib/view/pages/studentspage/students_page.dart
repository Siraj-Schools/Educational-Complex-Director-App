import 'package:educational_complex_director_app/routes/routes.dart';
import 'package:educational_complex_director_app/utils/enums/screen_names.dart';
import 'package:educational_complex_director_app/view_model/bread_crumb_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class StudentsPage extends ConsumerWidget {
  const StudentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BreadCrumbNotifier breadCrumbNotifier = ref.read(
      studentsBreadcrumbProvider.notifier,
    );
    return Navigator(
      key: Get.nestedKey(Sroutes.studentsNavigationId),
      onGenerateRoute: (settings) {
        if (settings.name == Sroutes.addStudent) {
          breadCrumbNotifier.setPath([
            ScreenNames.students,
            ScreenNames.addStudent,
          ]);
          return GetPageRoute(
            page: () => const Placeholder(),
            settings: settings,
          );
        }

        if (settings.name!.startsWith(Sroutes.studentDetails)) {
          // final studentId = settings.arguments as String;
          breadCrumbNotifier.setPath([
            ScreenNames.students,
            ScreenNames.studentDetails,
          ]);
          return GetPageRoute(
            page: () => const Placeholder(),
            settings: settings,
          );
        }

        return GetPageRoute(
          page: () => const Placeholder(),
          settings: settings,
        );
      },
    );
  }
}

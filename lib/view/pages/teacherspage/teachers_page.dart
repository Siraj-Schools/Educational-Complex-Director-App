import 'package:educational_complex_director_app/routes/routes.dart';
import 'package:educational_complex_director_app/utils/enums/screen_names.dart';
import 'package:educational_complex_director_app/view/pages/teacherspage/teacher_details_page.dart';
import 'package:educational_complex_director_app/view/pages/teacherspage/teacher_info_form.dart';
import 'package:educational_complex_director_app/view/pages/teacherspage/teacher_list_page.dart';
import 'package:educational_complex_director_app/view_model/bread_crumb_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';

class TeachersPage extends ConsumerWidget {
  const TeachersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BreadCrumbNotifier breadCrumbNotifier = ref.read(
      teachersBreadcrumbProvider.notifier,
    );
    return Navigator(
      key: Get.nestedKey(Sroutes.teachersNavigationId),
      onGenerateRoute: (settings) {
        if (settings.name == Sroutes.addTeacher) {
          breadCrumbNotifier.setPath([
            ScreenNames.teachers,
            ScreenNames.addTeacher,
          ]);
          return GetPageRoute(
            page: () => const TeacherInfoForm(),
            settings: settings,
          );
        }

        if (settings.name!.startsWith(Sroutes.teacherDetails)) {
          final teacherUserId = settings.arguments as String;
          breadCrumbNotifier.setPath([
            ScreenNames.teachers,
            ScreenNames.teacherDetails,
          ]);
          return GetPageRoute(
            page: () => TeacherDetailsPage(
              teacherId: teacherUserId,
            ),
            settings: settings,
          );
        }

        return GetPageRoute(
          page: () => const TeacherListPage(),
          settings: settings,
        );
      },
    );
  }
}

import 'package:educational_complex_director_app/routes/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';

class TeachersPage extends ConsumerWidget {
  const TeachersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Navigator(
      key: Get.nestedKey(Sroutes.teachersNavigationId),
      onGenerateRoute: (settings) {
        if (settings.name == Sroutes.addSchool) {
          return GetPageRoute(
            page: () => const Placeholder(),
            settings: settings,
          );
        }

        if (settings.name!.startsWith(Sroutes.schoolDetails)) {
          final teacherUserId = settings.arguments as String;
          return GetPageRoute(
            page: () => const Placeholder(
              // schoolId: schoolId,
            ),
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

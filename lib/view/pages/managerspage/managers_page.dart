import 'package:educational_complex_director_app/routes/routes.dart';
import 'package:educational_complex_director_app/utils/enums/screen_names.dart';
import 'package:educational_complex_director_app/view/pages/managerspage/manager_details_page.dart';
import 'package:educational_complex_director_app/view/pages/managerspage/manager_info_form.dart';
import 'package:educational_complex_director_app/view/pages/managerspage/managers_list_page.dart';
import 'package:educational_complex_director_app/view_model/bread_crumb_notifier.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class ManagersPage extends ConsumerWidget {
  const ManagersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BreadCrumbNotifier breadCrumbNotifier = ref.read(
      managersBreadcrumbProvider.notifier,
    );
    return Navigator(
      key: Get.nestedKey(Sroutes.managersNavigationId),
      onGenerateRoute: (settings) {
        if (settings.name == Sroutes.addManager) {
          breadCrumbNotifier.setPath([
            ScreenNames.managers,
            ScreenNames.addManager,
          ]);
          return GetPageRoute(
            page: () => const ManagerInfoForm(),
            settings: settings,
          );
        }

        if (settings.name!.startsWith(Sroutes.managerDetails)) {
          final managerId = settings.arguments as String;
          breadCrumbNotifier.setPath([
            ScreenNames.managers,
            ScreenNames.managerDetails,
          ]);
          return GetPageRoute(
            page: () => ManagerDetailsPage(managerId: managerId),
            settings: settings,
          );
        }

        return GetPageRoute(
          page: () => const ManagersListPage(),
          settings: settings,
        );
      },
    );
  }
}

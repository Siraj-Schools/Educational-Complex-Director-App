

import 'package:educational_complex_director_app/routes/middle_ware.dart';
import 'package:educational_complex_director_app/view/pages/authpageresponsive/auth_page.dart';
import 'package:educational_complex_director_app/view/mainlayout/main_layout.dart';




import 'package:get/get_navigation/get_navigation.dart';

class Sroutes {
  static const auth = '/';
  static const main = '/main';
const Sroutes._();
}

class SAppRoute {
  static final List<GetPage> pages = [
    GetPage(
      name: Sroutes.auth,
      page: () => const AuthPage(),
      middlewares: [AuthRedirectMiddleware()],
    ),
    GetPage(
      name: Sroutes.main,
      page: () => const MainLayout(),
      middlewares: [AuthGuardMiddleware()],
    ),
   
  ];
}

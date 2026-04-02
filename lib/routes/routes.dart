import 'package:educational_complex_director_app/routes/middle_ware.dart';
import 'package:educational_complex_director_app/view/pages/authpage/auth_page.dart';
import 'package:educational_complex_director_app/view/mainlayout/main_layout.dart';

import 'package:get/get_navigation/get_navigation.dart';

class Sroutes {
  static const String auth = '/';
  static const String main = '/main';
  static const String schools = '/schools';
  static const String addSchool = '/schools/add';
  static const String schoolDetails = '/school/details';
  static const String teachers = '/teachers';
  static const String addTeacher = '/teacher/add';
  static const String teacherDetails = '/teachers/details';
  static const String managers = '/managers';
  static const String addManager = '/manager/add';
  static const String managerDetails = '/managers/details';
  static const String students = '/students';
  static const String addStudent = '/student/add';
  static const String studentDetails = '/students/details';
  ///////
  static const int schoolsNavigationId = 2;
  static const int teachersNavigationId = 3;
  static const int managersNavigationId = 4;
  static const int studentsNavigationId = 5;
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

import 'package:educational_complex_director_app/view/pages/schoolspage/schools_page.dart';
import 'package:educational_complex_director_app/view/pages/teacherspage/teachers_page.dart';
import 'package:flutter/material.dart';

class MainBody extends StatelessWidget {
  final PageController pageController;

  const MainBody({
    super.key,
    required this.pageController,
  });
  final List<Widget> pages = const [
    Center(
      child: Text(
        "Dashboard Page",
      ),
    ),
    SchoolsPage(),

    TeachersPage(),
    Center(
      child: Text(
        "Settings Page",
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),

      children: pages,
    );
  }
}

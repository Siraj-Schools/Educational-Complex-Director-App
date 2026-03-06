import 'package:educational_complex_director_app/view/pages/schoolspage/schools_page.dart';
import 'package:flutter/material.dart';

class MainBody extends StatelessWidget {
  final PageController pageController;

  const MainBody({
    super.key,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PageView(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),

      children: [
        Center(
          child: Text("Dashboard Page", style: theme.textTheme.headlineSmall),
        ),
        const SchoolsPage(),
        Center(
          child: Text("Courses Page", style: theme.textTheme.headlineSmall),
        ),
        Center(
          child: Text("Settings Page", style: theme.textTheme.headlineSmall),
        ),
      ],
    );
  }
}

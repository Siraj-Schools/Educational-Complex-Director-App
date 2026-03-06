import 'package:educational_complex_director_app/utils/enums/screen_names.dart';
import 'package:educational_complex_director_app/utils/s_config.dart';
import 'package:educational_complex_director_app/view/mainlayout/main_body.dart';
import 'package:educational_complex_director_app/view/mainlayout/main_drawer.dart';
import 'package:educational_complex_director_app/view/mainlayout/main_header.dart';
import 'package:educational_complex_director_app/view_model/schools_page_navigation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:get/get.dart';

class MainLayout extends ConsumerStatefulWidget {
  const MainLayout({super.key});

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  int selectedIndex = 0;
  final PageController _pageController = PageController();

  void onItemSelected(int index) async {
    if (selectedIndex == index) {
      return;
    }
    setState(() {
      selectedIndex = index;
    });
    ref.read(breadCrumbProvider.notifier).state = [
      index == 0
          ? ScreenNames.home
          : index == 1
          ? ScreenNames.schools
          : index == 2
          ? ScreenNames.applications
          : ScreenNames.settings,
    ];

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    if (!SConfig.isDesktop()) {
      // close drawer
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    SConfig.init(context);

    final drawer = MainDrawer(
      selectedIndex: selectedIndex,
      onItemSelected: onItemSelected,
    );

    const header = MainHeader();

    final body = MainBody(pageController: _pageController);
    final isDesktop = SConfig.isDesktop();
    return Scaffold(
      drawer: isDesktop ? null : drawer,
      appBar: !isDesktop ? header : null,
      body: Row(
        children: [
          if (isDesktop)
            SizedBox(
              width: 260,
              child: drawer,
            ),

          Expanded(
            child: Column(
              children: [
                if (isDesktop) header,
                Consumer(
                  builder: (context, ref, child) {
                    final items = ref.watch(breadCrumbProvider);
                    final theme = Theme.of(context);

                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: List.generate(items.length, (index) {
                          final isLast = index == items.length - 1;

                          return Row(
                            children: [
                              Text(
                                SConfig.getTitle(context, items[index]),
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: isLast
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: isLast
                                      ? SConfig.primaryColor
                                      : theme.colorScheme.onSurface.withAlpha(
                                          160,
                                        ),
                                ),
                              ),
                              if (!isLast)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Icon(
                                    Icons.chevron_right_rounded,
                                    size: 18,
                                    color: theme.colorScheme.onSurface
                                        .withAlpha(120),
                                  ),
                                ),
                            ],
                          );
                        }),
                      ),
                    );
                  },
                ),
                Expanded(child: body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final breadCrumbProvider = StateProvider<List<ScreenNames>>((ref) {
  final statess = ref.watch(schoolsPageNavigationProvider);
  if (ref.isFirstBuild) {
    return [ScreenNames.home];
  }
  switch (statess.view) {
    case SchoolsViewType.list:
      return [ScreenNames.schools];

    case SchoolsViewType.add:
      return [
        ScreenNames.schools,
        ScreenNames.addSchool,
      ];

    case SchoolsViewType.details:
      return [
        ScreenNames.schools,
        ScreenNames.schoolDetails,
      ];
  }
});

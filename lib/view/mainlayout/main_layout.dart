
import 'package:educational_complex_director_app/utils/s_config.dart';
import 'package:educational_complex_director_app/view/mainlayout/main_body.dart';
import 'package:educational_complex_director_app/view/mainlayout/main_drawer.dart';
import 'package:educational_complex_director_app/view/mainlayout/main_header.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';



class MainLayout extends ConsumerStatefulWidget {
  const MainLayout({super.key});

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  int selectedIndex = 0;
  final PageController _pageController = PageController();
  
  void onItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });

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

    const header =  MainHeader();

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
                Expanded(child: body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

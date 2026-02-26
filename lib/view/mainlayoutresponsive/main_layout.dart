import 'package:educational_complex_director_app/utils/s_responsive_layout.dart';
import 'package:educational_complex_director_app/view/mainlayoutresponsive/main_layout_desktop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainLayout extends ConsumerWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SResponsiveLayout(mobile: MainLayoutDesktop(), tablet: MainLayoutDesktop(), desktop: MainLayoutDesktop());


    
  }
}     
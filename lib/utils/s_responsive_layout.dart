import 'package:educational_complex_director_app/utils/config.dart';
import 'package:flutter/cupertino.dart';

class SResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const SResponsiveLayout({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure SConfig is initialized
    SConfig.init(context);

    if (SConfig.isDesktop()) {
      return desktop;
    } else if (SConfig.isTablet()) {
      return tablet;
    } else {
      return mobile;
    }
  }
}
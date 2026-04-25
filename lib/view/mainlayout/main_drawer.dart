import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/view/components/language_dropdown.dart';
import 'package:educational_complex_director_app/view_model/auth.dart';
import 'package:educational_complex_director_app/routes/routes.dart';

import 'package:educational_complex_director_app/utils/s_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';

class MainDrawer extends ConsumerWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const MainDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SConfig.init(context);

    return Drawer(
      elevation: 0,
      backgroundColor: Colors.transparent,
      shape: SConfig.isDesktop() ? const BeveledRectangleBorder() : null,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              SConfig.primaryColor,
              SConfig.secondaryBackground,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),

              // 🔰 LOGO SECTION
              _buildLogo(),

              const SizedBox(height: 10),

              // Soft separator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Divider(
                  color: Colors.white.withAlpha(51),
                  thickness: 1,
                ),
              ),

              const SizedBox(height: 10),

              // NAVIGATION
              _buildItem(
                context,
                Icons.school_rounded,
                AppLocalizations.of(context)!.schools,
                0,
              ),
              _buildItem(
                context,
                Icons.person_rounded,
                AppLocalizations.of(context)!.managers,
                1,
              ),
              _buildItem(
                context,
                Icons.app_registration_rounded,
                AppLocalizations.of(context)!.teachers,
                2,
              ),
              _buildItem(
                context,
                Icons.person_outline_rounded,
                AppLocalizations.of(context)!.students,
                3,
              ),

              const Spacer(),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: LanguageDropdown(
                      isWhiteBackGround: true,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Divider(
                  color: Colors.white.withAlpha(51),
                  thickness: 1,
                ),
              ),

              const SizedBox(height: 10),

              _buildLogout(context, ref),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // 🔰 LOGO
  // ============================================================

  Widget _buildLogo() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: SConfig.heightSize! * 0.18,
          height: SConfig.heightSize! * 0.18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              radius: 0.7,
              colors: [
                Colors.white,
                Colors.white.withAlpha(179),
                SConfig.secondaryBackground.withAlpha(102),
              ],
            ),
          ),
        ),
        Image.asset(
          "assets/logo.png",
          height: SConfig.heightSize! * 0.20,
        ),
      ],
    );
  }

  // ============================================================
  // 📋 NAV ITEM
  // ============================================================

  Widget _buildItem(
    BuildContext context,
    IconData icon,
    String title,
    int index,
  ) {
    final bool isSelected = selectedIndex == index;
    final theme = Theme.of(context);

    return _HoverTile(
      isSelected: isSelected,
      onTap: () => onItemSelected(index),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? SConfig.highlightColor : Colors.white,
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge!.copyWith(
            color: isSelected ? SConfig.highlightColor : Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // 🚪 LOGOUT
  // ============================================================

  Widget _buildLogout(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return _HoverTile(
      onTap: () async {
        await ref.read(authViewModelProvider.notifier).logout();
        await Get.offAllNamed(Sroutes.auth);
      },
      child: ListTile(
        leading: const Icon(Icons.logout_rounded, color: Colors.white),
        title: Text(
          AppLocalizations.of(context)!.logout,
          style: theme.textTheme.bodyLarge!.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

class _HoverTile extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final bool isSelected;

  const _HoverTile({
    required this.child,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  State<_HoverTile> createState() => _HoverTileState();
}

class _HoverTileState extends State<_HoverTile> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.isSelected
        ? Colors.white.withAlpha(38)
        : isHovering
        ? SConfig.highlightColor.withAlpha(40)
        : Colors.transparent;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: widget.onTap,
          child: widget.child,
        ),
      ),
    );
  }
}

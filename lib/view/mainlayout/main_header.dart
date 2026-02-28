

import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/utils/s_config.dart';
import 'package:educational_complex_director_app/view/mainlayout/notification_bell.dart';
import 'package:flutter/material.dart';

class MainHeader extends StatelessWidget implements PreferredSizeWidget {
  const MainHeader({super.key});

  @override
  Widget build(BuildContext context) {
    SConfig.init(context);
    final theme = Theme.of(context);

    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13 ),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          if (!SConfig.isDesktop())
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu_rounded),
                color: SConfig.primaryColor,
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),

          const Spacer(),

         

          // 👤 User Info with Avatar
          Row(
            spacing: 14,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: SConfig.primaryColor.withAlpha(25),
                child: const Icon(Icons.person, color: SConfig.primaryColor),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.director,
                    style: theme.textTheme.titleMedium,
                  ),
                  Text(
                    "director@siraj.edu",
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            
            ],
          ),
          const SizedBox(width: 25),
         const NotifiactionBell(),

        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(75);
}


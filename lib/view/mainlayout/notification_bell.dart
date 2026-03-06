import 'package:educational_complex_director_app/utils/s_config.dart';
import 'package:educational_complex_director_app/view/mainlayout/notifications_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class NotifiactionBell extends ConsumerWidget {
  const NotifiactionBell({
    super.key,
  });
  //TODO notifications icon with badge and add notifications ;pgic

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.notifications_none_rounded),
      color: SConfig.primaryColor,
      onPressed: () async {
        await Get.dialog(
          const NotificationsDialog(),
        );
      },
    );
  }
}

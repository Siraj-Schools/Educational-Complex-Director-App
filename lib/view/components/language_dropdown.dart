import 'package:educational_complex_director_app/utils/s_config.dart';
import 'package:educational_complex_director_app/view_model/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';

class LanguageDropdown extends ConsumerWidget {
  const LanguageDropdown({super.key, this.isWhiteBackGround = false});
  final bool isWhiteBackGround;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageViewModelProvider);
    return language.when(
      data: (value) {
        return PopupMenuButton<String>(
          initialValue: value,

          tooltip: 'Select Language',
          menuPadding: EdgeInsets.zero,

          shape: BeveledRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(4),
          ),
          borderRadius: BorderRadius.circular(30),
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.transparent),
            foregroundColor: WidgetStatePropertyAll(Colors.transparent),
            overlayColor: WidgetStatePropertyAll(Colors.transparent),
            shadowColor: WidgetStatePropertyAll(Colors.transparent),
            elevation: WidgetStatePropertyAll(0),
          ),
          onSelected: (String newValue) async {
            await ref
                .read(languageViewModelProvider.notifier)
                .setLanguage(newValue);
            await Get.updateLocale(Locale(newValue));
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'ar',
              child: Row(
                children: [
                  Icon(
                    Icons.language,
                    size: 18,
                    color: SConfig.secondaryBackground,
                  ),
                  SizedBox(width: 8),
                  Text('العربية'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'en',
              child: Row(
                children: [
                  Icon(
                    Icons.language,
                    size: 18,
                    color: SConfig.secondaryBackground,
                  ),
                  SizedBox(width: 8),
                  Text('English'),
                ],
              ),
            ),
          ],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            decoration: BoxDecoration(
              color: isWhiteBackGround
                  ? Colors.white
                  : SConfig.primaryColor.withAlpha(10),
              borderRadius: BorderRadius.circular(30),

              border: Border.all(
                color: SConfig.primaryColor.withAlpha(61),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.translate,
                  size: 16,
                  color: SConfig.primaryColor,
                ),
                const SizedBox(width: 6),
                Text(
                  value.toUpperCase(),
                  style: const TextStyle(
                    color: SConfig.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: SConfig.primaryColor,
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (err, _) => const SizedBox.shrink(),
    );
  }
}

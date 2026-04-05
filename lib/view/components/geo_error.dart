import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/utils/s_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GeoError extends ConsumerWidget {
  const GeoError({super.key, required this.onRetry});

  final void Function() onRetry;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: TextButton.icon(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: SConfig.errorColor,
        ),
        onPressed: onRetry,
        icon: const Icon(
          Icons.refresh,
          color: Colors.white,
        ),
        label: Text(
          AppLocalizations.of(context)!.retry,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

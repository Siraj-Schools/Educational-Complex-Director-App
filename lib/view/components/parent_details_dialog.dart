import 'dart:ui';
import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/models/constants/parent_relation.dart';
import 'package:educational_complex_director_app/models/student/parent.dart';
import 'package:educational_complex_director_app/utils/s_config.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class ParentDetailsDialog extends StatelessWidget {
  final Parent parent;

  const ParentDetailsDialog({
    super.key,
    required this.parent,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2A2F) : Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: SConfig.primaryColor.withAlpha(80),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(40),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: SConfig.primaryColor.withAlpha(30),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_search_rounded,
                      color: SConfig.primaryColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loc.parentFound,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: SConfig.primaryColor,
                              ),
                        ),
                        Text(
                          loc.confirmParentDetails,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Divider(),
              ),
              _detailRow(
                context,
                loc.name,
                parent.parentFullName,
                Icons.badge_outlined,
              ),
              _detailRow(
                context,
                loc.nationalId,
                parent.parentNationalId,
                Icons.fingerprint_rounded,
              ),
              _detailRow(
                context,
                loc.email,
                parent.parentEmail,
                Icons.email_outlined,
              ),
              _detailRow(
                context,
                loc.phone,
                parent.parentMobileNumber,
                Icons.phone_android_rounded,
              ),
              _detailRow(
                context,
                loc.relation,
                parent.parentRelation.loc(loc),
                Icons.family_restroom_rounded,
              ),

              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => Get.back(result: false),
                      child: Text(
                        loc.cancel,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SConfig.primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => Get.back(result: true),
                      child: Text(
                        loc.confirm,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: SConfig.primaryColor.withAlpha(180)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

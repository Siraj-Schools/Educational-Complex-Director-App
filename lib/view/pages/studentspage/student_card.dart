import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/models/student/student.dart';
import 'package:educational_complex_director_app/routes/routes.dart';
import 'package:educational_complex_director_app/utils/s_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentCard extends StatelessWidget {
  final Student student;
  const StudentCard({super.key, required this.student});

  Widget _infoLabel(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: SConfig.textDark.withAlpha(150),
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: SConfig.textDark,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const accent = Color.fromARGB(255, 164, 0, 0);

    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final initials = "${student.firstName[0]}${student.lastName[0]}"
        .toUpperCase();

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shadowColor: Colors.black.withAlpha(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: accent.withAlpha(40),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          /// BACKGROUND ACCENT
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: 8,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [accent, SConfig.secondaryBackground.withRed(100)],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER: AVATAR + NAME
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: accent.withAlpha(30),
                      child: Text(
                        initials,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: SConfig.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        student.fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// CONTACT INFO
                Row(
                  children: [
                    Expanded(
                      child: _infoLabel(context, loc.email, student.email),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// IDS
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: SConfig.backgroundLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _infoLabel(
                          context,
                          loc.standardName,
                          student.standardName,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _infoLabel(
                          context,
                          loc.nationalId,
                          student.nationalId,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                /// ACTION BUTTON
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: accent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Get.toNamed(
                        Sroutes.studentDetails,
                        id: Sroutes.studentsNavigationId,
                        arguments: student.id,
                      );
                    },
                    icon: const Icon(Icons.arrow_forward_ios, size: 14),
                    label: Text(
                      loc.seeDetails,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

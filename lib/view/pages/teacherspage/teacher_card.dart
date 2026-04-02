import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/models/constants/qualifications.dart';
import 'package:educational_complex_director_app/models/teacher/teacher.dart';
import 'package:educational_complex_director_app/routes/routes.dart';
import 'package:educational_complex_director_app/utils/s_config.dart';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class TeacherCard extends StatelessWidget {
  final Teacher teacher;

  const TeacherCard({
    super.key,
    required this.teacher,
  });

  Widget _infoBlock(
    BuildContext context,
    String label,
    String value, {
    TextDirection? textDirection,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: SConfig.textDark.withAlpha(150),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          textDirection: textDirection,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    SConfig.init(context);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(
          color: SConfig.secondaryBackground.withAlpha(35),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          /// HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 20,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  SConfig.primaryColor,
                  SConfig.secondaryBackground,
                ],
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// NAME
                Text(
                  teacher.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                /// QUALIFICATION BADGE
                _badge(
                  teacher.qualificationName.loc(loc),
                  SConfig.highlightColor,
                ),
              ],
            ),
          ),

          /// BODY
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _infoBlock(
                          context,
                          loc.phone,
                          teacher.mobileNumber,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _infoBlock(
                          context,
                          loc.email,
                          teacher.email,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ],
                  ),
                  SConfig.spaceSmall,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _infoBlock(
                          context,
                          loc.registrationNumber,
                          teacher.registrationNumber,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _infoBlock(
                          context,
                          loc.nationalId,
                          teacher.nationalId,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ],
                  ),
                  SConfig.spaceSmall,
                  _infoBlock(
                    context,
                    loc.country,
                    teacher.countryName,
                    textDirection: TextDirection.ltr,
                  ),
                  SConfig.spaceSmall,

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Expanded(
                        child: _infoBlock(
                          context,
                          loc.stateId,
                          teacher.stateName,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                      Expanded(
                        child: _infoBlock(
                          context,
                          loc.cityId,
                          teacher.cityName,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  /// BUTTON
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SConfig.primaryColor
                            .withGreen(150)
                            .withAlpha(160),

                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                      ),
                      onPressed: () async {
                        await Get.toNamed(
                          Sroutes.teacherDetails,
                          id: Sroutes.teachersNavigationId,
                          arguments: teacher.id,
                        );
                      },
                      child: Text(
                        loc.seeDetails,
                        style: theme.textTheme.labelLarge,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

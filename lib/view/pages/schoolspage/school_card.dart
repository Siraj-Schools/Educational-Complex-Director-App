import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/models/constants/school_types.dart';
import 'package:educational_complex_director_app/models/school/school.dart';
import 'package:educational_complex_director_app/routes/routes.dart';
import 'package:educational_complex_director_app/utils/s_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SchoolCard extends StatelessWidget {
  final School school;

  const SchoolCard({
    super.key,
    required this.school,
  });

  Widget _infoBlock(
    BuildContext context,
    String label,
    String value,
  ) {
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
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: SConfig.secondaryBackground.withAlpha(200),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// HEADER STRIP
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 18,
            ),
            decoration: BoxDecoration(
              color: SConfig.secondaryBackground.withAlpha(30),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    school.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: SConfig.textDark,
                    ),
                  ),
                ),

                /// EMIS BADGE
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: SConfig.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    school.emisNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// BODY
          Expanded(
            child: Container(
              // color: Colors.red,
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /// EMAIL + PHONE
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Expanded(
                        child: _infoBlock(
                          context,
                          loc.email,
                          school.email,
                        ),
                      ),
                      Expanded(
                        child: _infoBlock(
                          context,
                          loc.phone,
                          school.phone,
                        ),
                      ),
                    ],
                  ),

                  SConfig.spaceSmall,

                  /// ADDRESS
                  _infoBlock(
                    context,
                    loc.address,
                    school.address,
                  ),

                  SConfig.spaceSmall,

                  /// STATE + CITY
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Expanded(
                        child: _infoBlock(
                          context,
                          loc.stateId,
                          school.stateName,
                        ),
                      ),
                      Expanded(
                        child: _infoBlock(
                          context,
                          loc.cityId,
                          school.cityName,
                        ),
                      ),
                    ],
                  ),

                  SConfig.spaceSmall,

                  /// TYPE
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 8,
                    children: [
                      Expanded(
                        child: _infoBlock(
                          context,
                          loc.schoolType,
                          SchoolTypeEnum.values
                              .firstWhere(
                                (element) => element.name == school.schoolType,
                              )
                              .loc(loc),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: _infoBlock(
                          context,
                          "",
                          school.schoolTypeDescription,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// BUTTON
                  Align(
                    alignment: AlignmentGeometry.bottomRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SConfig.accentColor,
                        shape: const StadiumBorder(
                          // borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                      ),
                      onPressed: () async {
                        // print('/school/details/${school.id}');
                        await Get.toNamed(
                          Sroutes.schoolDetails,
                          id: Sroutes.schoolsNavigationId,
                          arguments: school.id,
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

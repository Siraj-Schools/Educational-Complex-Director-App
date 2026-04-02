// ignore_for_file: constant_identifier_names

import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

enum Roles {
  EducationalComplexPrincipel,
  Directorate,
}

extension RolesExtension on Roles {
  String getLocalizedName(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    switch (this) {
      case Roles.EducationalComplexPrincipel:
        return localizations.roleEducationalComplexPrincipel;
      case Roles.Directorate:
        return localizations.roleDirectorate;
    }
  }
}

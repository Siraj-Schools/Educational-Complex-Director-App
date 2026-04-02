// ignore_for_file: constant_identifier_names

import 'package:educational_complex_director_app/l10n/app_localizations.dart';

enum GenderEnum {
  None,
  Male,
  Female,
}

extension GenderEnumLocalization on GenderEnum {
  String loc(AppLocalizations loc) {
    switch (this) {
      case GenderEnum.Male:
        return loc.male;
      case GenderEnum.Female:
        return loc.female;
      case GenderEnum.None:
        return "";
    }
  }
}

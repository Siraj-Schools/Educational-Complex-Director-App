// ignore_for_file: constant_identifier_names

import 'package:educational_complex_director_app/l10n/app_localizations.dart';

enum MaritalStatusEnum {
  None,
  Single,
  Married,
  Divorced,
  Widowed,
}

extension MaritalStatusLocalization on MaritalStatusEnum {
  String loc(AppLocalizations loc) {
    switch (this) {
      case MaritalStatusEnum.Single:
        return loc.single;
      case MaritalStatusEnum.Married:
        return loc.married;
      case MaritalStatusEnum.Divorced:
        return loc.divorced;
      case MaritalStatusEnum.Widowed:
        return loc.widowed;
      case MaritalStatusEnum.None:
        return "";
    }
  }
}

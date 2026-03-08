import 'package:educational_complex_director_app/l10n/app_localizations.dart';

enum MaritalStatusEnum {
  single,
  married,
  divorced,
  widowed,
}

extension MaritalStatusLocalization on MaritalStatusEnum {
  String loc(AppLocalizations loc) {
    switch (this) {
      case MaritalStatusEnum.single:
        return loc.single;
      case MaritalStatusEnum.married:
        return loc.married;
      case MaritalStatusEnum.divorced:
        return loc.divorced;
      case MaritalStatusEnum.widowed:
        return loc.widowed;
    }
  }
}

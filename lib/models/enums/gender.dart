import 'package:educational_complex_director_app/l10n/app_localizations.dart';

enum GenderEnum {
  male,
  female,
}

extension GenderEnumLocalization on GenderEnum {
  String loc(AppLocalizations loc) {
    switch (this) {
      case GenderEnum.male:
        return loc.male;
      case GenderEnum.female:
        return loc.female;
    }
  }
}

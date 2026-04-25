// ignore_for_file: constant_identifier_names

import 'package:educational_complex_director_app/l10n/app_localizations.dart';

enum StandardTypeEnum {
  Primary, // ابتدائي 1 - 6
  Basic, //  أساسي 7 - 9
  Literary, // ثانوي أدبي 10-12
  Scientific,
  Sharia, // شرعي  7 - 12
  Secondary,
}

extension SchoolTypeLocalization on StandardTypeEnum {
  String loc(AppLocalizations loc) {
    switch (this) {
      case StandardTypeEnum.Primary:
        return loc.primary;
      case StandardTypeEnum.Basic:
        return loc.basic;
      case StandardTypeEnum.Literary:
        return loc.literary;
      case StandardTypeEnum.Scientific:
        return loc.scientific;
      case StandardTypeEnum.Sharia:
        return loc.sharia;
      case StandardTypeEnum.Secondary:
        return loc.secondary;
    }
  }
}

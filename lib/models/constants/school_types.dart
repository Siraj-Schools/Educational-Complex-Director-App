// ignore_for_file: constant_identifier_names

import 'package:educational_complex_director_app/l10n/app_localizations.dart';

enum SchoolTypeEnum {
  None,
  Primary, // ابتدائي 1 - 6
  Basic, //  أساسي 7 - 9
  VocationalIndustrial, // مهني صناعة 10 - 12
  VocationalTechnical, //مهني فنية 10 - 12
  Sharia, // شرعي  7 - 12
  Secondary,
}

extension SchoolTypeLocalization on SchoolTypeEnum {
  String loc(AppLocalizations loc) {
    switch (this) {
      case SchoolTypeEnum.Primary:
        return loc.primary;
      case SchoolTypeEnum.Basic:
        return loc.basic;
      case SchoolTypeEnum.VocationalIndustrial:
        return loc.vocationalIndustrial;
      case SchoolTypeEnum.VocationalTechnical:
        return loc.vocationalTechnical;
      case SchoolTypeEnum.Sharia:
        return loc.sharia;
      case SchoolTypeEnum.Secondary:
        return loc.secondary;
      case SchoolTypeEnum.None:
        return "";
    }
  }
}

extension SchoolTypeId on SchoolTypeEnum {
  String get id {
    switch (this) {
      case SchoolTypeEnum.Primary:
        return "11111111-1111-1111-1111-111111111111";
      case SchoolTypeEnum.Basic:
        return "22222222-2222-2222-2222-222222222222";
      case SchoolTypeEnum.VocationalIndustrial:
        return "33333333-3333-3333-3333-333333333333";
      case SchoolTypeEnum.VocationalTechnical:
        return "44444444-4444-4444-4444-444444444444";
      case SchoolTypeEnum.Sharia:
        return "55555555-5555-5555-5555-555555555555";
      case SchoolTypeEnum.Secondary:
        return "66666666-6666-6666-6666-666666666666";
      case SchoolTypeEnum.None:
        return "";
    }
  }
}

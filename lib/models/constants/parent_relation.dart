import 'package:educational_complex_director_app/l10n/app_localizations.dart';

// ignore: constant_identifier_names
enum ParentRelationEnum { Father, Mother, Guardian, Other }

extension ParentRelationEnumExtension on ParentRelationEnum {
  String loc(AppLocalizations loc) {
    switch (this) {
      case ParentRelationEnum.Father:
        return loc.father;
      case ParentRelationEnum.Mother:
        return loc.mother;
      case ParentRelationEnum.Guardian:
        return loc.guardian;
      case ParentRelationEnum.Other:
        return loc.other;
    }
  }
}

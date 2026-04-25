import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/models/constants/standard_type.dart';

class Standard {
  final String id;
  final String name;
  final int order;
  final StandardTypeEnum type;

  Standard({
    required this.id,
    required this.name,
    required this.order,
    required this.type,
  });

  factory Standard.fromJson(Map<String, dynamic> json) {
    return Standard(
      id: json['standardId'],
      name: json['standardName'],
      order: json['order'],
      type: StandardTypeEnum.values.firstWhere((e) => e.name == json['type']),
    );
  }

  String getLocalizedStandardName(AppLocalizations loc) {
    String localizedStandardName = name;
    if (name.contains("Grade")) {
      localizedStandardName = localizedStandardName.replaceAll(
        "Grade",
        loc.grade,
      );
    }
    for (var e in StandardTypeEnum.values) {
      if (name.contains(e.name)) {
        localizedStandardName = localizedStandardName.replaceAll(
          e.name,
          e.loc(loc),
        );
      }
    }
    return localizedStandardName;
  }
}

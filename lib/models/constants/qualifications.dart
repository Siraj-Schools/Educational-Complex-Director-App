import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/models/helpers/lookup_items.dart';

const Map<String, String> qualificationsMap = {
  "High School": "10000000-0000-0000-0000-000000000001",
  "Undergraduate Degree": "20000000-0000-0000-0000-000000000002",
  "Postgraduate Degree": "30000000-0000-0000-0000-000000000003",
  "Masters Degree": "40000000-0000-0000-0000-000000000004",
  "Doctorate": "50000000-0000-0000-0000-000000000005",
};
List<LookupItem> getQualifications(AppLocalizations loc) {
  return [
    LookupItem(
      id: "10000000-0000-0000-0000-000000000001",
      value: loc.highSchool,
    ),
    LookupItem(
      id: "20000000-0000-0000-0000-000000000002",
      value: loc.undergraduateDegree,
    ),
    LookupItem(
      id: "30000000-0000-0000-0000-000000000003",
      value: loc.postgraduateDegree,
    ),
    LookupItem(
      id: "40000000-0000-0000-0000-000000000004",
      value: loc.mastersDegree,
    ),
    LookupItem(
      id: "50000000-0000-0000-0000-000000000005",
      value: loc.doctorate,
    ),
  ];
}

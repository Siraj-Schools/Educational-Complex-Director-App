import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/models/helpers/lookup_items.dart';

const Map<String, String> schoolsMap = {
  "Greenwood Academy": "ec20a588-583b-495e-bcd1-afd05fb9050e",
  "Future Academy": "d72a4e43-902c-4e5e-95b2-123456789111",
  "Damascus International School": "d72a4e43-902c-4e5e-95b2-123456789222",
};
List<LookupItem> getSchools(AppLocalizations loc) {
  return [
    LookupItem(
      id: "ec20a588-583b-495e-bcd1-afd05fb9050e",
      value: "Greenwood Academy",
    ),
    LookupItem(
      id: "d72a4e43-902c-4e5e-95b2-123456789111",
      value: "Future Academy",
    ),
    LookupItem(
      id: "d72a4e43-902c-4e5e-95b2-123456789222",
      value: "Damascus International School",
    ),
  ];
}

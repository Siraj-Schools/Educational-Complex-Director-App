import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/models/helpers/lookup_items.dart';

List<LookupItem> getSchoolTypes(AppLocalizations loc) {
  return [
    LookupItem(id: "1", value: loc.primary),
    LookupItem(id: "2", value: loc.middle),
    LookupItem(id: "3", value: loc.secondary),
  ];
}

const Map<String, String> schoolTypesMap = {
  "Primary": "1",
  "Middle": "2",
  "Secondary": "3",
};

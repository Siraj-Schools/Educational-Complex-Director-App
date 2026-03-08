import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/models/helpers/lookup_items.dart';

List<LookupItem> getCountries(AppLocalizations loc) {
  return [
    LookupItem(id: "1", value: loc.syria),
    LookupItem(id: "2", value: loc.saudiArabia),
    LookupItem(id: "3", value: loc.jordan),
    LookupItem(id: "4", value: loc.lebanon),
    LookupItem(id: "5", value: loc.iraq),
    LookupItem(id: "6", value: loc.qatar),
    LookupItem(id: "7", value: loc.uae),
    LookupItem(id: "8", value: loc.kuwait),
    LookupItem(id: "9", value: loc.oman),
    LookupItem(id: "10", value: loc.bahrain),
  ];
}

const Map<String, String> countriesMap = {
  "Syria": "1",
  "Saudi Arabia": "2",
  "Jordan": "3",
  "Lebanon": "4",
  "Iraq": "5",
  "Qatar": "6",
  "UAE": "7",
  "Kuwait": "8",
  "Oman": "9",
  "Bahrain": "10",
};

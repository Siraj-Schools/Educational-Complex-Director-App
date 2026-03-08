import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/models/helpers/lookup_items.dart';

List<LookupItem> getSyrianStates(AppLocalizations loc) {
  return [
    LookupItem(id: "1", value: loc.damascus),
    LookupItem(id: "2", value: loc.ruralDamascus),
    LookupItem(id: "3", value: loc.aleppo),
    LookupItem(id: "4", value: loc.homs),
    LookupItem(id: "5", value: loc.hama),
    LookupItem(id: "6", value: loc.lattakia),
    LookupItem(id: "7", value: loc.tartous),
    LookupItem(id: "8", value: loc.idlib),
    LookupItem(id: "9", value: loc.daraa),
    LookupItem(id: "10", value: loc.suwayda),
    LookupItem(id: "11", value: loc.deirEzzor),
    LookupItem(id: "12", value: loc.raqqa),
    LookupItem(id: "13", value: loc.hasakah),
    LookupItem(id: "14", value: loc.quneitra),
  ];
}

const Map<String, String> syrianStatesMap = {
  "Damascus": "1",
  "Rural Damascus": "2",
  "Aleppo": "3",
  "Homs": "4",
  "Hama": "5",
  "Latakia": "6",
  "Tartous": "7",
  "Idlib": "8",
  "Daraa": "9",
  "Suwayda": "10",
  "Deir ez-Zor": "11",
  "Raqqa": "12",
  "Hasakah": "13",
  "Quneitra": "14",
};

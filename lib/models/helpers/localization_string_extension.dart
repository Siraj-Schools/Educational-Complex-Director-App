import 'package:educational_complex_director_app/l10n/app_localizations.dart';

extension LocalizationExtension on String {
  String localized(AppLocalizations loc) {
    switch (this) {
      case "Syria":
        return loc.syria;

      case "Saudi Arabia":
        return loc.saudiArabia;

      case "Jordan":
        return loc.jordan;

      case "Lebanon":
        return loc.lebanon;

      case "Iraq":
        return loc.iraq;

      case "Qatar":
        return loc.qatar;

      case "UAE":
        return loc.uae;

      case "Kuwait":
        return loc.kuwait;

      case "Oman":
        return loc.oman;

      case "Bahrain":
        return loc.bahrain;

      case "Damascus":
        return loc.damascus;

      case "Rural Damascus":
        return loc.ruralDamascus;

      case "Aleppo":
        return loc.aleppo;

      case "Homs":
        return loc.homs;

      case "Hama":
        return loc.hama;

      case "Latakia":
        return loc.lattakia;

      case "Tartous":
        return loc.tartous;

      case "Idlib":
        return loc.idlib;

      case "Daraa":
        return loc.daraa;

      case "Suwayda":
        return loc.suwayda;

      case "Deir ez-Zor":
        return loc.deirEzzor;

      case "Raqqa":
        return loc.raqqa;

      case "Hasakah":
        return loc.hasakah;

      case "Quneitra":
        return loc.quneitra;

      case "Primary":
        return loc.primary;

      case "Middle":
        return loc.middle;

      case "Secondary":
        return loc.secondary;

      default:
        return this;
    }
  }
}

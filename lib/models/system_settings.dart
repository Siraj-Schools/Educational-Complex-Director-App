import 'package:educational_complex_director_app/l10n/app_localizations.dart';

class SystemSettings {
  final String id;
  final String currentChapterId;
  final String currentChapterName;
  final String currentAcademicYearId;
  final String currentAcademicYearName;
  final String nextAcademicYearId;
  final String nextAcademicYearName;
  final bool isPromotion;
  final bool isChapterPromotion;

  SystemSettings({
    required this.id,
    required this.currentChapterId,
    required this.currentChapterName,
    required this.currentAcademicYearId,
    required this.currentAcademicYearName,
    required this.nextAcademicYearId,
    required this.nextAcademicYearName,
    required this.isPromotion,
    required this.isChapterPromotion,
  });
  static String firstChapterId = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa";
  static String secondChapterId = "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb";
  bool get isFirstChapter => currentChapterId == firstChapterId;
  String getLocalizedName(AppLocalizations loc) {
    if (isFirstChapter) {
      return loc.chapter1;
    }
    return loc.chapter2;
  }

  factory SystemSettings.fromJson(Map<String, dynamic> json) {
    return SystemSettings(
      id: json['id'],
      currentChapterId: json['currentChapterId'],
      currentChapterName: json['currentChapterName'],
      currentAcademicYearId: json['currentAcademicYearId'],
      currentAcademicYearName: json['currentAcademicYearName'],
      nextAcademicYearId: json['nextAcademicYearId'],
      nextAcademicYearName: json['nextAcademicYearName'],
      isPromotion: json['isPromotion'],
      isChapterPromotion: json['isChapterPromotion'],
    );
  }
}

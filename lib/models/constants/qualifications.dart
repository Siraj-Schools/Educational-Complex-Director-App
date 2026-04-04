// ignore_for_file: constant_identifier_names

import 'package:educational_complex_director_app/l10n/app_localizations.dart';

enum QualificationEnum {
  None,
  Primary,
  UnderGraduate,
  PostGraduate,
  Teacher,
  Others,
}

extension QualificationLocalizationEnglish on QualificationEnum {
  String get englishName {
    switch (this) {
      case QualificationEnum.Primary:
        return "Primary School Certificate";
      case QualificationEnum.UnderGraduate:
        return "Undergraduate Degree";
      case QualificationEnum.PostGraduate:
        return "Postgraduate Degree";
      case QualificationEnum.Teacher:
        return "Teacher Training Institute";
      case QualificationEnum.Others:
        return "Other Qualification";
      case QualificationEnum.None:
        return "";
    }
  }
}

extension QualificationLocalization on QualificationEnum {
  String loc(AppLocalizations loc) {
    switch (this) {
      case QualificationEnum.Primary:
        return loc.primarySchoolCertificate;
      case QualificationEnum.UnderGraduate:
        return loc.undergraduateDegree;
      case QualificationEnum.PostGraduate:
        return loc.postgraduateDegree;
      case QualificationEnum.Teacher:
        return loc.teacherTrainingInstitute;
      case QualificationEnum.Others:
        return loc.otherQualification;
      case QualificationEnum.None:
        return loc.none;
    }
  }
}

extension QualificationId on QualificationEnum {
  String get id {
    switch (this) {
      case QualificationEnum.Primary:
        return "20000000-0000-0000-0000-000000000001";
      case QualificationEnum.UnderGraduate:
        return "20000000-0000-0000-0000-000000000002";
      case QualificationEnum.PostGraduate:
        return "20000000-0000-0000-0000-000000000003";
      case QualificationEnum.Teacher:
        return "20000000-0000-0000-0000-000000000004";
      case QualificationEnum.Others:
        return "20000000-0000-0000-0000-000000000005";
      case QualificationEnum.None:
        return "";
    }
  }
}

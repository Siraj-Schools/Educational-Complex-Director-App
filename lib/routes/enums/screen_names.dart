import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

enum ScreenNames {
  home,
  schools,
  settings,
  addSchool,
  schoolDetails,
  teachers,
  addTeacher,
  teacherDetails,
  managers,
  addManager,
  managerDetails,
  students,
  addStudent,
  studentDetails,
  systemSettings,
}

extension ScreenNamesExtension on ScreenNames {
  String getTitle(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    switch (this) {
      case ScreenNames.home:
        return loc.home;
      case ScreenNames.schools:
        return loc.schools;
      case ScreenNames.settings:
        return loc.settings;
      case ScreenNames.addSchool:
        return loc.addSchool;
      case ScreenNames.schoolDetails:
        return loc.schoolDetails;

      case ScreenNames.teachers:
        return loc.teachers;
      case ScreenNames.teacherDetails:
        return loc.teacherDetails;
      case ScreenNames.addTeacher:
        return loc.addTeacher;
      case ScreenNames.managers:
        return loc.managers;
      case ScreenNames.managerDetails:
        return loc.managerDetails;
      case ScreenNames.addManager:
        return loc.addManager;
      case ScreenNames.students:
        return loc.students;
      case ScreenNames.studentDetails:
        return loc.studentDetails;
      case ScreenNames.addStudent:
        return loc.addStudent;
      case ScreenNames.systemSettings:
        return loc.systemSettings;
    }
  }
}

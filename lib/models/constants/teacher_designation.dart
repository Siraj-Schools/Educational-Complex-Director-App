// ignore_for_file: constant_identifier_names

import 'package:educational_complex_director_app/l10n/app_localizations.dart';

enum TeacherDesignation {
  AssistantTeacher,
  CoOrdinator,
  HeadOfTheDepartment,
  Librarian,
  Principal,
  Teacher,
  SeniorTeacher,
  VicePrincipal,
  Accountant,
  Receptionist,
  LabAssistant,
  Clerk,
  StockKeeper,
  Peon,
  Driver,
  Helpers,
  Security,
  PhysicalEducationTeacher,
  TransportCoordinator,
  Others,
  ClassTeacher,
}

extension TeacherDesignationExtension on TeacherDesignation {
  String localizedName(AppLocalizations loc) {
    switch (this) {
      case TeacherDesignation.AssistantTeacher:
        return loc.teacherDesignationAssistantTeacher;
      case TeacherDesignation.CoOrdinator:
        return loc.teacherDesignationCoOrdinator;
      case TeacherDesignation.HeadOfTheDepartment:
        return loc.teacherDesignationHeadOfTheDepartment;
      case TeacherDesignation.Librarian:
        return loc.teacherDesignationLibrarian;
      case TeacherDesignation.Principal:
        return loc.teacherDesignationPrincipal;
      case TeacherDesignation.Teacher:
        return loc.teacherDesignationTeacher;
      case TeacherDesignation.SeniorTeacher:
        return loc.teacherDesignationSeniorTeacher;
      case TeacherDesignation.VicePrincipal:
        return loc.teacherDesignationVicePrincipal;
      case TeacherDesignation.Accountant:
        return loc.teacherDesignationAccountant;
      case TeacherDesignation.Receptionist:
        return loc.teacherDesignationReceptionist;
      case TeacherDesignation.LabAssistant:
        return loc.teacherDesignationLabAssistant;
      case TeacherDesignation.Clerk:
        return loc.teacherDesignationClerk;
      case TeacherDesignation.StockKeeper:
        return loc.teacherDesignationStockKeeper;
      case TeacherDesignation.Peon:
        return loc.teacherDesignationPeon;
      case TeacherDesignation.Driver:
        return loc.teacherDesignationDriver;
      case TeacherDesignation.Helpers:
        return loc.teacherDesignationHelpers;
      case TeacherDesignation.Security:
        return loc.teacherDesignationSecurity;
      case TeacherDesignation.PhysicalEducationTeacher:
        return loc.teacherDesignationPhysicalEducationTeacher;
      case TeacherDesignation.TransportCoordinator:
        return loc.teacherDesignationTransportCoordinator;
      case TeacherDesignation.Others:
        return loc.teacherDesignationOthers;
      case TeacherDesignation.ClassTeacher:
        return loc.teacherDesignationClassTeacher;
    }
  }
}

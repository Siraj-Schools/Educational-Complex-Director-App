import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @academicYear.
  ///
  /// In en, this message translates to:
  /// **'Academic Year'**
  String get academicYear;

  /// No description provided for @academicYearInfo.
  ///
  /// In en, this message translates to:
  /// **'Academic Year Info'**
  String get academicYearInfo;

  /// No description provided for @accountInformation.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInformation;

  /// No description provided for @addManager.
  ///
  /// In en, this message translates to:
  /// **'Add Manager'**
  String get addManager;

  /// No description provided for @addSchool.
  ///
  /// In en, this message translates to:
  /// **'Add School'**
  String get addSchool;

  /// No description provided for @addStudent.
  ///
  /// In en, this message translates to:
  /// **'Add Student'**
  String get addStudent;

  /// No description provided for @addTeacher.
  ///
  /// In en, this message translates to:
  /// **'Add Teacher'**
  String get addTeacher;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @addressRequired.
  ///
  /// In en, this message translates to:
  /// **'Address is required'**
  String get addressRequired;

  /// No description provided for @aleppo.
  ///
  /// In en, this message translates to:
  /// **'Aleppo'**
  String get aleppo;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Siraj'**
  String get appTitle;

  /// No description provided for @assignManager.
  ///
  /// In en, this message translates to:
  /// **'Assign Manager'**
  String get assignManager;

  /// No description provided for @assignStudentToSchool.
  ///
  /// In en, this message translates to:
  /// **'Assign Student To School'**
  String get assignStudentToSchool;

  /// No description provided for @assignTeacherToSchool.
  ///
  /// In en, this message translates to:
  /// **'Assign to School'**
  String get assignTeacherToSchool;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'back'**
  String get back;

  /// No description provided for @basic.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get basic;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @cancelEdit.
  ///
  /// In en, this message translates to:
  /// **'Cancel Edit'**
  String get cancelEdit;

  /// No description provided for @changeManager.
  ///
  /// In en, this message translates to:
  /// **'Change Manager'**
  String get changeManager;

  /// No description provided for @changePasswordOfParent.
  ///
  /// In en, this message translates to:
  /// **'Change Password Of Parent'**
  String get changePasswordOfParent;

  /// No description provided for @changePasswordOfTeacher.
  ///
  /// In en, this message translates to:
  /// **'Change Password Of Teacher'**
  String get changePasswordOfTeacher;

  /// No description provided for @checkingCredentials.
  ///
  /// In en, this message translates to:
  /// **'Please wait while we verify your credentials.'**
  String get checkingCredentials;

  /// No description provided for @cityId.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get cityId;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @confirmAction.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to continue?'**
  String get confirmAction;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @credentialsCopied.
  ///
  /// In en, this message translates to:
  /// **'Credentials copied to clipboard'**
  String get credentialsCopied;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @deleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete All'**
  String get deleteAll;

  /// No description provided for @designation.
  ///
  /// In en, this message translates to:
  /// **'Designation'**
  String get designation;

  /// No description provided for @director.
  ///
  /// In en, this message translates to:
  /// **'Educational Complex Director'**
  String get director;

  /// No description provided for @divorced.
  ///
  /// In en, this message translates to:
  /// **'Divorced'**
  String get divorced;

  /// No description provided for @doctorate.
  ///
  /// In en, this message translates to:
  /// **'Doctorate'**
  String get doctorate;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @emailRequiredAr.
  ///
  /// In en, this message translates to:
  /// **'البريد الإلكتروني مطلوب'**
  String get emailRequiredAr;

  /// No description provided for @emisNumber.
  ///
  /// In en, this message translates to:
  /// **'EMIS Number'**
  String get emisNumber;

  /// No description provided for @emisRequired.
  ///
  /// In en, this message translates to:
  /// **'EMIS number is required'**
  String get emisRequired;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorOccurred;

  /// No description provided for @father.
  ///
  /// In en, this message translates to:
  /// **'Father'**
  String get father;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @firstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get firstNameRequired;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotPassword;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @guardian.
  ///
  /// In en, this message translates to:
  /// **'Guardian'**
  String get guardian;

  /// No description provided for @highSchool.
  ///
  /// In en, this message translates to:
  /// **'High School'**
  String get highSchool;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get info;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Email or password is incorrect'**
  String get invalidCredentials;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get invalidEmail;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Invalid Phone'**
  String get invalidPhone;

  /// No description provided for @joinedAt.
  ///
  /// In en, this message translates to:
  /// **'Joined At'**
  String get joinedAt;

  /// No description provided for @joiningDate.
  ///
  /// In en, this message translates to:
  /// **'Joining Date'**
  String get joiningDate;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @lastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Last name is required'**
  String get lastNameRequired;

  /// No description provided for @loadingYourData.
  ///
  /// In en, this message translates to:
  /// **'Loading your data...'**
  String get loadingYourData;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @loggingIn.
  ///
  /// In en, this message translates to:
  /// **'Logging in ...'**
  String get loggingIn;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login to the System'**
  String get loginTitle;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @manager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get manager;

  /// No description provided for @managerDetails.
  ///
  /// In en, this message translates to:
  /// **'Manager Details'**
  String get managerDetails;

  /// No description provided for @managerEmail.
  ///
  /// In en, this message translates to:
  /// **'Manager Email'**
  String get managerEmail;

  /// No description provided for @managerInformation.
  ///
  /// In en, this message translates to:
  /// **'Manager Information'**
  String get managerInformation;

  /// No description provided for @managerPhone.
  ///
  /// In en, this message translates to:
  /// **'Manager Phone'**
  String get managerPhone;

  /// No description provided for @managers.
  ///
  /// In en, this message translates to:
  /// **'Managers'**
  String get managers;

  /// No description provided for @maritalStatus.
  ///
  /// In en, this message translates to:
  /// **'Marital Status'**
  String get maritalStatus;

  /// No description provided for @markAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark All as Read'**
  String get markAllAsRead;

  /// No description provided for @married.
  ///
  /// In en, this message translates to:
  /// **'Married'**
  String get married;

  /// No description provided for @mastersDegree.
  ///
  /// In en, this message translates to:
  /// **'Masters Degree'**
  String get mastersDegree;

  /// No description provided for @middle.
  ///
  /// In en, this message translates to:
  /// **'Middle'**
  String get middle;

  /// No description provided for @middleName.
  ///
  /// In en, this message translates to:
  /// **'Middle Name'**
  String get middleName;

  /// No description provided for @mother.
  ///
  /// In en, this message translates to:
  /// **'Mother'**
  String get mother;

  /// No description provided for @motherName.
  ///
  /// In en, this message translates to:
  /// **'Mother\'s Name'**
  String get motherName;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @nationalId.
  ///
  /// In en, this message translates to:
  /// **'National ID'**
  String get nationalId;

  /// No description provided for @nationalIdRequired.
  ///
  /// In en, this message translates to:
  /// **'National ID is required'**
  String get nationalIdRequired;

  /// No description provided for @nationality.
  ///
  /// In en, this message translates to:
  /// **'Nationality'**
  String get nationality;

  /// No description provided for @newCredentials.
  ///
  /// In en, this message translates to:
  /// **'New Credentials'**
  String get newCredentials;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @noDataFound.
  ///
  /// In en, this message translates to:
  /// **'No data found'**
  String get noDataFound;

  /// No description provided for @noManagerFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'This school doesnt have a manager'**
  String get noManagerFoundMessage;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @otherQualification.
  ///
  /// In en, this message translates to:
  /// **'Other Qualification'**
  String get otherQualification;

  /// No description provided for @parent.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get parent;

  /// No description provided for @parentInformation.
  ///
  /// In en, this message translates to:
  /// **'Parent Information'**
  String get parentInformation;

  /// No description provided for @parentLocation.
  ///
  /// In en, this message translates to:
  /// **'Parent Location'**
  String get parentLocation;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @postgraduateDegree.
  ///
  /// In en, this message translates to:
  /// **'Postgraduate Degree'**
  String get postgraduateDegree;

  /// No description provided for @primary.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get primary;

  /// No description provided for @primarySchoolCertificate.
  ///
  /// In en, this message translates to:
  /// **'Primary School Certificate'**
  String get primarySchoolCertificate;

  /// No description provided for @professionalInformation.
  ///
  /// In en, this message translates to:
  /// **'Professional Information'**
  String get professionalInformation;

  /// No description provided for @qualification.
  ///
  /// In en, this message translates to:
  /// **'Qualification'**
  String get qualification;

  /// No description provided for @registrationNumber.
  ///
  /// In en, this message translates to:
  /// **'Registration Number'**
  String get registrationNumber;

  /// No description provided for @relation.
  ///
  /// In en, this message translates to:
  /// **'Relation'**
  String get relation;

  /// No description provided for @removeManager.
  ///
  /// In en, this message translates to:
  /// **'Remove Manager'**
  String get removeManager;

  /// No description provided for @removeTeacherFromSchool.
  ///
  /// In en, this message translates to:
  /// **'Remove from School'**
  String get removeTeacherFromSchool;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @roleDirectorate.
  ///
  /// In en, this message translates to:
  /// **'Directorate'**
  String get roleDirectorate;

  /// No description provided for @roleEducationalComplexPrincipel.
  ///
  /// In en, this message translates to:
  /// **'Educational Complex Principal'**
  String get roleEducationalComplexPrincipel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @savingForm.
  ///
  /// In en, this message translates to:
  /// **'Please wait while we save your changes.'**
  String get savingForm;

  /// No description provided for @school.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get school;

  /// No description provided for @schoolDetails.
  ///
  /// In en, this message translates to:
  /// **'School Details'**
  String get schoolDetails;

  /// No description provided for @schoolDetailsDescription.
  ///
  /// In en, this message translates to:
  /// **'School Details'**
  String get schoolDetailsDescription;

  /// No description provided for @schoolEmail.
  ///
  /// In en, this message translates to:
  /// **'School Email'**
  String get schoolEmail;

  /// No description provided for @schoolInfoSection.
  ///
  /// In en, this message translates to:
  /// **'School Details'**
  String get schoolInfoSection;

  /// No description provided for @schoolInformation.
  ///
  /// In en, this message translates to:
  /// **'School Information'**
  String get schoolInformation;

  /// No description provided for @schoolManager.
  ///
  /// In en, this message translates to:
  /// **'School Manager'**
  String get schoolManager;

  /// No description provided for @schoolName.
  ///
  /// In en, this message translates to:
  /// **'School Name'**
  String get schoolName;

  /// No description provided for @schoolType.
  ///
  /// In en, this message translates to:
  /// **'School Type'**
  String get schoolType;

  /// No description provided for @schools.
  ///
  /// In en, this message translates to:
  /// **'Schools'**
  String get schools;

  /// No description provided for @searchManager.
  ///
  /// In en, this message translates to:
  /// **'Search manager...'**
  String get searchManager;

  /// No description provided for @searchSchool.
  ///
  /// In en, this message translates to:
  /// **'Search school...'**
  String get searchSchool;

  /// No description provided for @searchStandard.
  ///
  /// In en, this message translates to:
  /// **'Search standard...'**
  String get searchStandard;

  /// No description provided for @searchStudent.
  ///
  /// In en, this message translates to:
  /// **'Search student...'**
  String get searchStudent;

  /// No description provided for @searchTeacher.
  ///
  /// In en, this message translates to:
  /// **'Search teacher...'**
  String get searchTeacher;

  /// No description provided for @secondary.
  ///
  /// In en, this message translates to:
  /// **'Secondary'**
  String get secondary;

  /// No description provided for @seeDetails.
  ///
  /// In en, this message translates to:
  /// **'See Details'**
  String get seeDetails;

  /// No description provided for @selectDesignation.
  ///
  /// In en, this message translates to:
  /// **'Select Designation'**
  String get selectDesignation;

  /// No description provided for @selectManager.
  ///
  /// In en, this message translates to:
  /// **'Select Manager'**
  String get selectManager;

  /// No description provided for @selectQualification.
  ///
  /// In en, this message translates to:
  /// **'Select Qualification'**
  String get selectQualification;

  /// No description provided for @selectRelation.
  ///
  /// In en, this message translates to:
  /// **'Select Relation'**
  String get selectRelation;

  /// No description provided for @selectSchool.
  ///
  /// In en, this message translates to:
  /// **'Select School'**
  String get selectSchool;

  /// No description provided for @selectSchoolAndDesignation.
  ///
  /// In en, this message translates to:
  /// **'Select School and Designation'**
  String get selectSchoolAndDesignation;

  /// No description provided for @selectSchoolAndStandard.
  ///
  /// In en, this message translates to:
  /// **'Select School and Standard'**
  String get selectSchoolAndStandard;

  /// No description provided for @selectStandard.
  ///
  /// In en, this message translates to:
  /// **'Select Standard'**
  String get selectStandard;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, please login again'**
  String get sessionExpired;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @sharia.
  ///
  /// In en, this message translates to:
  /// **'Sharia'**
  String get sharia;

  /// No description provided for @single.
  ///
  /// In en, this message translates to:
  /// **'Single'**
  String get single;

  /// No description provided for @standardName.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get standardName;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @stateId.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get stateId;

  /// No description provided for @studentDetails.
  ///
  /// In en, this message translates to:
  /// **'Student Details'**
  String get studentDetails;

  /// No description provided for @studentInformation.
  ///
  /// In en, this message translates to:
  /// **'Student Information'**
  String get studentInformation;

  /// No description provided for @studentLocation.
  ///
  /// In en, this message translates to:
  /// **'Student Location'**
  String get studentLocation;

  /// No description provided for @students.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get students;

  /// No description provided for @systemDescription.
  ///
  /// In en, this message translates to:
  /// **'An integrated platform for managing schools, educational staff, and students efficiently and professionally.'**
  String get systemDescription;

  /// No description provided for @systemName.
  ///
  /// In en, this message translates to:
  /// **'Siraj System for Educational Complex Management'**
  String get systemName;

  /// No description provided for @teacherDesignationAccountant.
  ///
  /// In en, this message translates to:
  /// **'Accountant'**
  String get teacherDesignationAccountant;

  /// No description provided for @teacherDesignationAssistantTeacher.
  ///
  /// In en, this message translates to:
  /// **'Assistant Teacher'**
  String get teacherDesignationAssistantTeacher;

  /// No description provided for @teacherDesignationClassTeacher.
  ///
  /// In en, this message translates to:
  /// **'Class Teacher'**
  String get teacherDesignationClassTeacher;

  /// No description provided for @teacherDesignationClerk.
  ///
  /// In en, this message translates to:
  /// **'Clerk'**
  String get teacherDesignationClerk;

  /// No description provided for @teacherDesignationCoOrdinator.
  ///
  /// In en, this message translates to:
  /// **'Coordinator'**
  String get teacherDesignationCoOrdinator;

  /// No description provided for @teacherDesignationDriver.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get teacherDesignationDriver;

  /// No description provided for @teacherDesignationHeadOfTheDepartment.
  ///
  /// In en, this message translates to:
  /// **'Head of the Department'**
  String get teacherDesignationHeadOfTheDepartment;

  /// No description provided for @teacherDesignationHelpers.
  ///
  /// In en, this message translates to:
  /// **'Helpers'**
  String get teacherDesignationHelpers;

  /// No description provided for @teacherDesignationLabAssistant.
  ///
  /// In en, this message translates to:
  /// **'Lab Assistant'**
  String get teacherDesignationLabAssistant;

  /// No description provided for @teacherDesignationLibrarian.
  ///
  /// In en, this message translates to:
  /// **'Librarian'**
  String get teacherDesignationLibrarian;

  /// No description provided for @teacherDesignationOthers.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get teacherDesignationOthers;

  /// No description provided for @teacherDesignationPeon.
  ///
  /// In en, this message translates to:
  /// **'Peon'**
  String get teacherDesignationPeon;

  /// No description provided for @teacherDesignationPhysicalEducationTeacher.
  ///
  /// In en, this message translates to:
  /// **'Physical Education Teacher'**
  String get teacherDesignationPhysicalEducationTeacher;

  /// No description provided for @teacherDesignationPrincipal.
  ///
  /// In en, this message translates to:
  /// **'Principal'**
  String get teacherDesignationPrincipal;

  /// No description provided for @teacherDesignationReceptionist.
  ///
  /// In en, this message translates to:
  /// **'Receptionist'**
  String get teacherDesignationReceptionist;

  /// No description provided for @teacherDesignationSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get teacherDesignationSecurity;

  /// No description provided for @teacherDesignationSeniorTeacher.
  ///
  /// In en, this message translates to:
  /// **'Senior Teacher'**
  String get teacherDesignationSeniorTeacher;

  /// No description provided for @teacherDesignationStockKeeper.
  ///
  /// In en, this message translates to:
  /// **'Stock Keeper'**
  String get teacherDesignationStockKeeper;

  /// No description provided for @teacherDesignationTeacher.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get teacherDesignationTeacher;

  /// No description provided for @teacherDesignationTransportCoordinator.
  ///
  /// In en, this message translates to:
  /// **'Transport Coordinator'**
  String get teacherDesignationTransportCoordinator;

  /// No description provided for @teacherDesignationVicePrincipal.
  ///
  /// In en, this message translates to:
  /// **'Vice Principal'**
  String get teacherDesignationVicePrincipal;

  /// No description provided for @teacherDetails.
  ///
  /// In en, this message translates to:
  /// **'Teacher Details'**
  String get teacherDetails;

  /// No description provided for @teacherInformation.
  ///
  /// In en, this message translates to:
  /// **'Teacher Information'**
  String get teacherInformation;

  /// No description provided for @teacherTrainingInstitute.
  ///
  /// In en, this message translates to:
  /// **'Teacher Training Institute'**
  String get teacherTrainingInstitute;

  /// No description provided for @teachers.
  ///
  /// In en, this message translates to:
  /// **'Teachers'**
  String get teachers;

  /// No description provided for @transferStudentToAnotherSchool.
  ///
  /// In en, this message translates to:
  /// **'Transfer Student To Another School'**
  String get transferStudentToAnotherSchool;

  /// No description provided for @transferTeacherToAnotherSchool.
  ///
  /// In en, this message translates to:
  /// **'Transfer to Another School'**
  String get transferTeacherToAnotherSchool;

  /// No description provided for @undergraduateDegree.
  ///
  /// In en, this message translates to:
  /// **'Undergraduate Degree'**
  String get undergraduateDegree;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get usernameRequired;

  /// No description provided for @viewModeHint.
  ///
  /// In en, this message translates to:
  /// **'You are in view mode. Press Edit to make changes.'**
  String get viewModeHint;

  /// No description provided for @vocationalIndustrial.
  ///
  /// In en, this message translates to:
  /// **'Vocational Industrial'**
  String get vocationalIndustrial;

  /// No description provided for @vocationalTechnical.
  ///
  /// In en, this message translates to:
  /// **'Vocational Technical'**
  String get vocationalTechnical;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @widowed.
  ///
  /// In en, this message translates to:
  /// **'Widowed'**
  String get widowed;

  /// No description provided for @literary.
  ///
  /// In en, this message translates to:
  /// **'Literary'**
  String get literary;

  /// No description provided for @scientific.
  ///
  /// In en, this message translates to:
  /// **'Scientific'**
  String get scientific;

  /// No description provided for @grade.
  ///
  /// In en, this message translates to:
  /// **'Grade'**
  String get grade;

  /// No description provided for @systemSettings.
  ///
  /// In en, this message translates to:
  /// **'System Settings'**
  String get systemSettings;

  /// No description provided for @addAcademicYear.
  ///
  /// In en, this message translates to:
  /// **'Add Academic Year'**
  String get addAcademicYear;

  /// No description provided for @academicYearName.
  ///
  /// In en, this message translates to:
  /// **'Academic Year Name'**
  String get academicYearName;

  /// No description provided for @currentAcademicYear.
  ///
  /// In en, this message translates to:
  /// **'Current Academic Year'**
  String get currentAcademicYear;

  /// No description provided for @nextAcademicYear.
  ///
  /// In en, this message translates to:
  /// **'Next Academic Year'**
  String get nextAcademicYear;

  /// No description provided for @currentChapter.
  ///
  /// In en, this message translates to:
  /// **'Current Academic Year'**
  String get currentChapter;

  /// No description provided for @chapter1.
  ///
  /// In en, this message translates to:
  /// **'First Academic Year'**
  String get chapter1;

  /// No description provided for @chapter2.
  ///
  /// In en, this message translates to:
  /// **'Second Academic Year'**
  String get chapter2;

  /// No description provided for @isPromotion.
  ///
  /// In en, this message translates to:
  /// **'Promotion Active'**
  String get isPromotion;

  /// No description provided for @isChapterPromotion.
  ///
  /// In en, this message translates to:
  /// **'Chapter Promotion Active'**
  String get isChapterPromotion;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @selectAcademicYear.
  ///
  /// In en, this message translates to:
  /// **'Select Academic Year'**
  String get selectAcademicYear;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @updateCurrentChapter.
  ///
  /// In en, this message translates to:
  /// **'Update Current Chapter'**
  String get updateCurrentChapter;

  /// No description provided for @enterChapterId.
  ///
  /// In en, this message translates to:
  /// **'Enter Chapter ID'**
  String get enterChapterId;

  /// No description provided for @chapterId.
  ///
  /// In en, this message translates to:
  /// **'Chapter ID'**
  String get chapterId;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

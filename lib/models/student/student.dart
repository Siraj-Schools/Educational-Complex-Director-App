import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/models/constants/standard_type.dart';

class Student {
  final String id;

  final String firstName;
  final String middleName;
  final String lastName;
  final String email;
  final String nationalId;
  final String standardId;
  final String standardName;

  Student({
    required this.id,

    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.nationalId,
    required this.standardId,
    required this.standardName,
  });
  String getLocalizedStandardName(AppLocalizations loc) {
    String localizedStandardName = standardName;
    if (standardName.contains("Grade")) {
      localizedStandardName = localizedStandardName.replaceAll(
        "Grade",
        loc.grade,
      );
    }
    for (var e in StandardTypeEnum.values) {
      if (standardName.contains(e.name)) {
        localizedStandardName = localizedStandardName.replaceAll(
          e.name,
          e.loc(loc),
        );
      }
    }
    return localizedStandardName;
  }

  String get fullName => "$firstName $middleName $lastName";
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      email: json['email'],
      nationalId: json['nationalId'],
      standardId: json['standardId'],
      standardName: json['standardName'],
    );
  }
}

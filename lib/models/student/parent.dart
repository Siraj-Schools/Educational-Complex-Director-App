import 'package:educational_complex_director_app/models/constants/gender.dart';
import 'package:educational_complex_director_app/models/constants/parent_relation.dart';

class Parent {
  final String parentFirstName;
  final String parentMiddleName;
  final String parentLastName;
  final String parentFullName;
  final String parentEmail;
  final String parentNationalId;
  final String parentMobileNumber;
  final GenderEnum parentGender;
  final DateTime parentDateOfBirth;
  final ParentRelationEnum parentRelation;

  Parent({
    required this.parentFirstName,
    required this.parentMiddleName,
    required this.parentLastName,
    required this.parentFullName,
    required this.parentEmail,
    required this.parentNationalId,
    required this.parentMobileNumber,
    required this.parentGender,
    required this.parentDateOfBirth,
    required this.parentRelation,
  });

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      parentFirstName: json['parentFirstName'],
      parentMiddleName: json['parentMiddleName'],
      parentLastName: json['parentLastName'],
      parentFullName: json['parentFullName'],
      parentEmail: json['parentEmail'],
      parentNationalId: json['parentNationalId'],
      parentMobileNumber: json['parentMobileNumber'],
      parentGender: GenderEnum.values.firstWhere(
        (e) => e.name == json['parentGender'],
      ),
      parentDateOfBirth: DateTime.parse(json['parentDateOfBirth']),
      parentRelation: ParentRelationEnum.values.firstWhere(
        (e) => e.name == json['parentRelation'],
      ),
    );
  }
  factory Parent.fromParentApi(Map<String, dynamic> json) {
    return Parent(
      parentFirstName: json['firstName'],
      parentMiddleName: json['middleName'],
      parentLastName: json['lastName'],
      parentFullName: json['fullName'],
      parentEmail: json['email'],
      parentNationalId: json['nationalId'],
      parentMobileNumber: json['mobileNumber'],
      parentGender: GenderEnum.values.firstWhere(
        (e) => e.name == json['gender'],
      ),
      parentDateOfBirth: DateTime.parse(json['dateOfBirth']),
      parentRelation: ParentRelationEnum.values.firstWhere(
        (e) => e.name == json['relation'],
      ),
    );
  }
}

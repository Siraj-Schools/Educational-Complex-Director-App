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

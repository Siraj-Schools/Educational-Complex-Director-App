class School {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String stateId;
  final String cityId;
  final String schoolTypeId;
  final String emisNumber;

  School({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.stateId,
    required this.cityId,
    required this.schoolTypeId,
    required this.emisNumber,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      stateId: json['stateId'],
      cityId: json['cityId'],
      schoolTypeId: json['schoolTypeId'],
      emisNumber: json['emisNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'stateId': stateId,
      'cityId': cityId,
      'schoolTypeId': schoolTypeId,
      'emisNumber': emisNumber,
    };
  }
}

import 'package:educational_complex_director_app/models/constants/roles.dart';

class User {
  final String id;
  final String email;
  final Roles role;
  const User({required this.id, required this.email, required this.role});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['userId'],
      email: json['email'],
      role: Roles.values.firstWhere(
        (role) =>
            role.name.toLowerCase() ==
            (json['roles'] as List<dynamic>)[0].toLowerCase(),
      ),
    );
  }
  factory User.empty() {
    return const User(id: '', email: '', role: Roles.Directorate);
  }
  Map<String, dynamic> toJson() {
    return {
      'userId': id,
      'email': email,
      'roles': role.name,
    };
  }

  bool get isDirector => role == Roles.Directorate;
  bool get isEducationalComplexPrincipel =>
      role == Roles.EducationalComplexPrincipel;
}

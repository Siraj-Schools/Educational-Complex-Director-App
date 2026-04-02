class NewCredentials {
  final String email;
  final String password;

  const NewCredentials({
    required this.email,
    required this.password,
  });

  factory NewCredentials.fromJson(Map<String, dynamic> json, String emailKey) {
    return NewCredentials(
      email: json[emailKey],
      password: json['newPassword'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

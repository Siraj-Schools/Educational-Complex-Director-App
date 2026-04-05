class WrongCredentialsException implements Exception {
  final String message;
  WrongCredentialsException({required this.message});
}

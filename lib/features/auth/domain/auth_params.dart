class SignupParams {
  final String name;
  final String email;
  final String password;
  final String passwordConfirm;

  const SignupParams({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirm,
  });
}

class LoginParams {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});
}

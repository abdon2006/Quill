import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String id;
  final String accessToken;
  final String refreshToken;
  final String name;
  final String email;

  const AuthEntity({
    required this.id,
    required this.accessToken,
    required this.refreshToken,
    required this.name,
    required this.email,
  });

  @override
  List<Object?> get props => [id, accessToken, refreshToken, name, email];
}

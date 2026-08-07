import 'package:quill/features/auth/domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  const AuthModel({
    required super.id,
    required super.accessToken,
    required super.refreshToken,
    required super.name,
    required super.email,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    final user = json['data']['user'];
    return AuthModel(
      id: user['id'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      name: user['name'],
      email: user['email'],
    );
  }
}

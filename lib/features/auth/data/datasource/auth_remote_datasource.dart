import 'package:quill/features/auth/domain/auth_params.dart';
import 'package:quill/features/auth/domain/entities/auth_entity.dart';

abstract class AuthRemoteDatasource {
  Future<AuthEntity> signup(SignupParams params);
  Future<AuthEntity> login(LoginParams params);
}

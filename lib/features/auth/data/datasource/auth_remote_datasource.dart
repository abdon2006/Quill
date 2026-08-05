import 'package:quill/core/usecases/base_usecase.dart';
import 'package:quill/features/auth/domain/auth_params.dart';
import 'package:quill/features/auth/domain/entities/auth_entity.dart';
import 'package:quill/features/auth/domain/entities/user_entity.dart';

abstract class AuthRemoteDatasource {
  Future<AuthEntity> signup(SignupParams params);
  Future<AuthEntity> login(LoginParams params);
  Future<UserEntity> fetchUserData(NoParams params);
}

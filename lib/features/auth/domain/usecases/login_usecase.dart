import 'package:dartz/dartz.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/features/auth/domain/auth_params.dart';
import 'package:quill/features/auth/domain/entities/auth_entity.dart';
import 'package:quill/features/auth/domain/repositories/auth_repository.dart';
import 'package:quill/core/usecases/base_usecase.dart';

class LoginUsecase extends BaseUsecase<AuthEntity, LoginParams> {
  final AuthRepository authRepository;
  LoginUsecase({required this.authRepository});

  @override
  Future<Either<Failure, AuthEntity>> call(LoginParams params) async =>
      await authRepository.login(params);
}

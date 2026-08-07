import 'package:dartz/dartz.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/core/usecases/base_usecase.dart';
import 'package:quill/features/auth/domain/auth_params.dart';
import 'package:quill/features/auth/domain/entities/auth_entity.dart';
import 'package:quill/features/auth/domain/repositories/auth_repository.dart';

class SignupUsecase extends BaseUsecase<AuthEntity, SignupParams> {
  final AuthRepository authRepository;
  SignupUsecase({required this.authRepository});

  @override
  Future<Either<Failure, AuthEntity>> call(SignupParams params) async =>
      await authRepository.signup(params);
}

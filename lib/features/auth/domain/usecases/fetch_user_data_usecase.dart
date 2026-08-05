import 'package:dartz/dartz.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/core/usecases/base_usecase.dart';
import 'package:quill/features/auth/domain/entities/user_entity.dart';
import 'package:quill/features/auth/domain/repositories/auth_repository.dart';

class FetchUserDataUsecase extends BaseUsecase<UserEntity, NoParams> {
  final AuthRepository authRepository;

  FetchUserDataUsecase({required this.authRepository});
  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    final response = await authRepository.fetchUserData(params);
    return response;
  }
}

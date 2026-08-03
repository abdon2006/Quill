import 'package:dartz/dartz.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:quill/features/auth/domain/auth_params.dart';
import 'package:quill/features/auth/domain/entities/auth_entity.dart';
import 'package:quill/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource authRemoteDatasource;

  AuthRepositoryImpl({required this.authRemoteDatasource});
  @override
  Future<Either<Failure, AuthEntity>> login(LoginParams params) async {
    try {
      final response = await authRemoteDatasource.login(params);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> signup(SignupParams params) async {
    try {
      final response = await authRemoteDatasource.signup(params);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

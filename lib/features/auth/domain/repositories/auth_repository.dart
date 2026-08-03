import 'package:dartz/dartz.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/features/auth/domain/auth_params.dart';
import 'package:quill/features/auth/domain/entities/auth_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthEntity>> signup(SignupParams params);
  Future<Either<Failure, AuthEntity>> login(LoginParams params);
}

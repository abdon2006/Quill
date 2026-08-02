import 'package:dartz/dartz.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/features/home/domain/entities/book_entity.dart';
import 'package:quill/features/home/domain/repositories/book_repository.dart';

abstract class BaseUseCase<type, Params> {
  Future<Either<Failure, type>> call(Params params);
}

class NoParams {
  const NoParams();
}


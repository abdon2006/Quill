import 'package:dartz/dartz.dart';
import 'package:quill/core/errors/failures.dart';

abstract class BaseUseCase<type, Params> {
  Future<Either<Failure, type>> call(Params params);
}

class NoParams {
  const NoParams();
}

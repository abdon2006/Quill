import 'package:dartz/dartz.dart';
import 'package:quill/core/errors/failures.dart';

abstract class BaseUsecase<T, P> {
  Future<Either<Failure, T>> call(P params);
}

class NoParams {
  const NoParams();
}

abstract class Failure {
  final String message;
  const Failure({required this.message});
}

class ServerFailure extends Failure {
  final int? statusCode;
  ServerFailure({required super.message, this.statusCode});
}

class NetworkFailure extends Failure {
  NetworkFailure({required super.message});
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({required super.message});
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({required super.message});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

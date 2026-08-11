abstract class Failure {
  final String message;
  const Failure({required this.message});
}

class ServerFailure extends Failure {
  final int? statusCode;

  ServerFailure({required super.message, this.statusCode});
  @override
  String toString() => "ServerFailure : $message";
}

class NetworkFailure extends Failure {
  NetworkFailure({required super.message});
  @override
  String toString() => "NetworkFailure : $message";
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({required super.message});
  @override
  String toString() => "TimeoutFailure : $message";
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({required super.message});
  @override
  String toString() => "UnauthorizedFailure : $message";
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
  @override
  String toString() => "CacheFailure : $message";
}

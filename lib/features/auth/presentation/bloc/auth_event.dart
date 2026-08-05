import 'package:equatable/equatable.dart';
import 'package:quill/core/usecases/base_usecase.dart';
import 'package:quill/features/auth/domain/auth_params.dart';

abstract class AuthEvent extends Equatable {}

class SignUpEvent extends AuthEvent {
  final SignupParams params;

  SignUpEvent({required this.params});
  @override
  List<Object?> get props => [params];
}

class LoginEvent extends AuthEvent {
  final LoginParams params;

  LoginEvent({required this.params});
  @override
  List<Object?> get props => [params];
}

class FetchUserDataEvent extends AuthEvent {
  final NoParams params;

  FetchUserDataEvent({required this.params});
  @override
  List<Object?> get props => [params];
}

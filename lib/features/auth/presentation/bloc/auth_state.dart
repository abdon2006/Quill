import 'package:equatable/equatable.dart';
import 'package:quill/features/auth/domain/entities/auth_entity.dart';
import 'package:quill/features/auth/domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {}

class AuthInitial extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthLoading extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
  @override
  List<Object?> get props => [message];
}

class SignupSuccess extends AuthState {
  final AuthEntity authEntity;

  SignupSuccess({required this.authEntity});
  @override
  List<Object?> get props => [authEntity];
}

class LoginSuccess extends AuthState {
  final AuthEntity authEntity;

  LoginSuccess({required this.authEntity});
  @override
  List<Object?> get props => [authEntity];
}

class FetchUserDataSuccess extends AuthState {
  final UserEntity userEntity;

  FetchUserDataSuccess({required this.userEntity});
  @override
  List<Object?> get props => [userEntity];
}

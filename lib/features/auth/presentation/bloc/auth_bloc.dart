import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quill/features/auth/domain/usecases/login_usecase.dart';
import 'package:quill/features/auth/domain/usecases/signup_usecase.dart';
import 'package:quill/features/auth/presentation/bloc/auth_event.dart';
import 'package:quill/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignupUsecase signupUsecase;
  final LoginUsecase loginUsecase;
  AuthBloc({required this.loginUsecase, required this.signupUsecase})
    : super(AuthInitial()) {
    on<SignUpEvent>((event, emit) async {
      emit(AuthLoading());
      final response = await signupUsecase(event.params);
      response.fold(
        (failure) => emit(AuthError(message: failure.message)),
        (success) => emit(SignupSuccess(authEntity: success)),
      );
    });

    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      final response = await loginUsecase(event.params);
      response.fold(
        (failure) => emit(AuthError(message: failure.message)),
        (success) => emit(LoginSuccess(authEntity: success)),
      );
    });
  }
}

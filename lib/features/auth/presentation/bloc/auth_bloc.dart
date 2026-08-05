import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quill/core/storage/app_storage.dart';
import 'package:quill/features/auth/domain/usecases/login_usecase.dart';
import 'package:quill/features/auth/domain/usecases/signup_usecase.dart';
import 'package:quill/features/auth/presentation/bloc/auth_event.dart';
import 'package:quill/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignupUsecase signupUsecase;
  final LoginUsecase loginUsecase;
  final AppStorage appStorage;
  AuthBloc({
    required this.loginUsecase,
    required this.signupUsecase,
    required this.appStorage,
  }) : super(AuthInitial()) {
    on<SignUpEvent>((event, emit) async {
      emit(AuthLoading());
      final response = await signupUsecase(event.params);
      await response.fold(
        (failure) async => emit(AuthError(message: failure.message)),
        (success) async {
          await appStorage.saveid(success.id);
          await appStorage.saveAccessToken(success.accessToken);
          await appStorage.saveRefreshToken(success.refreshToken);
          emit(SignupSuccess(authEntity: success));
        },
      );
    });

    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      final response = await loginUsecase(event.params);
      await response.fold(
        (failure) async => emit(AuthError(message: failure.message)),
        (success) async {
          await appStorage.saveid(success.id);
          await appStorage.saveAccessToken(success.accessToken);
          await appStorage.saveRefreshToken(success.refreshToken);
          emit(LoginSuccess(authEntity: success));
        },
      );
    });
  }
}

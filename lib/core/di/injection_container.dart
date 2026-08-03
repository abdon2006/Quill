import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:quill/core/constants/api_constants.dart';
import 'package:quill/core/network/auth_interceptor.dart';
import 'package:quill/core/network/network_service.dart';
import 'package:quill/core/storage/app_storage.dart';
import 'package:quill/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:quill/features/auth/data/datasource/auth_remote_datasource_impl.dart';
import 'package:quill/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:quill/features/auth/domain/repositories/auth_repository.dart';
import 'package:quill/features/auth/domain/usecases/login_usecase.dart';
import 'package:quill/features/auth/domain/usecases/signup_usecase.dart';
import 'package:quill/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quill/features/home/data/dataSources/book_remote_data_source_impl.dart';
import 'package:quill/features/home/data/dataSources/book_remote_datasource.dart';
import 'package:quill/features/home/data/repositories/book_repository_impl.dart';
import 'package:quill/features/home/domain/repositories/book_repository.dart';
import 'package:quill/features/home/domain/usecases/fetch_books_usecase.dart';
import 'package:quill/features/home/presentation/bloc/home_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../locale/cubit/locale_cubit.dart';
import '../theme/cubit/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> setupDI() async {
  // ── External ─────────────────────────────────
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  // ── Core Cubits ──────────────────────────────
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit(sl()));
  sl.registerLazySingleton<LocaleCubit>(() => LocaleCubit(sl()));

  /// App Storage
  sl.registerLazySingleton<AppStorage>(() => AppStorage());

  /// Dio
  sl.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        headers: ApiConstants.headers,
        receiveTimeout: ApiConstants.receiveTimeout,
      ),
    ),
  );

  /// AuthInterceptor
  sl.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(appStorage: sl()),
  );

  /// Network Service
  sl.registerLazySingleton<NetworkService>(
    () => NetworkService(authInterceptor: sl(), dio: sl()),
  );

  /// Book & Home
  sl.registerLazySingleton<BookRemoteDatasource>(
    () => BookRemoteDataSourceImpl(networkService: sl()),
  );
  sl.registerLazySingleton<BookRepository>(
    () => BookRepositoryImpl(remoteDatasource: sl()),
  );
  sl.registerLazySingleton<FetchBooksUsecase>(
    () => FetchBooksUsecase(bookRepository: sl()),
  );
  sl.registerFactory<HomeBloc>(() => HomeBloc(fetchBooksUsecase: sl()));

  /// Auth
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(networkService: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authRemoteDatasource: sl()),
  );
  sl.registerLazySingleton<SignupUsecase>(
    () => SignupUsecase(authRepository: sl()),
  );
  sl.registerLazySingleton<LoginUsecase>(
    () => LoginUsecase(authRepository: sl()),
  );
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(loginUsecase: sl(), signupUsecase: sl(), appStorage: sl()),
  );
}

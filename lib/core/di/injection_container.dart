import 'package:get_it/get_it.dart';
import 'package:quill/core/network/network_service.dart';
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

  sl.registerLazySingleton<NetworkService>(() => NetworkService());
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
}

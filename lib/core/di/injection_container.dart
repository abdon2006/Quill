import 'package:get_it/get_it.dart';
import 'package:quill/core/network/network_service.dart';
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
}

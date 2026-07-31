import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const _key = 'app_theme_mode';
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs) : super(const ThemeState()) {
    _loadSavedTheme();
  }

  void _loadSavedTheme() {
    final saved = _prefs.getString(_key);
    if (saved == AppThemeMode.dark.name) {
      emit(state.copyWith(themeMode: AppThemeMode.dark));
    }
  }

  void setLight() {
    _prefs.setString(_key, AppThemeMode.light.name);
    emit(state.copyWith(themeMode: AppThemeMode.light));
  }

  void setDark() {
    _prefs.setString(_key, AppThemeMode.dark.name);
    emit(state.copyWith(themeMode: AppThemeMode.dark));
  }

  void toggle() {
    state.isDark ? setLight() : setDark();
  }
}

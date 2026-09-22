import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quill/core/constants/storage_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs) : super(const ThemeState()) {
    _loadSavedTheme();
  }
  void setSystem() {
    _prefs.setString(StorageConstants.themeMode, AppThemeMode.system.name);
    emit(state.copyWith(themeMode: AppThemeMode.system));
  }

  void _loadSavedTheme() {
    final saved = _prefs.getString(StorageConstants.themeMode);
    if (saved == AppThemeMode.dark.name) {
      emit(state.copyWith(themeMode: AppThemeMode.dark));
    } else if (saved == AppThemeMode.light.name) {
      emit(state.copyWith(themeMode: AppThemeMode.light));
    }
    
  }

  void setLight() {
    _prefs.setString(StorageConstants.themeMode, AppThemeMode.light.name);
    emit(state.copyWith(themeMode: AppThemeMode.light));
  }

  void setDark() {
    _prefs.setString(StorageConstants.themeMode, AppThemeMode.dark.name);
    emit(state.copyWith(themeMode: AppThemeMode.dark));
  }

  void toggle() {
    state.isDark ? setLight() : setDark();
  }
}

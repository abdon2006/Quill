part of 'theme_cubit.dart';

enum AppThemeMode { light, dark }

class ThemeState {
  final AppThemeMode themeMode;

  const ThemeState({this.themeMode = AppThemeMode.light});

  bool get isDark => themeMode == AppThemeMode.dark;

  ThemeState copyWith({AppThemeMode? themeMode}) {
    return ThemeState(themeMode: themeMode ?? this.themeMode);
  }
}

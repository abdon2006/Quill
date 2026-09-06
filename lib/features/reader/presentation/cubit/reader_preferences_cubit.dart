import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quill/features/reader/presentation/cubit/reader_preferences_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReaderPreferencesCubit extends Cubit<ReaderPreferencesState> {
  ReaderPreferencesCubit()
    : super(
        ReaderPreferencesState(
          fontSize: 16,
          lineSpacing: 1.8,
          fontFamily: ReaderFontFamily.plusJakartaSans,
          isBold: false,
          isJustified: true,
          bgColor: ReaderBgColor.cream,
          theme: ReaderTheme.system,
          scrollMode: ReaderScrollMode.scroll,
          isItalic: false,
        ),
      );

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final savedState = prefs.getString('readerPrefs');
    if (savedState != null) {
      final map = jsonDecode(savedState);
      print('----------LOADED THE OLD PREFERENCES ----------');
      emit(
        ReaderPreferencesState(
          fontSize: map['fontSize'],
          lineSpacing: map['lineSpacing'],
          fontFamily: ReaderFontFamily.values.byName(map['fontFamily']),
          isBold: map['isBold'],
          isJustified: map['isJustified'],
          bgColor: ReaderBgColor.values.byName(map['bgColor']),
          theme: ReaderTheme.values.byName(map['theme']),
          scrollMode: ReaderScrollMode.values.byName(map['scrollMode']),
          isItalic: map['isItalic'],
        ),
      );
    }
  }

  void setFontSize(double size) => emit(state.copyWith(fontSize: size));
  void setLineSpacing(double spacing) =>
      emit(state.copyWith(lineSpacing: spacing));
  void setFontFamily(ReaderFontFamily fontFamily) =>
      emit(state.copyWith(fontFamily: fontFamily));

  void setIsBold(bool isBold) => emit(state.copyWith(isBold: isBold));
  void setIsJustified(bool isJustified) =>
      emit(state.copyWith(isJustified: isJustified));
  void setBgColor(ReaderBgColor bgColor) =>
      emit(state.copyWith(bgColor: bgColor));
  void setTheme(ReaderTheme newTheme) => emit(state.copyWith(theme: newTheme));
  void setScrollMode(ReaderScrollMode newScrollMode) =>
      emit(state.copyWith(scrollMode: newScrollMode));
  void setIsItalic(bool isItalic) => emit(state.copyWith(isItalic: isItalic));

  void applynewTheme(ReaderPreferencesState newState) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'readerPrefs',
      jsonEncode({
        'fontSize': newState.fontSize,
        'lineSpacing': newState.lineSpacing,
        'fontFamily': newState.fontFamily.name,
        'isBold': newState.isBold,
        'isJustified': newState.isJustified,
        'bgColor': newState.bgColor.name,
        'theme': newState.theme.name,
        'scrollMode': newState.scrollMode.name,
        'isItalic': newState.isItalic,
      }),
    );
    emit(newState);
  }
}

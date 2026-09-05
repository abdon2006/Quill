import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quill/features/reader/presentation/cubit/reader_preferences_state.dart';

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
  void applynewTheme(ReaderPreferencesState newState) => emit(newState);
}

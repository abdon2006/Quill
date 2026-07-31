import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quill/core/constants/storage_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  final SharedPreferences _prefs;

  LocaleCubit(this._prefs) : super(const LocaleState()) {
    _loadSavedLocale();
  }

  void _loadSavedLocale() {
    final saved = _prefs.getString(StorageConstants.locale);
    if (saved != null) {
      emit(state.copyWith(locale: Locale(saved)));
    }
  }

  void setEnglish(BuildContext context) {
    _prefs.setString(StorageConstants.locale, 'en');
    context.setLocale(const Locale('en'));
    emit(state.copyWith(locale: const Locale('en')));
  }

  void setArabic(BuildContext context) {
    _prefs.setString(StorageConstants.locale, 'ar');
    context.setLocale(const Locale('ar'));
    emit(state.copyWith(locale: const Locale('ar')));
  }

  /// دي اللي هننده عليها اصلا وهنستعملها
  void toggle(BuildContext context) {
    state.isArabic ? setEnglish(context) : setArabic(context);
  }
}

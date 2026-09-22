part of 'locale_cubit.dart';


class LocaleState {
  final Locale locale;

  const LocaleState({this.locale = const Locale('en')});

  bool get isArabic => locale.languageCode == 'ar';

  LocaleState copyWith({Locale? locale}) {
    return LocaleState(locale: locale ?? this.locale);
  }
}

part of 'locale_cubit.dart';

/// ده الفيال اللي بيشي حالة اللغ الحالية بتاعة الابلكيشن
class LocaleState {
  final Locale locale;

  const LocaleState({this.locale = const Locale('en')});

  bool get isArabic => locale.languageCode == 'ar';

  LocaleState copyWith({Locale? locale}) {
    return LocaleState(locale: locale ?? this.locale);
  }
}

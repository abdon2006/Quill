import 'package:equatable/equatable.dart';

enum ReaderTheme { system, light, dark }

enum ReaderBgColor { warm, cream, white, dark }

enum ReaderScrollMode { scroll, pages }

enum ReaderFontFamily {
  plusJakartaSans,
  lora,
  merriweather;

  String get fontName => switch (this) {
    ReaderFontFamily.plusJakartaSans => 'Plus Jakarta Sans',
    ReaderFontFamily.lora => 'Lora',
    ReaderFontFamily.merriweather => 'Merriweather',
  };
}

class ReaderPreferencesState extends Equatable {
  final double fontSize;
  final double lineSpacing;
  final ReaderFontFamily fontFamily;
  final bool isBold;
  final bool isItalic;
  final bool isJustified;
  final ReaderBgColor bgColor;
  final ReaderTheme theme;
  final ReaderScrollMode scrollMode;

  const ReaderPreferencesState({
    required this.fontSize,
    required this.lineSpacing,
    required this.fontFamily,
    required this.isBold,
    required this.isJustified,
    required this.bgColor,
    required this.theme,
    required this.scrollMode,
    required this.isItalic,
  });

  ReaderPreferencesState copyWith({
    double? fontSize,
    double? lineSpacing,
    ReaderFontFamily? fontFamily,
    bool? isBold,
    bool? isJustified,
    ReaderBgColor? bgColor,
    ReaderTheme? theme,
    ReaderScrollMode? scrollMode,
    bool? isItalic,
  }) {
    return ReaderPreferencesState(
      fontSize: fontSize ?? this.fontSize,
      lineSpacing: lineSpacing ?? this.lineSpacing,
      fontFamily: fontFamily ?? this.fontFamily,
      isBold: isBold ?? this.isBold,
      isJustified: isJustified ?? this.isJustified,
      bgColor: bgColor ?? this.bgColor,
      theme: theme ?? this.theme,
      scrollMode: scrollMode ?? this.scrollMode,
      isItalic: isItalic ?? this.isItalic,
    );
  }

  @override
  String toString() =>
      '''
      fontSize : $fontSize , 
    lineSpacing : $lineSpacing , 
    fontFamily : $fontFamily , 
    isBold : $isBold , 
    isJustified : $isJustified , 
    isItalic : $isItalic
    bgColor : $bgColor , 
    theme : $theme , 
    scrollMode : $scrollMode , 
    ''';

  @override
  List<Object?> get props => [
    fontSize,
    lineSpacing,
    fontFamily,
    isBold,
    isJustified,
    bgColor,
    theme,
    scrollMode,
    isItalic,
  ];
}

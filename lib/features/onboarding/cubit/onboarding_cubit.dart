import 'package:flutter_bloc/flutter_bloc.dart';

enum OnboardingStage {
  entering,
  initial,
  scene1,
  scene2,
  scene3,
  finale,
  leavingButton, // مرحلة اختفاء الزرار
  leavingText, // مرحلة اختفاء النص
  leavingFeather, // مرحلة طيران الريشة
}

class OnboardingCubit extends Cubit<OnboardingStage> {
  OnboardingCubit() : super(OnboardingStage.entering) {
    _startEntranceScene();
  }

  Future<void> _startEntranceScene() async {
    // بندي للريشة ثانيتين عشان تنزل من فوق براحتها وتستقر
    await Future.delayed(const Duration(seconds: 2));

    // بعد ما تستقر، نظهر الزرار الأولاني
    if (!isClosed) {
      emit(OnboardingStage.initial);
    }
  }

  Future<void> startJourney() async {
    emit(OnboardingStage.scene1);
    await Future.delayed(const Duration(seconds: 4));

    emit(OnboardingStage.scene2);
    await Future.delayed(const Duration(seconds: 4));

    emit(OnboardingStage.scene3);
    await Future.delayed(const Duration(seconds: 4));

    emit(OnboardingStage.finale);
  }

  // الدالة الجديدة للخروج السينمائي المتدرج
  Future<void> endJourney() async {
    emit(OnboardingStage.leavingButton);
    await Future.delayed(
      const Duration(milliseconds: 300),
    ); // استنى الزرار يختفي

    emit(OnboardingStage.leavingText);
    await Future.delayed(const Duration(milliseconds: 400)); // استنى النص يختفي

    emit(OnboardingStage.leavingFeather); // طير الريشة واستعد للنقلة
  }
}

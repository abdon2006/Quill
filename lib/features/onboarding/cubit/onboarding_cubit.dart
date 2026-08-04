import 'package:flutter_bloc/flutter_bloc.dart';

enum OnboardingStage {
  initial, // الريشة بتظهر والزرار موجود
  scene1, // Read without distraction
  scene2, // Feel every emotion
  scene3, // AI scene
  finale, // Welcome to Quill
}

class OnboardingCubit extends Cubit<OnboardingStage> {
  OnboardingCubit() : super(OnboardingStage.initial);

  Future<void> startJourney() async {
    // Scene 1 — الريشة تتحرك لفوق والنص يظهر
    emit(OnboardingStage.scene1);
    await Future.delayed(const Duration(seconds: 4));

    // Scene 2 — Feel every emotion
    emit(OnboardingStage.scene2);
    await Future.delayed(const Duration(seconds: 4));

    // Scene 3 — AI
    emit(OnboardingStage.scene3);
    await Future.delayed(const Duration(seconds: 4));

    // Finale
    emit(OnboardingStage.finale);
  }
}

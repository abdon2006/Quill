import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quill/core/theme/app_duration.dart';

enum OnboardingStage {
  entering,
  initial,
  scene1,
  scene2,
  scene3,
  finale,
  leavingButton, 
  leavingText, 
  leavingFeather, 
}

class OnboardingCubit extends Cubit<OnboardingStage> {
  OnboardingCubit() : super(OnboardingStage.entering) {
    _startEntranceScene();
  }

  Future<void> _startEntranceScene() async {
    
    await Future.delayed(AppDuration.breathe);

    
    if (!isClosed) {
      emit(OnboardingStage.initial);
    }
  }

  Future<void> startJourney() async {
    emit(OnboardingStage.scene1);
    await Future.delayed(AppDuration.cue);

    emit(OnboardingStage.scene2);
    await Future.delayed(AppDuration.cue);

    emit(OnboardingStage.scene3);
    await Future.delayed(AppDuration.cue);

    emit(OnboardingStage.finale);
  }

  
  Future<void> endJourney() async {
    emit(OnboardingStage.leavingButton);
    await Future.delayed(AppDuration.normal); 

    emit(OnboardingStage.leavingText);
    await Future.delayed(AppDuration.switchOut); 

    emit(OnboardingStage.leavingFeather); 
  }
}

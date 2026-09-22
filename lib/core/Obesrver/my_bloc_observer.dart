

import 'package:flutter_bloc/flutter_bloc.dart';

class MyBlocObserver extends BlocObserver {
  
  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    
  }

  
  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    
    super.onEvent(bloc, event);
  }

  
  
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    
    super.onChange(bloc, change);
  }

  
  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    
    super.onTransition(bloc, transition);
  }

  
  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    
    super.onError(bloc, error, stackTrace);
  }

  
  @override
  void onClose(BlocBase<dynamic> bloc) {
    
    super.onClose(bloc);
  }
}

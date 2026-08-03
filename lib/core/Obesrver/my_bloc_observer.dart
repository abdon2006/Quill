// ignore_for_file: avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';

class MyBlocObserver extends BlocObserver {
  // when get an instance
  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    print("on create : ${bloc.runtimeType}");
  }

  // when event added
  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    print("on Event : ${bloc.runtimeType} , $event");
    super.onEvent(bloc, event);
  }

  // for Bloc only
  // when proccess an event
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    print("on Change : ${bloc.runtimeType} , $change");
    super.onChange(bloc, change);
  }

  // state actually changed
  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    print("on Transition : ${bloc.runtimeType} , $transition");
    super.onTransition(bloc, transition);
  }

  // something threw inside the BLoC
  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    print("on Error : ${bloc.runtimeType}, $error");
    super.onError(bloc, error, stackTrace);
  }

  // BLoC was disposed
  @override
  void onClose(BlocBase<dynamic> bloc) {
    print("on Close : ${bloc.runtimeType}");
    super.onClose(bloc);
  }
}

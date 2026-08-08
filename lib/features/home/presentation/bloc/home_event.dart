import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {}

class FetchHomeBooksEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}
class RefreshBookEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

import 'package:equatable/equatable.dart';

abstract class SearchHistoryState extends Equatable {
  const SearchHistoryState();
  @override
  List<Object> get props => [];
}

class SearchHistoryInitial extends SearchHistoryState {}

class SearchHistoryLoading extends SearchHistoryState {}

class SearchHistoryLoaded extends SearchHistoryState {
  final List<String> searchHistory;
  const SearchHistoryLoaded(this.searchHistory);

  @override
  List<Object> get props => [searchHistory];
}

class SearchHistoryError extends SearchHistoryState {
  final String message;
  const SearchHistoryError(this.message);

  @override
  List<Object> get props => [message];
}

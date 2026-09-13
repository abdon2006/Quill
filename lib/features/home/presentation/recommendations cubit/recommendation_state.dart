import 'package:equatable/equatable.dart';
import 'package:quill/features/home/domain/entities/book_entity.dart';

abstract class RecommendationState extends Equatable {}

class RecommendationInitial extends RecommendationState {
  RecommendationInitial();

  @override
  List<Object?> get props => [];
}

class RecommendationLoading extends RecommendationState {
  RecommendationLoading();

  @override
  List<Object?> get props => [];
}

class RecommendationSuccess extends RecommendationState {
  final List<BookEntity> books;
  RecommendationSuccess({required this.books});

  @override
  List<Object?> get props => [books];
}

class RecommendationError extends RecommendationState {
  RecommendationError();

  @override
  List<Object?> get props => [];
}

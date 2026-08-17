import 'package:equatable/equatable.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/features/home/domain/entities/book_entity.dart';

abstract class HomeState extends Equatable {}

class HomeInitial extends HomeState {
  @override
  List<Object?> get props => [];
}

class HomeError extends HomeState {
  final Failure failure;
  final List<BookEntity>? cachedBooks;
  HomeError({required this.failure, required this.cachedBooks});
  @override
  List<Object?> get props => [failure, cachedBooks];
}

class HomeLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

class FetchBooksSuccess extends HomeState {
  final List<BookEntity> books;
  FetchBooksSuccess({required this.books});
  @override
  List<Object?> get props => [books];
}

class GetBookByIdSuccess extends HomeState {
  final BookEntity book;

  GetBookByIdSuccess({required this.book});
  @override
  List<Object?> get props => [book];
}

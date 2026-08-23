import 'package:equatable/equatable.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/features/library/domain/entities/wishlist_entity.dart';

abstract class LibraryState extends Equatable {}

class LibraryInitial extends LibraryState {
  @override
  List<Object?> get props => [];
}

class LibraryLoading extends LibraryState {
  @override
  List<Object?> get props => [];
}

class LibraryError extends LibraryState {
  final Failure failure;

  LibraryError({required this.failure});
  @override
  List<Object?> get props => [failure];
}

class AddSuccessState extends LibraryState {
  @override
  List<Object?> get props => [];
}

class RemoveSuccessState extends LibraryState {
  @override
  List<Object?> get props => [];
}

class FetchSuccessState extends LibraryState {
  final List<WishlistEntity> books;

  FetchSuccessState({required this.books});
  @override
  List<Object?> get props => [books];
}

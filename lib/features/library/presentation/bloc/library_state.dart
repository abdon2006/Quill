import 'package:equatable/equatable.dart';
import 'package:quill/features/library/domain/Entities/wishlist_entity.dart';

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
  final String message;

  LibraryError({required this.message});
  @override
  List<Object?> get props => [message];
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

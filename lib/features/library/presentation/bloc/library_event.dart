import 'package:equatable/equatable.dart';

abstract class LibraryEvent extends Equatable {}

class AddToWishlistEvent extends LibraryEvent {
  final String bookId;

  AddToWishlistEvent({required this.bookId});
  @override
  List<Object?> get props => [bookId];
}
class RemoveFromWishlistEvent extends LibraryEvent {
  final String bookId;

  RemoveFromWishlistEvent({required this.bookId});
  @override
  List<Object?> get props => [bookId];
}

class FetchWishlistEvent extends LibraryEvent {

  @override
  List<Object?> get props => [];
}
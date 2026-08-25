import 'package:equatable/equatable.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/features/reader/data/models/local_book.dart';

abstract class ReaderState extends Equatable {}

class ReaderLoading extends ReaderState {
  @override
  List<Object?> get props => [];
}

class ReaderInitial extends ReaderState {
  @override
  List<Object?> get props => [];
}

class ReaderFailure extends ReaderState {
  final Failure failure;

  ReaderFailure({required this.failure});
  @override
  List<Object?> get props => [failure];
}

class UploadBookSuccess extends ReaderState {
  @override
  List<Object?> get props => [];
}

class RemoveBookSuccess extends ReaderState {
  @override
  List<Object?> get props => [];
}

class FetchLocalBookSuccess extends ReaderState {
  final LocalBook book;

  FetchLocalBookSuccess({required this.book});
  @override
  List<Object?> get props => [book];
}

class UpdateBookSuccess extends ReaderState {
  @override
  List<Object?> get props => [];
}

class FetchLocalBooksSuccess extends ReaderState {
  final List<LocalBook> localBooks;

  FetchLocalBooksSuccess({required this.localBooks});
  @override
  List<Object?> get props => [localBooks];
}

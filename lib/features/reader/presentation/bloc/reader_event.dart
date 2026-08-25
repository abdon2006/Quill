import 'package:equatable/equatable.dart';
import 'package:quill/features/reader/domain/usecases/params/update_book_params.dart';
import 'package:quill/features/reader/domain/usecases/params/upload_book_params.dart';

abstract class ReaderEvent extends Equatable {}

class UploadBookEvent extends ReaderEvent {
  final UploadBookParams book;
  UploadBookEvent({required this.book});

  @override
  List<Object?> get props => [book];
}

class RemoveBookEvent extends ReaderEvent {
  final int bookId;
  RemoveBookEvent({required this.bookId});
  @override
  List<Object?> get props => [bookId];
}

class UpdateBookEvent extends ReaderEvent {
  final UpdateBookParams params;
  UpdateBookEvent({required this.params});
  @override
  List<Object?> get props => [params];
}

class FetchLocalBookEvent extends ReaderEvent {
  final int bookId;
  FetchLocalBookEvent({required this.bookId});
  @override
  List<Object?> get props => [bookId];
}

class FetchLocalBooksEvent extends ReaderEvent {
  @override
  List<Object?> get props => [];
}

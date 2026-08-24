import 'package:equatable/equatable.dart';
import 'package:quill/features/reader/data/models/local_book.dart';

abstract class ReaderEvent extends Equatable {}

class UploadBookEvent extends ReaderEvent {
  final LocalBook book;
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

class UpdateBookProgressEvent extends ReaderEvent {
  final int bookId;
  final int newPage;
  UpdateBookProgressEvent({required this.bookId, required this.newPage});
  @override
  List<Object?> get props => [bookId, newPage];
}

class FetchLocalBookEvent extends ReaderEvent {
  final int bookId;
  FetchLocalBookEvent({required this.bookId});
  @override
  List<Object?> get props => [bookId];
}

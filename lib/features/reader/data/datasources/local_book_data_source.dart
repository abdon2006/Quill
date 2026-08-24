import 'package:quill/core/errors/failures.dart';
import 'package:quill/features/reader/data/models/local_book.dart';

abstract class LocalBookDataSource {
  Future<void> uploadBook(LocalBook book);
  Future<Either<LocalBook, Failure>> fetchBook(int bookId);
  Future<void> updateProgress(int bookId, double progress);
  Future<void> removeBook(int bookId);
}

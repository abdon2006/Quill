import 'package:quill/features/reader/data/models/local_book.dart';

abstract class LocalBookDataSource {
  Future<void> uploadBook(LocalBook book);
  Future<LocalBook> fetchBook(int bookId);
  Future<void> updateProgress(int bookId, int newPage);
  Future<void> removeBook(int bookId);
}

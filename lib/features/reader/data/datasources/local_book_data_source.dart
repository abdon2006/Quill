import 'package:quill/features/reader/data/models/local_book.dart';
import 'package:quill/features/reader/domain/usecases/params/update_book_params.dart';

abstract class LocalBookDataSource {
  Future<void> uploadBook(LocalBook book);
  Future<LocalBook> fetchBook(int bookId);
  Future<void> updateBook(UpdateBookParams params);
  Future<void> removeBook(int bookId);
  Future<List<LocalBook>> fetchLocalBooks();
}

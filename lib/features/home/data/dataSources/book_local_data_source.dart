import 'package:quill/features/home/data/models/book_cache.dart';

abstract class BookLocalDataSource {
  Future<void> cacheBook(List<BookCache> books);
  Future<List<BookCache>> readBooks();
  Future<bool> isCacheValid();
}

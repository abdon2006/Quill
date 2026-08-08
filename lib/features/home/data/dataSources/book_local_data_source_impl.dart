import 'package:isar/isar.dart';
import 'package:quill/features/home/data/dataSources/book_local_data_source.dart';
import 'package:quill/features/home/data/models/book_cache.dart';

class BookLocalDataSourceImpl implements BookLocalDataSource {
  final Isar isarInstance;
  BookLocalDataSourceImpl({required this.isarInstance});

  @override
  Future<void> cacheBook(List<BookCache> books) async {
    await isarInstance.writeTxn(() async {
      await isarInstance.bookCaches.clear();
      await isarInstance.bookCaches.putAll(books);
    });
  }

  @override
  Future<bool> isCacheValid() async {
    final firstBook = await isarInstance.bookCaches.where().findFirst();
    if (firstBook == null) return false;
    final diff = DateTime.now().difference(firstBook.cachedAt);
    return diff.inMinutes < 10;
  }

  @override
  Future<List<BookCache>> readBooks() async {
    return isarInstance.bookCaches.where().findAll();
  }
}

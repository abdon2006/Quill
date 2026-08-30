import 'package:isar/isar.dart';
import 'package:quill/features/reader/data/datasources/local_book_data_source.dart';
import 'package:quill/features/reader/data/models/local_book.dart';
import 'package:quill/features/reader/domain/usecases/params/update_book_params.dart';

class LocalBookDataSourceImpl implements LocalBookDataSource {
  final Isar isarInstance;

  LocalBookDataSourceImpl({required this.isarInstance});
  @override
  Future<LocalBook> fetchBook(int bookId) async {
    final book = await isarInstance.localBooks.get(bookId);
    if (book == null) throw Exception('Book not found');
    return book;
  }

  @override
  Future<void> removeBook(int bookId) async {
    await isarInstance.writeTxn(() async {
      await isarInstance.localBooks.delete(bookId);
    });
  }

  @override
  Future<void> updateBook(UpdateBookParams params) async {
    await isarInstance.writeTxn(() async {
      final book = await isarInstance.localBooks
          .filter()
          .isarIdEqualTo(params.bookId)
          .findFirst();
      if (book != null) {
        book.currentPage = params.currentPage;
        book.author = params.author;
        book.title = params.title;
        book.coverImagePath = params.coverImagePath;

        await isarInstance.localBooks.put(book);
      }
    });
  }

  @override
  Future<void> uploadBook(LocalBook book) async {
    await isarInstance.writeTxn(
      () async => await isarInstance.localBooks.put(book),
    );
  }

  @override
  Future<List<LocalBook>> fetchLocalBooks() async {
    return await isarInstance.localBooks.where().findAll();
  }
}

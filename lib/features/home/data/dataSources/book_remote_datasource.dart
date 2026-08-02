import 'package:quill/features/home/domain/entities/book_entity.dart';

abstract class BookRemoteDatasource {
  Future<List<BookEntity>> fetchBooks();
}

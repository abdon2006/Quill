import 'package:dartz/dartz.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/features/home/domain/entities/book_entity.dart';

abstract class BookRepository {
  Future<Either<Failure, List<BookEntity>>> fetchBooks();
  Future<bool> isCached();
  Future<Either<Failure, List<BookEntity>>> refreshBooks();
  Future<Either<Failure, BookEntity>> getBookById(String bookId);
  Future<List<BookEntity>> getCachedBooks();
}

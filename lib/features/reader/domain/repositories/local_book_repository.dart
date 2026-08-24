import 'package:dartz/dartz.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/features/reader/data/models/local_book.dart';

abstract class LocalBookRepository {
  Future<Either<Failure, void>> uploadBook(LocalBook book);
  Future<Either<Failure, LocalBook>> fetchBook(int bookId);
  Future<Either<Failure, void>> updateProgress(int bookId, int newPage);
  Future<Either<Failure, void>> removeBook(int bookId);
}

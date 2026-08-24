import 'package:dartz/dartz.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/features/reader/data/datasources/local_book_data_source.dart';
import 'package:quill/features/reader/data/models/local_book.dart';
import 'package:quill/features/reader/domain/repositories/local_book_repository.dart';

class LocalBookRepositoryImpl implements LocalBookRepository {
  final LocalBookDataSource bookLocalDataSource;

  LocalBookRepositoryImpl({required this.bookLocalDataSource});
  @override
  Future<Either<Failure, LocalBook>> fetchBook(int bookId) async {
    try {
      final response = await bookLocalDataSource.fetchBook(bookId);
      return Right(response);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeBook(int bookId) async {
    try {
      final response = await bookLocalDataSource.removeBook(bookId);
      return Right(response);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProgress(int bookId, int newPage) async {
    try {
      final response = await bookLocalDataSource.removeBook(bookId);
      return Right(response);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> uploadBook(LocalBook book) async {
    try {
      final response = await bookLocalDataSource.removeBook(bookId);
      return Right(response);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }
}

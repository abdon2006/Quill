import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/features/reader/data/datasources/local_book_data_source.dart';
import 'package:quill/features/reader/data/models/local_book.dart';
import 'package:quill/features/reader/domain/repositories/local_book_repository.dart';
import 'package:quill/features/reader/domain/usecases/upload_book_params.dart';

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
      final response = await bookLocalDataSource.updateProgress(
        bookId,
        newPage,
      );
      return Right(response);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> uploadBook(UploadBookParams book) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = book.fileName;
      final savedPath = '${dir.path}/$fileName';
      final localFile = await File(book.filePath).copy(savedPath);
      final localBook = _initLocalBook(book, localFile.path);
      final response = await bookLocalDataSource.uploadBook(localBook);
      return Right(response);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LocalBook>>> fetchLocalBooks() async {
    try {
      final response = await bookLocalDataSource.fetchLocalBooks();
      return Right(response);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }
}

LocalBook _initLocalBook(UploadBookParams params, String newPath) {
  final book = LocalBook();
  book.title = params.fileName.replaceAll('.pdf', '').replaceAll('.epub', '');
  book.filePath = newPath;
  book.fileType = params.fileExtension;
  book.author = 'Unknown Author';
  book.language = 'Unknown';
  book.categories = [];
  book.coverImagePath = null;
  book.currentPage = 0;
  book.totalPages = 0;
  book.importedAt = DateTime.now();
  return book;
}

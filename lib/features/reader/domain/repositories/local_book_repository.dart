import 'package:dartz/dartz.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/features/reader/data/models/local_book.dart';
import 'package:quill/features/reader/domain/usecases/params/update_book_params.dart';
import 'package:quill/features/reader/domain/usecases/params/upload_book_params.dart';

abstract class LocalBookRepository {
  Future<Either<Failure, void>> uploadBook(UploadBookParams book);
  Future<Either<Failure, LocalBook>> fetchBook(int bookId);
  Future<Either<Failure, void>> updateBook(UpdateBookParams params);
  Future<Either<Failure, void>> removeBook(int bookId);
  Future<Either<Failure, List<LocalBook>>> fetchLocalBooks();
}

import 'package:dartz/dartz.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/features/home/data/dataSources/book_remote_datasource.dart';
import 'package:quill/features/home/domain/entities/book_entity.dart';
import 'package:quill/features/home/domain/repositories/book_repository.dart';

class BookRepositoryImpl implements BookRepository {
  final BookRemoteDatasource remoteDatasource;

  BookRepositoryImpl({required this.remoteDatasource});
  @override
  Future<Either<Failure, List<BookEntity>>> fetchBooks() async {
    try {
      final response = await remoteDatasource.fetchBooks();
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
